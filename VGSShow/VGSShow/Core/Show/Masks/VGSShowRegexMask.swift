//
//  VGSShowMaskRegex.swift
//  VGSShow
//
//  Created by Eugene on 09.11.2020.
//

import Foundation

/// Holds mask regex options.
public struct VGSShowRegexMask {

  /// Matching options.
	internal let matchingOptions: NSRegularExpression.MatchingOptions

  /// Replacement template.
	internal var template: String

	/// Regex for mask.
	internal let regex: NSRegularExpression

	/// Regex range. If `nil` regex will be applied to all string length.
	internal let range: NSRange?

	/// Initializer with mask regex pattern.
	/// - Parameters:
	///   - pattern: `String` object. Regex pattern.
	///   - options: `NSRegularExpression.Options` object. Default is `.caseInsensitive`.
	///   - matchingOptions: `NSRegularExpression.MatchingOptions` object. Default is `[]`.
	///   - range: `NSRange` object. Range for regex. Default is `nil`.
	///   - template: `String` object. Template for replace.
	/// - Throws: `Error` object if cannot construct regex.
	public init?(pattern: String, options: NSRegularExpression.Options = .caseInsensitive, matchingOptions: NSRegularExpression.MatchingOptions = [], range: NSRange? = nil, template: String) throws {

		do {
			let regex = try NSRegularExpression(pattern: pattern, options: options)
			self.init(regex: regex, matchingOptions: matchingOptions, range: range, template: template)
		} catch let error {
			print(error)
			throw error
		}
	}

	/// Initializer with regex object.
	/// - Parameters:
	///   - regex: `NSRegularExpression` object.
	///   - matchingOptions: `NSRegularExpression.Options` object. Default is `[]`.
	///   - range: `NSRange` object. Range for regex. Default is `nil`.
	///   - template: String object. Template for replace.
	public init(regex: NSRegularExpression, matchingOptions: NSRegularExpression.MatchingOptions = [], range: NSRange? = nil, template: String) {
		self.regex = regex
		self.range = range
		self.matchingOptions = matchingOptions
		self.template = template
	}
}
