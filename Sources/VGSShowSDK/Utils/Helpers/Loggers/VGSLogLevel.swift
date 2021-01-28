//
//  VGSLogLevel.swift
//  VGSShowSDK
//

import Foundation

/// Defines levels of logging.
public enum VGSLogLevel: String {
		/// Log all messages including some debug information.
		case debug

		/// Log all messages informative for users.
		case info

		/// Log warning messages.
		case warning

		/// Log errors.
		case error
}
