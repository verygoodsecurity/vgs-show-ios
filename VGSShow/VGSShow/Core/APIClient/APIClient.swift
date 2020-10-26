//
//  APIClient.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Key-value data type, usually used for response format.
public typealias JsonData = [String: Any]

/// Key-value data type, used in http request headers.
public typealias HTTPHeaders = [String: String]

/// Key-value data type, for internal use.
internal typealias BodyData = [String: Any]

/// HTTP request methods
public enum HTTPMethod: String {
	/// GET method
	case get     = "GET"
	/// POST method
	case post    = "POST"
	/// PUT method
	case put     = "PUT"
}

/// Response enum cases for SDK requests
@frozen public enum VGSResponse {
	/**
	 Success response case

	 - Parameters:
		- code: response status code.
		- data: response **data** object.
		- response: URLResponse object represents a URL load response.
	*/
	case success( _ code: Int, _ data: Data?, _ response: URLResponse?)

	/**
	 Failed response case

	 - Parameters:
		- code: response status code.
		- data: response **Data** object.
		- response: `URLResponse` object represents a URL load response.
		- error: `Error` object.
	*/
	case failure(_ code:Int, _ data:Data?, _ response: URLResponse?, _ error:Error?)
}

class APIClient {

	typealias RequestCompletion = ((_ response: VGSResponse) -> Void)?

	// MAR: - Constants

	enum Constants {
		static let validStatuses: Range<Int> = 200..<300
	}

    // MARK: - Vars

	let baseURL: URL!

	var customHeader: HTTPHeaders?

    // MARK: - Initialization

	init(baseURL url: URL) {
		baseURL = url
	}

    // MARK: - Public

	func sendRequest(path: String, method: HTTPMethod = .post, validStatuses: Range<Int> = Constants.validStatuses, errorIdentifier: String, value: BodyData, completion block: RequestCompletion ) {
		// Add Headers
		var headers = [String : String]()
		headers["Content-Type"] = "application/json"
		// Add custom headers if need
		if let customerHeaders = customHeader, customerHeaders.count > 0 {
			customerHeaders.keys.forEach({ (key) in
				headers[key] = customerHeaders[key]
			})
		}
		// Setup URLRequest
		let jsonData = try? JSONSerialization.data(withJSONObject: value)
		let url = baseURL.appendingPathComponent(path)

		var request = URLRequest(url: url)
		request.httpBody = jsonData
		request.httpMethod = method.rawValue
		request.allHTTPHeaderFields = headers

		performRequest(request: request, errorIdentifier: errorIdentifier, value: value, completion: block)
	}

    // MARK: - Private

	private func performRequest(request: URLRequest, validStatuses: Range<Int> = Constants.validStatuses, errorIdentifier: String, value: BodyData, completion block: RequestCompletion) {
		// Send data
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			DispatchQueue.main.async {
				if let error = error as NSError? {
					block?(.failure(error.code, data, response, error))
					return
				}
			  let statusCode = (response as? HTTPURLResponse)?.statusCode ?? VGSErrorType.unexpectedResponseType.rawValue

				switch statusCode {
				case validStatuses:
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
