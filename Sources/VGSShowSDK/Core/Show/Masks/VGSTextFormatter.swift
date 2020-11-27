//
//  VGSTextFormatter.swift
//  VGSShowSDK
//

import Foundation

/// An object that acts as a container for different text formatters.
internal struct VGSTextFormatterStrategy {
	internal var transformationRegexes: [VGSTransformationRegex] = []

	internal var hasFormatting: Bool {
		return hasRegexes
	}

	internal var hasRegexes: Bool {
		return !transformationRegexes.isEmpty
	}

	internal func formatText(_ text: String) -> String {
		if !hasFormatting {return text}

		return text.transformWithRegexes(transformationRegexes)
	}
}
