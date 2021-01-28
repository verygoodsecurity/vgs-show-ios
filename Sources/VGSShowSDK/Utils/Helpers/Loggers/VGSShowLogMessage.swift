//
//  VGSShowLogMessage.swift
//  VGSShowSDK
//

import Foundation

/// Holds logging data.
internal struct VGSShowLogEvent {

	/// Event log level.
	internal let level: VGSLogLevel

	/// Log event text.
	internal let text: String

	/// File where the event is used.
	internal let file: String

	/// Function where this log event was triggered.
	internal let functionName: String

	/// Initializer.
	/// - Parameters:
	///   - level: `VGSLogLevel` object, log level.
	///   - text: `String` object, raw text to log.
	///   - functionName: `String` object, function name.
	///   - path: `String` object, path to file where event is used.
	internal init(level: VGSLogLevel, text: String, functionName: String, path: String) {
		self.text = text
		self.level = level
		self.functionName = functionName
		if let outputFile = path.components(separatedBy: "/").last {
				self.file = outputFile
		} else {
				self.file = path
		}
	}
}

/// Interface for event logging.
internal protocol VGSLogging {
		func addEvent(event: VGSShowLogEvent)
}
