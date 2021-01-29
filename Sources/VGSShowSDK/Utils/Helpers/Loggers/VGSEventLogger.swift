//
//  VGSEventLogger.swift
//  VGSShowSDK
//

import Foundation

/// Holds configuration for VGSShowSDK logging.
public struct VGSLoggingConfiguration {

	/// Log level. Default is `.info`.
	public var level: VGSLogLevel = .info

	/// `Bool` flag. Specify `true` to record VGSShowSDK network session with success/failed requests. Default is `true`.
	public var isNetworkDebugEnabled: Bool

	/// `Bool` flag. Specify `true` to enable extensive debugging. Default is `false`.
	public var isExtensiveDebugEnabled: Bool = false

	/// Stop logging all activities.
	mutating func disableAllLogging() {
		level = .none
		isNetworkDebugEnabled = false
		isExtensiveDebugEnabled = false
	}
}

internal final class VGSEventLogger {
		private static var loggers = [VGSLogging]()
		private static var enabledLevels = Set<VGSLogLevel>()
		private static let readWriteContainer: VGSReadWriteSafeContainer = VGSReadWriteSafeContainer(label: "VGSShowSDK.Utils.EventLogger")

		/// Add `VGSLogging` object.
		static func addLogging(_ logging: VGSLogging) {
			readWriteContainer.write {
						loggers.append(logging)
				}
		}

		/// Enable specific `VGSLogLevel`.
		class func enableLevel(_ level: VGSLogLevel) {
			readWriteContainer.write {
						enabledLevels.insert(level)
				}
		}

		/// Disable specific `VGSLogLevel`.
		class func disableLevel(_ level: VGSLogLevel) {
			readWriteContainer.write {
						enabledLevels.remove(level)
				}
		}

	   /*

		/// debug: Adds a debug message to the Mixpanel log
		/// - Parameter message: The message to be added to the log
		class func debug(message: @autoclosure() -> Any, _ path: String = #file, _ function: String = #function) {
				var enabledLevels = Set<LogLevel>()
				readWriteLock.read {
						enabledLevels = self.enabledLevels
				}
				guard enabledLevels.contains(.debug) else { return }
				forwardLogMessage(LogMessage(path: path, function: function, text: "\(message())",
																							level: .debug))
		}

		/// info: Adds an informational message to the Mixpanel log
		/// - Parameter message: The message to be added to the log
		class func info(message: @autoclosure() -> Any, _ path: String = #file, _ function: String = #function) {
				var enabledLevels = Set<LogLevel>()
				readWriteLock.read {
						enabledLevels = self.enabledLevels
				}
				guard enabledLevels.contains(.info) else { return }
				forwardLogMessage(LogMessage(path: path, function: function, text: "\(message())",
																							level: .info))
		}

		/// warn: Adds a warning message to the Mixpanel log
		/// - Parameter message: The message to be added to the log
		class func warn(message: @autoclosure() -> Any, _ path: String = #file, _ function: String = #function) {
				var enabledLevels = Set<LogLevel>()
				readWriteLock.read {
						enabledLevels = self.enabledLevels
				}
				guard enabledLevels.contains(.warning) else { return }
				forwardLogMessage(LogMessage(path: path, function: function, text: "\(message())",
																							level: .warning))
		}

		/// error: Adds an error message to the Mixpanel log
		/// - Parameter message: The message to be added to the log
		class func error(message: @autoclosure() -> Any, _ path: String = #file, _ function: String = #function) {
				var enabledLevels = Set<LogLevel>()
				readWriteLock.read {
						enabledLevels = self.enabledLevels
				}
				guard enabledLevels.contains(.error) else { return }
				forwardLogMessage(LogMessage(path: path, function: function, text: "\(message())",
																							 level: .error))
		}

		/// This forwards a `LogMessage` to each logger that has been added
		class private func forwardLogMessage(_ message: LogMessage) {
				// Forward the log message to every registered Logging instance
				var loggers = [Logging]()
				readWriteLock.read {
						loggers = self.loggers
				}
				readWriteLock.write {
						loggers.forEach() { $0.addMessage(message: message) }
				}
		}
	  */
}
