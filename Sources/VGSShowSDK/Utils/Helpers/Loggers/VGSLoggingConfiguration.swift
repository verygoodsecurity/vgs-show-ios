//
//  VGSLoggingConfiguration.swift
//  VGSShowSDK
//

import Foundation

/// Holds configuration for VGSShowSDK logging.
public struct VGSLoggingConfiguration {

	/// Log level. Default is `.info`.
	public var level: VGSLogLevel = .info

	/// `Bool` flag. Specify `true` to record VGSShowSDK network session with success/failed requests. Default is `true`.
	public var isNetworkDebugEnabled: Bool = true

	/// `Bool` flag. Specify `true` to enable extensive debugging. Default is `false`.
	public var isExtensiveDebugEnabled: Bool = false

	/// Stop logging all activities.
	public mutating func disableAllLogging() {
		level = .none
		isNetworkDebugEnabled = false
		isExtensiveDebugEnabled = false
	}
}
