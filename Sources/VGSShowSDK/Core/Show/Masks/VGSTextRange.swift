//
//  VGSTextRange.swift
//  VGSShowSDK
//

import Foundation

/// An object representing text range with closed  boundaries.
public struct VGSTextRange {
	/// Range start index
	public let start: Int?
	/// Range end index
	public let end: Int?

	/// Initialization.
	/// - Parameters:
	///   - start: `Int` object. Defines range start, should be less or equal to `end` and string length. Default is `nil`.
	///   - end: `Int` object. Defines range end, should be greater or equal to `end` and string length. Default is `nil`.
	public init(start: Int? = nil, end: Int? = nil) {
		self.start = start
		self.end = end
	}

	internal var startText: String {
		guard let startValue = start else {
			return "nil"
		}

		return String(startValue)
	}

	internal var endText: String {
		guard let endValue = end else {
			return "nil"
		}

		return String(endValue)
	}

	internal var debugText: String {
		return "[\(startText), \(endText)]"
	}
}

internal extension Array where Element == VGSTextRange {
	var debugText: String {
		return map({return $0.debugText}).joined(separator: ", ")
	}
}
