//
//  VGSTextFormattersContainer.swift
//  VGSShowSDK
//

import Foundation

/// An object that acts as a container for different text formatters.
internal struct VGSTextFormattersContainer {

  // MARK: - Private interface

  /// An array of `VGSTransformationRegex` objects.
	private (set) internal var transformationRegexes: [VGSTransformationRegex] = []

  // MARK: - Public interface

	/// `Bool` flag, indicating if has formatting.
	internal var hasFormatting: Bool {
		return hasRegexes
	}

	/// `Bool` flag, indicating if has transformation regexes.
	internal var hasRegexes: Bool {
		return !transformationRegexes.isEmpty
	}

	/// Apply all formatters to text.
	/// - Parameter text: `String` object to format.
	/// - Returns: `String` object, formatted text.
	internal func formatText(_ text: String) -> String {
		if !hasFormatting {return text}

		return text.transformWithRegexes(transformationRegexes)
	}

	/// Reset all custom formatters.
	mutating internal func resetAllFormatters() {
		transformationRegexes = []
	}

	/// Add new transformation regex.
	mutating func addTransformationRegex(_ transformationRegex: VGSTransformationRegex) {
		transformationRegexes.append(transformationRegex)
	}
}
