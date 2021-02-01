//
//  VGSShow+Logging.swift
//  VGSShowSDK
//

import Foundation

internal extension VGSShow {

	/// Log event.
	/// - Parameter event: `VGSLogEvent` object, event to log.
	func logEvent(_ event: VGSLogEvent) {
		VGSLogger.shared.forwardLogEvent(event)
	}

	/// Format contentPaths for suitable debugging output.
	/// - Parameter contentPaths: `[String]`, array of contentPaths.
	/// - Returns: `String` object, formatted contentPaths.
	static func formatDecodingContentPaths(_ contentPaths: [String]) -> String {
		let formattedContentPaths = contentPaths.map { (path) -> String in
			var formatttedPath = path
			if path.isEmpty {
				formatttedPath = "⚠️ CONTENT PATH NOT SET OR EMPTY!"
			}

			return " \(formatttedPath)"
		}.joined(separator: "\n  ")

		return "[\n  \(formattedContentPaths) \n]"
	}

	/// Log warning if some reveal models has empty contentPath.
	/// - Parameter revealModels: `[VGSViewModelProtocol]` models.
	func logRevealModelsWithoutContentPath(_ revealModels: [VGSViewModelProtocol]) {
		guard !revealModels.isEmpty else {return}

		let revealModelsWithoutContentPath = revealModels.filter({return $0.decodingContentPath.isEmpty})

		guard !revealModelsWithoutContentPath.isEmpty else {return}

		let warningMessage = "Some subscribed views seems to habe empty content path. Verify `contentPath` property is set for each view."
		let event = VGSLogEvent(level: .warning, text: warningMessage, severityLevel: .warning)
		logEvent(event)
	}
}
