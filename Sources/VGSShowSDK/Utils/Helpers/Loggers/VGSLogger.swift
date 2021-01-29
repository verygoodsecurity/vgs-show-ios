//
//  VGSLogger.swift
//  VGSShowSDK
//

import Foundation

/// VGSLogger encapsulates logging logic and options for VGSShowSDK. Use `configuration` property to setup logging options.
public final class VGSLogger {

  // MARK: - Public vars

	/// Shared instance.
	public static var shared = VGSLogger()

	/// Logging configuration.
	public var configuration: VGSLoggingConfiguration = VGSLoggingConfiguration()

	// MARK: - Private vars

	/// Registered loggers.
	private var registeredLoggers = [VGSLogging]()

	/// Thread safe container for registered loggers.
	private let readWriteContainer: VGSReadWriteSafeContainer = VGSReadWriteSafeContainer(label: "VGSShowSDK.Utils.Loggers")

	// MARK: - Initialization

	/// Private init for `VGSLogger`.
	private init() {
		addLogger(VGSPrintingLogger())
	}

	// MARK: - Private

	/// Add `VGSLogging` object.
	/// - Parameter logging: `VGSLogging` object, logger.
	internal func addLogger(_ logger: VGSLogging) {
		readWriteContainer.write {
			registeredLoggers.append(logger)
		}
	}

	/// Forward event to all registered loggers.
	/// - Parameter event: `VGSLogEvent` object, event to log.
	internal func forwarndLogEvent(_ event: VGSLogEvent) {
		let currentLogLevel = configuration.level
		let isExtensiveDebugEnabled = configuration.isExtensiveDebugEnabled

		// Skip forward logs if logLevel is `none`, event level should mismatch log level.
		guard currentLogLevel != .none, shouldForwardMessageLevel(event.level, currentLevel: currentLogLevel) else {
			return
		}

		var loggers = [VGSLogging]()
		readWriteContainer.read {
			loggers = self.registeredLoggers
		}
		readWriteContainer.write {
			loggers.forEach {$0.logEvent(event, isExtensiveDebugEnabled: isExtensiveDebugEnabled)}
		}
	}

	internal func shouldForwardMessageLevel(_ messageLevel: VGSLogLevel, currentLevel: VGSLogLevel) -> Bool {
		switch currentLevel {
		case .none:
			return false
		case .info:
			return true
		case .warning:
			return messageLevel == currentLevel
		}
	}
}
