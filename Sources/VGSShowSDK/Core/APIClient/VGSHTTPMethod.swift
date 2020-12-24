//
//  VGSHTTPMethod.swift
//  VGSShowSDK
//

import Foundation

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

/// Key-value data type, usually used for response format.
public typealias VGSJSONData = [String: Any]

/// Key-value data type, used in http request headers.
public typealias VGSHTTPHeaders = [String: String]
