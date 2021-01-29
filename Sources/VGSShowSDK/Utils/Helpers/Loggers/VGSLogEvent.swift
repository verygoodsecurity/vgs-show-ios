//
//  VGSLogEvent.swift
//  VGSShowSDK
//

import Foundation

/// Holds logging data.
internal struct VGSLogEvent {

	/// Log level.
	internal let level: VGSLogLevel

	/// Text to log.
	internal let text: String

	/// File where the event is used.
	internal let file: String

	/// Function where log event is triggered.
	internal let functionName: String

	/// Line where log event is triggered.
	internal let lineNumber: Int

	/// Initializer.
	/// - Parameters:
	///   - level: `VGSLogLevel` object, log level.
	///   - text: `String` object, raw text to log.
	///   - file: `String` object, refers to filename of calling function.
	///   - functionName: `String` object, refers to filename of calling function.
	///   - lineNumber: `Int` object, refers to line number of calling function.
	internal init(level: VGSLogLevel, text: String, file: String = #file, functionName: String = #function, lineNumber: Int = #line) {
		self.text = text
		self.level = level
		self.functionName = functionName
		self.lineNumber = lineNumber
		if let outputFile = file.components(separatedBy: "/").last {
				self.file = outputFile
		} else {
				self.file = file
		}
	}
}

/// Interface for event logging.
internal protocol VGSLogging {
		func logEvent(_ event: VGSLogEvent)
}
