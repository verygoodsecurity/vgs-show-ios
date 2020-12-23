//
//  APIRequestResult.swift
//  VGSShowSDK
//

import Foundation

/// Response enum cases for SDK requests.
internal enum APIRequestResult {
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
