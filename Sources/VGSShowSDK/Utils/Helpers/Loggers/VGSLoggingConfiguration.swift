//
//  VGSLoggingConfiguration.swift
//  VGSShowSDK
//

import Foundation

/// Holds configuration for VGSShowSDK logging.
public struct VGSLoggingConfiguration {

	/// Log level. Default is `.none`.
	public var level: VGSLogLevel = .none

	/// `Bool` flag. Specify `true` to record VGSShowSDK network session with success/failed requests. Default is `false`.
	public var isNetworkDebugEnabled: Bool = false

	/// `Bool` flag. Specify `true` to enable extensive debugging. Default is `false`.
	public var isExtensiveDebugEnabled: Bool = false
}
