//
//  VGSShowMaskRegex.swift
//  VGSShow
//
//  Created by Eugene on 09.11.2020.
//

import Foundation

/// Holds mask regex options.
public struct VGSShowRegexMask {

	/// Regex pattern.
	public let pattern: String

	/// Regex options.
	public let options: NSRegularExpression.Options

  /// Matching options.
	public let matchingOptions: NSRegularExpression.MatchingOptions

  /// Replacement template.
	public let template: String

	/// Initializer.
	/// - Parameters:
	///   - pattern: `String` object. Regex pattern.
	///   - options: `NSRegularExpression.Options` object.
	///   - matchingOptions: `NSRegularExpression.MatchingOptions` object.
	///   - template: `String` object. Template for regex.
	public init(pattern: String, options: NSRegularExpression.Options = .caseInsensitive, matchingOptions: NSRegularExpression.MatchingOptions = [], template: String) {
		self.pattern = pattern
		self.options = options
		self.matchingOptions = matchingOptions
		self.template = template
	}
}
