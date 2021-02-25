//
//  APIClient.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Holds base API client logic.
internal class APIClient {

	typealias RequestCompletion = ((_ response: APIRequestResult) -> Void)?

	// MARK: - Constants

	/// Constants.
	internal enum Constants {
		static let validStatuses: Range<Int> = 200..<300
	}

	// MARK: - Vars

	/// Custom headers.
	internal var customHeader: VGSHTTPHeaders?

	/// Default request headers with vgs client info.
	internal static let defaultHttpHeaders: VGSHTTPHeaders = {
			// Add Headers
		let version = ProcessInfo.processInfo.operatingSystemVersion
		let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

		let source = VGSAnalyticsClient.Constants.Metadata.source
		let medium = VGSAnalyticsClient.Constants.Metadata.medium
    let trStatus = VGSAnalyticsClient.shared.shouldCollectAnalytics ? "default" : "none"

		return [
			"vgs-client": "source=\(source)&medium=\(medium)&content=\(Utils.vgsShowVersion)&osVersion=\(versionString)&vgsShowSessionId=\(VGSShowAnalyticsSession.shared.vgsShowSessionId)&tr=\(trStatus)"
		]
	}()

	/// URLSession object.
	internal let urlSession = URLSession(configuration: .ephemeral)

	/// Vault ID.
	private let vaultId: String

	/// Vault URL.
	private let vaultUrl: URL?

	/// Base URL depends on current api policy.
	internal var baseURL: URL? {
		return self.hostURLPolicy.url
	}

	/// Host URL policy. Determinates final URL to send reveal requests.
	internal var hostURLPolicy: APIHostURLPolicy

	/// Serial queue for syncing requests on resolving hostname flow.
	private let dataSyncQueue: DispatchQueue = .init(label: "iOS.VGSShowSDK.ResolveHostNameRequestsQueue")

	/// Sync semaphore.
	private let syncSemaphore: DispatchSemaphore = .init(value: 1)

	// MARK: - Initialization

	/// Initialization.
	/// - Parameters:
	///   - tenantId: `String` object, should be valid tenant id.
	///   - regionalEnvironment: `String` object, should be valid environment.
	///   - hostname: `String?` object, should be valid hostname or `nil`.
	///   - satellitePort: `Int?` object, custom port for satellite configuration. **IMPORTANT! Use only with .sandbox environment!**.
	required internal init(tenantId: String, regionalEnvironment: String, hostname: String?, satellitePort: Int?) {
		self.vaultUrl = VGSShow.generateVaultURL(tenantId: tenantId, regionalEnvironment: regionalEnvironment)
		self.vaultId = tenantId

		guard let validVaultURL = vaultUrl else {
			// Cannot resolve hostname with invalid Vault URL.
			self.hostURLPolicy = .invalidVaultURL
			return
		}

		// Check satellite port is *nil* for regular API flow.
		guard satellitePort == nil else {
			// Try to build satellite URL.
			guard let port = satellitePort, let satelliteURL = VGSShowSatelliteUtils.buildSatelliteURL(with: regionalEnvironment, hostname: hostname, satellitePort: port) else {

				// Use vault URL as fallback if cannot resolve satellite flow.
				self.hostURLPolicy = .vaultURL(validVaultURL)
				return
			}

			// Use satellite URL and return.
			self.hostURLPolicy = .satelliteURL(satelliteURL)

			let message = "Satellite has been configured successfully! Satellite URL is: \(satelliteURL.absoluteString)"
			let event = VGSLogEvent(level: .info, text: message)
			VGSLogger.shared.forwardLogEvent(event)

			return
		}

		guard let hostnameToResolve = hostname, !hostnameToResolve.isEmpty else {

			if let name = hostname, name.isEmpty {
				let message = "Hostname is invalid (empty) and will be ignored. Default Vault URL will be used."
				let event = VGSLogEvent(level: .warning, text: message, severityLevel: .error)
				VGSLogger.shared.forwardLogEvent(event)
			}

			// Use vault URL.
			self.hostURLPolicy = .vaultURL(validVaultURL)
			return
		}

		// Try to resolve hostname.
		self.hostURLPolicy = .customHostURL(.isResolving(hostnameToResolve))
		updateHost(with: hostnameToResolve)
	}

	// MARK: - Public

	internal func sendRequestWithJSON(path: String, method: VGSHTTPMethod = .post, value: VGSJSONData?, completion block: RequestCompletion) {

		let payload = VGSRequestPayloadBody.json(value)
		resolveURLForRequest(path: path, method: method, payload: payload, block: block)
	}

	// MARK: - Private

