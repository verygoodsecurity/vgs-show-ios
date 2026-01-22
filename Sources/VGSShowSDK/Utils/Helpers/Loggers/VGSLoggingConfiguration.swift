//
//  VGSLoggingConfiguration.swift
//  VGSShowSDK
//

import Foundation

/// Configuration settings for VGSShow SDK logging behavior.
///
/// `VGSLoggingConfiguration` controls what diagnostic information the SDK outputs to the console.
/// Adjust these settings to balance debugging visibility with production safety and performance.
///
/// ## Overview
///
/// Use `VGSLoggingConfiguration` to:
/// - Control SDK log verbosity with `level`
/// - Enable network request/response logging with `isNetworkDebugEnabled`
/// - Enable extensive debugging with `isExtensiveDebugEnabled`
///
/// ## Security Notes
///
/// - Never enable detailed logging in production
/// - Network debug logs may include request/response metadata (paths, headers)
/// - SDK never logs raw revealed data, only metadata (lengths, boolean flags)
/// - Disable all logging in production with `.level = .none`
/// - SeeAlso: `VGSLogLevel`, `VGSLogger`
public struct VGSLoggingConfiguration {

    /// The logging verbosity level.
    ///
    /// Controls which types of events are logged to the console.
    /// Default is `.none` for production safety.
    public var level: VGSLogLevel = .none

    /// A Boolean value indicating whether network request/response logging is enabled.
    ///
    /// When `true`, the SDK logs HTTP request/response metadata including paths, status codes,
    /// and headers (sanitized). Useful for debugging network issues.
    ///
    /// Default is `false`. **Never enable in production.**
    public var isNetworkDebugEnabled: Bool = false

    /// A Boolean value indicating whether extensive debugging is enabled.
    ///
    /// When `true`, the SDK outputs detailed internal state information for troubleshooting
    /// complex issues. Very verbose.
    ///
    /// Default is `false`. **Never enable in production.**
    public var isExtensiveDebugEnabled: Bool = false
}
