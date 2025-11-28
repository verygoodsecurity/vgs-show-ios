//
//  VGSLogLevel.swift
//  VGSShowSDK
//

import Foundation

/// Defines levels of logging.
public enum VGSLogLevel: String {
        /// Log all events including informational messages, warnings, and errors.
        ///
        /// Use this level during development for maximum visibility into SDK behavior.
        /// **Never use in production** due to potential performance impact and log noise.
        case info

        /// Log only warnings and errors.
        ///
        /// Use this level when you need to debug issues but want to reduce log volume.
        /// Suitable for staging environments. Avoid in production.
        case warning

        /// Disable all SDK logging.
        ///
        /// Use this level in production builds to eliminate SDK console output.
        /// This is the safest and recommended setting for shipped apps.
        case none
}
