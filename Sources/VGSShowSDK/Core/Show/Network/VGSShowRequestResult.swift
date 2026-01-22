//
//  VGSShowRequestResult.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// The result of a VGSShow reveal request operation.
///
/// `VGSShowRequestResult` represents the outcome of calling `VGSShow.request(...)`. It uses a Swift enum
/// with associated values to provide type-safe handling of success and failure cases, including HTTP status
/// codes and optional error details.
///
/// ## Overview
///
/// Use `VGSShowRequestResult` to:
/// - Determine if a reveal request succeeded or failed
/// - Access HTTP status codes for both success and failure cases
/// - Extract error details when requests fail
/// - Implement conditional logic based on request outcomes
///
/// ## Cases
///
/// ### `.success(Int)`
///
/// The request completed successfully and subscribed views have been updated with revealed data.
/// The associated integer is the HTTP status code (typically 200-299).
///
/// **Note:** Individual views may still have errors (e.g., missing field) even when the overall request
/// succeeds. Check view delegates for per-view failures.
///
/// ### `.failure(Int, Error?)`
///
/// The request failed. Associated values include:
/// - HTTP status code (or 0 for network-level failures)
/// - Optional `Error` object (usually `VGSShowError` or `NSError` for network issues)
///
/// ## Error Domains
///
/// Errors in `.failure` may belong to:
///
/// - **`VGSShowSDKErrorDomain`**: SDK-specific errors (via `VGSShowError`)
/// - **`NSURLErrorDomain`**: Network errors (timeout, no connection, etc.)
/// - **Custom domains**: Backend or middleware errors
///
/// ## Important Notes
///
/// - `.success` means the HTTP request completed, not that all views populated successfully
/// - Individual view errors are reported via view delegates (e.g., `labelRevealDataDidFail`)
/// - Status code 0 typically indicates a client-side network failure (no server response)
/// - The completion handler is always called on the main thread
///
/// - SeeAlso: `VGSShow.request(path:method:payload:requestOptions:completion:)`, `VGSShowError`, `VGSErrorType`
@frozen public enum VGSShowRequestResult {
    /**
     Success response case.

     - Parameters:
        - code: `Int` object. Response status code.
    */
    case success(_ code: Int)

    /**
     Failed response case.

     - Parameters:
        - code: response status code.
        - error: `Error` object.
    */
    case failure(_ code: Int, _ error: Error?)
}
