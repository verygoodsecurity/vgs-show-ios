//
//  VGSLogger.swift
//  VGSShowSDK
//

import Foundation

/// VGSLogger encapsulates logging logic and options for VGSShowSDK. Use `configuration` property to setup logging options.
public final class VGSLogger {

  // MARK: - Public vars

	/// Logging configuration.
	private static var configuration: VGSLoggingConfiguration = VGSLoggingConfiguration()

	// MARK: - Private vars

	/// Registered loggers.
	private static var registeredLoggers = [VGSLogging]()

	/// Thread safe container for registered loggers.
	private static let readWriteContainer: VGSReadWriteSafeContainer = VGSReadWriteSafeContainer(label: "VGSShowSDK.Utils.Loggers")

	// MARK: - Private

	/// Add `VGSLogging` object.
	/// - Parameter logging: `VGSLogging` object, logger.
	internal static func addLogger(_ logger: VGSLogging) {
		readWriteContainer.write {
			registeredLoggers.append(logger)
		}
	}

	/// Forward event to all registered loggers.
	/// - Parameter event: `VGSLogEvent` object, event to log.
	internal static func forwarndLogEvent(_ event: VGSLogEvent) {
		let currentLogLevel = configuration.level

		// Skip forward logs if logLevel is `none`, event level should mismatch log level.
		guard currentLogLevel != .none, event.level == configuration.level else {
			return
		}

		var loggers = [VGSLogging]()
		readWriteContainer.read {
			loggers = self.registeredLoggers
		}
		readWriteContainer.write {
			loggers.forEach() { $0.logEvent(event) }
		}
	}
}
