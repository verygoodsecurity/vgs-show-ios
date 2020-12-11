//
//  APIClient.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Key-value data type, usually used for response format.
public typealias VGSJSONData = [String: Any]

/// Key-value data type, used in http request headers.
public typealias VGSHTTPHeaders = [String: String]

/// HTTP request methods.
public enum VGSHTTPMethod: String {
	/// GET method.
	case get = "GET"

	/// POST method.
	case post = "POST"

	/// PUT method.
	case put = "PUT"

	/// PATCH method.
	case patch = "PATCH"

	/// DELETE method.
	case delete = "DELETE"
}

internal class APIClient {

	/// Response enum cases for SDK requests.
	enum RequestResult {
		/**
		Success response case.

		- Parameters:
		- code: response status code.
		- data: response **data** object.
		- response: URLResponse object represents a URL load response.
		*/
		case success(_ code: Int, _ data: Data?, _ response: URLResponse?)

		/**
		Failed response case.

		- Parameters:
		- code: response status code.
		- data: response **Data** object.
		- response: `URLResponse` object represents a URL load response.
		- error: `Error` object.
		*/
		case failure(_ code: Int, _ data: Data?, _ response: URLResponse?, _ error: Error?)
	}

	typealias RequestCompletion = ((_ response: APIClient.RequestResult) -> Void)?

	// MARK: - Constants

	enum Constants {
		static let validStatuses: Range<Int> = 200..<300
	}

	// MARK: - Vars

	let baseURL: URL?

	var customHeader: VGSHTTPHeaders?

	internal static let defaultHttpHeaders: VGSHTTPHeaders = {
			// Add Headers
		let version = ProcessInfo.processInfo.operatingSystemVersion
		let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

		let source = VGSAnalyticsClient.Constants.Metadata.source
		let medium = VGSAnalyticsClient.Constants.Metadata.medium

		return [
			"vgs-client": "source=\(source)&medium=\(medium)&content=\(Utils.vgsShowVersion)&osVersion=\(versionString)&vgsShowSessionId=\(VGSShowAnalyticsSession.shared.vgsShowSessionId)"
		]
	}()

	/// URLSession object.
	internal let urlSession = URLSession(configuration: .ephemeral)

	// MARK: - Initialization

	init(baseURL url: URL?) {
		baseURL = url
	}

	// MARK: - Public

	func sendRequestWithJSON(path: String, method: VGSHTTPMethod = .post, value: VGSJSONData?, completion block: RequestCompletion) {

		let payload = VGSRequestPayloadBody.json(value)
		sendDataRequest(path: path, method: method, payload: payload, block: block)
	}

	func sendDataRequest(path: String, method: VGSHTTPMethod = .post, payload: VGSRequestPayloadBody, block: RequestCompletion) {
		guard let apiURL = baseURL else {
			let error = VGSShowError(type: .invalidConfigurationURL)
			print("❗VGSShowSDK CONFIGURATION ERROR: NOT VALID ORGANIZATION PARAMETERS!!! CANNOT BUILD URL!!!")
			block?(.failure(error.code, nil, nil, error))
			return
		}

		let encodingResult = payload.encodeToRequestBodyData()

		switch encodingResult {
		case .success(let data):
		      // Setup headers.
					let headers = provideHeaders(with: payload.additionalHeaders)

					// Setup URLRequest.
					let url = apiURL.appendingPathComponent(path)

					var request = URLRequest(url: url)
					request.httpBody = data
					request.httpMethod = method.rawValue
					request.allHTTPHeaderFields = headers

					// Log request.
					VGSShowLogger.logRequest(request, payload: payload)

					// Perform request.
					self.performRequest(request: request, completion: block)
		case .failure(let error):
					print("❗VGSShowSDK ERROR: cannot encode payload \(payload.rawPayload), error: \(error)")
					block?(.failure(error.code, nil, nil, error))
		}
	}

	// MARK: - Private

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
}
