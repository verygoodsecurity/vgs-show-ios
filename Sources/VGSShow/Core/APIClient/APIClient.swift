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
	/// POST method.
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case patch = "PATCH"
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

	let baseURL: URL!

	var customHeader: VGSHTTPHeaders?

	internal static let defaultHttpHeaders: VGSHTTPHeaders = {
			// Add Headers
		let version = ProcessInfo.processInfo.operatingSystemVersion
		let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

		let source = VGSAnalyticsClient.Constants.Metadata.source
		let medium = VGSAnalyticsClient.Constants.Metadata.medium

		return [
			"vgs-client": "source=\(source)&medium=\(medium)&content=\(Utils.vgsShowVersion)&osVersion=\(versionString)&vgsCollectSessionId=\(VGSShowAnalyticsSession.shared.vgsShowSessionId)"
		]
	}()

	/// URLSession object.
	internal let urlSession = URLSession(configuration: .ephemeral)

	// MARK: - Initialization

	init(baseURL url: URL) {
		baseURL = url
	}

	// MARK: - Public

	func sendRequest(path: String, method: VGSHTTPMethod = .post, value: VGSJSONData?, completion block: RequestCompletion ) {
		// Add Headers
		var headers: [String: String] = [:]
		headers["Content-Type"] = "application/json"

		// Add custom headers if need
		if let customerHeaders = customHeader, !customerHeaders.isEmpty {
			customerHeaders.keys.forEach({ (key) in
				headers[key] = customerHeaders[key]
			})
		}

		// Setup URLRequest
    var jsonData: Data?
    if let value = value {
      jsonData = try? JSONSerialization.data(withJSONObject: value)
    }
		let url = baseURL.appendingPathComponent(path)

		var request = URLRequest(url: url)
		request.httpBody = jsonData
		request.httpMethod = method.rawValue
		request.allHTTPHeaderFields = headers

		print("url: \(url)")

		performRequest(request: request, value: value, completion: block)
	}

	// MARK: - Private

	private func performRequest(request: URLRequest, value: VGSJSONData?, completion block: RequestCompletion) {
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
}
