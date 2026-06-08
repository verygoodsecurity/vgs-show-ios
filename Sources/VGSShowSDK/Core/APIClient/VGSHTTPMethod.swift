//
//  VGSHTTPMethod.swift
//  VGSShowSDK
//

import Foundation

/// HTTP request methods supported by VGSShow SDK.
///
/// Use these standard HTTP methods when making reveal requests to your vault.
/// The method determines how the request is processed by your backend.
///
/// - SeeAlso: `VGSShow.request(path:method:payload:requestOptions:completion:)`
@MainActor
public enum VGSHTTPMethod: String {
    /// HTTP GET method - retrieve data.
    case get = "GET"

    /// HTTP POST method - submit data (default for reveal requests).
    case post = "POST"

    /// HTTP PUT method - update/replace data.
    case put = "PUT"

    /// HTTP PATCH method - partially update data.
    case patch = "PATCH"

    /// HTTP DELETE method - remove data.
    case delete = "DELETE"
}

/// A dictionary representing JSON data, typically used for request payloads and responses.
///
/// ## Example
///
/// ```swift
/// let payload: VGSJSONData = [
///     "reveal": ["user.email", "user.phone"],
///     "user_id": "123"
/// ]
/// show.request(path: "/reveal", payload: payload) { result in }
/// ```
public typealias VGSJSONData = [String: Any]

/// A dictionary representing HTTP request headers.
///
/// ## Example
///
/// ```swift
/// let headers: VGSHTTPHeaders = [
///     "X-Correlation-ID": UUID().uuidString,
///     "X-Client-Version": "1.0.0"
/// ]
/// show.customHeaders = headers
/// ```
public typealias VGSHTTPHeaders = [String: String]