	/// Resolve URL for specific request. Send request if URL is resolved, otherwise enqueue request until hostname will be resolved.
	/// - Parameters:
	///   - path: `String` object, request path.
	///   - method: `VGSHTTPMethod` object.
	///   - payload: `VGSRequestPayloadBody` object.
	///   - block: `RequestCompletion` completion block.
	private func resolveURLForRequest(path: String, method: VGSHTTPMethod, payload: VGSRequestPayloadBody, block: RequestCompletion) {

		let url: URL?

		let infoEventText = "API will start request with current URL policy: \(hostURLPolicy.description)"
		let infoEvent = VGSLogEvent(level: .info, text: infoEventText)
		VGSLogger.shared.forwardLogEvent(infoEvent)

		switch hostURLPolicy {
		case .invalidVaultURL:
			url = nil
		case .satelliteURL(let satelliteURL):
			url = satelliteURL
		case .vaultURL(let vaultURL):
			url = vaultURL
		case .customHostURL(let status):
			switch status {
			case .resolved(let resolvedURL):
				url = resolvedURL
			case .useDefaultVault(let defaultVaultURL):
				url = defaultVaultURL
			case .isResolving(let hostnameToResolve):
				// URL is not resolved yet. Queue request.
				updateHost(with: hostnameToResolve) { (url) in
					self.sendDataRequestWithURL(url, path: path, method: method, payload: payload, block: block)
				}
				return
			}
		}

		guard let requestURL = url else {
			let message = "CONFIGURATION ERROR: NOT VALID ORGANIZATION PARAMETERS!!! CANNOT BUILD URL!!!"
			let event = VGSLogEvent(level: .warning, text: message, severityLevel: .error)
			VGSLogger.shared.forwardLogEvent(event)

			let invalidURLError = VGSShowError(type: .invalidConfigurationURL)
			block?(.failure(invalidURLError.code, nil, nil, invalidURLError))
			return
		}

		sendDataRequestWithURL(requestURL, path: path, method: method, payload: payload, block: block)
	}

	private func sendDataRequestWithURL(_ requestURL: URL, path: String, method: VGSHTTPMethod, payload: VGSRequestPayloadBody, block: RequestCompletion) {

		let encodingResult = payload.encodeToRequestBodyData()

		switch encodingResult {
		case .success(let data):
			// Setup headers.
			let headers = self.provideHeaders(with: payload.additionalHeaders)

			// Setup URLRequest with resolved URL.
			let url = requestURL.appendingPathComponent(path)

			var request = URLRequest(url: url)
			request.httpBody = data
			request.httpMethod = method.rawValue
			request.allHTTPHeaderFields = headers

			// Log request.
			VGSShowRequestLogger.logRequest(request, payload: payload)

			// Perform request.
			self.performRequest(request: request, completion: block)
		case .failure(let error):
			let text = "cannot encode payload \(payload.rawPayload ?? "Uknown payload format"), error: \(error)"
			let event = VGSLogEvent(level: .warning, text: text, severityLevel: .error)
			VGSLogger.shared.forwardLogEvent(event)

			block?(.failure(error.code, nil, nil, error))
		}
	}

	private func performRequest(request: URLRequest, completion block: RequestCompletion) {
		// Send data
		urlSession.dataTask(with: request) { (data, response, error) in
			DispatchQueue.main.async {
				if let error = error as NSError? {
					block?(.failure(error.code, data, response, error))
					return
				}
				let statusCode = (response as? HTTPURLResponse)?.statusCode ?? VGSErrorType.unexpectedResponseType.rawValue

				switch statusCode {
				case Constants.validStatuses:
					block?(.success(statusCode, data, response))
					return
				default:
					block?(.failure(statusCode, data, response, error))
					return
				}
			}
		}.resume()
	}

	// MARK: - Helpers

	private func provideHeaders(with additionalRequestHeaders: [String: String]) -> [String: String] {
		var headers: [String: String] = APIClient.defaultHttpHeaders

		// Add custom headers if need
		if let customerHeaders = customHeader, !customerHeaders.isEmpty {
			customerHeaders.keys.forEach({ (key) in
				headers[key] = customerHeaders[key]
			})
		}

		additionalRequestHeaders.keys.forEach({ (key) in
			headers[key] = additionalRequestHeaders[key]
		})

		return headers
	}

	// MARK: - Custom Host Name

	private func updateHost(with hostname: String, completion: ((URL) -> Void)? = nil) {

		dataSyncQueue.async {

			// Enter sync zone.
			self.syncSemaphore.wait()

			// Check if we already have URL. If yes, don't fetch it the same time.
			if let url = self.hostURLPolicy.url {
				completion?(url)
				// Exit sync zone.
				self.syncSemaphore.signal()
				return
			}

			// Resolve hostname.
			APIHostnameValidator.validateCustomHostname(hostname, tenantId: self.vaultId) {[weak self](url) in
				if var validUrl = url {

					// Update url scheme if needed.
					if !validUrl.hasSecureScheme(), let secureURL = URL.urlWithSecureScheme(from: validUrl) {
						validUrl = secureURL
					}

					self?.hostURLPolicy = .customHostURL(.resolved(validUrl))
					completion?(validUrl)

					let text = "✅ Success! VGSShowSDK hostname \(hostname) has been successfully resolved and will be used for requests!"
					let event = VGSLogEvent(level: .info, text: text)
					VGSLogger.shared.forwardLogEvent(event)

					// Exit sync zone.
					self?.syncSemaphore.signal()
					return
				} else {
					guard let strongSelf = self, let validVaultURL = self?.vaultUrl else {
						return
					}
					strongSelf.hostURLPolicy = .customHostURL(.useDefaultVault(validVaultURL))

					let text = "Vault URL will be used!"
					let event = VGSLogEvent(level: .warning, text: text, severityLevel: .error)
					VGSLogger.shared.forwardLogEvent(event)

					completion?(validVaultURL)

					// Exit sync zone.
					strongSelf.syncSemaphore.signal()
					return
				}
			}
		}
	}
}
