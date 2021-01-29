//
//  VGSLogEvent.swift
//  VGSShowSDK
//

import Foundation

/// Holds logging data.
internal struct VGSLogEvent {

	internal enum SeverityLevel {
		case warning
		case error

		var debugText: String {
			switch self {
			case .error:
				return "❌"
			case .warning:
				return "⚠️"
			}
		}
	}

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

	internal let severityLevel: SeverityLevel?

	/// Initializer.
	/// - Parameters:
	///   - level: `VGSLogLevel` object, log level.
	///   - text: `String` object, raw text to log.
	///   - severityLevel: `SeverityLevel?` object, should be used to indicate errors or warnings. Default is `nil`.
	///   - file: `String` object, refers to filename of calling function.
	///   - functionName: `String` object, refers to filename of calling function.
	///   - lineNumber: `Int` object, refers to line number of calling function.
	internal init(level: VGSLogLevel, text: String, severityLevel: SeverityLevel? = nil, file: String = #file, functionName: String = #function, lineNumber: Int = #line) {
		self.text = text
		self.severityLevel = severityLevel
		self.level = level
		self.functionName = functionName
		self.lineNumber = lineNumber
		if let outputFile = file.components(separatedBy: "/").last {
				self.file = outputFile
		} else {
				self.file = file
		}
	}

	internal func convertToDebugString(isExtensiveDebugEnabled: Bool) -> String {
		var severityText = ""
		if let severity = severityLevel?.debugText {
			severityText = severity
		}
		if isExtensiveDebugEnabled {
			return "[VGShowSDK - \(file) - func \(functionName) - line \(lineNumber) logLevel - \(level.rawValue)] \(severityText) \(text)"
		} else {
			return "[VGShowSDK - \(file) - func \(functionName) - line \(lineNumber)] \(severityText) \(text)"
		}
	}
}

/// Interface for event logging.
internal protocol VGSLogging {
	func logEvent(_ event: VGSLogEvent, isExtensiveDebugEnabled: Bool)
}
