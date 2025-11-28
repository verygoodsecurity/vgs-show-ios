//
//  VGSShowRequestOptions.swift
//  Pods-VGSShowDemoApp
//

import Foundation

/// Configuration options for customizing reveal request behavior.
///
/// `VGSShowRequestOptions` provides control over network request timeouts and other request-level
/// settings. Pass an instance to `VGSShow.request(...)` to override default behavior.
///
/// ## Overview
///
/// Use `VGSShowRequestOptions` to:
/// - Set custom timeout intervals for reveal requests
/// - Override default network behavior on a per-request basis
///
/// ## Default Behavior
///
/// When `requestOptions` is `nil` or `requestTimeoutInterval` is `nil`, the SDK uses system
/// default timeout behavior (typically 60 seconds).
///
/// - SeeAlso: `VGSShow.request(path:method:payload:requestOptions:completion:)`
public struct VGSShowRequestOptions {

    /// The timeout interval for the request in seconds.
    ///
    /// When `nil`, the SDK uses default timeout behavior. Set explicitly to override.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var options = VGSShowRequestOptions()
    /// options.requestTimeoutInterval = 10.0
    /// ```
    public var requestTimeoutInterval: TimeInterval?

    /// Creates a new request options instance with default values.
    public init() {}
}
