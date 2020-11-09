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

	/// Initializer.
	/// - Parameters:
	///   - pattern: `String` object. Regex pattern.
	///   - options: `NSRegularExpression.Options` object.
	///   - matchingOptions: `NSRegularExpression.MatchingOptions` object.
	///   - template: `String` object. Template for replace.
	/// - Throws: `Error` object if cannot construct regex.
	public init?(pattern: String, options: NSRegularExpression.Options = .caseInsensitive, matchingOptions: NSRegularExpression.MatchingOptions = [], template: String) throws {

		do {
			let regex = try NSRegularExpression(pattern: pattern, options: options)
			self.init(regex: regex, matchingOptions: matchingOptions, template: template)
		} catch let error {
			print(error)
			throw error
		}
	}

	/// Initialize with regex.
	/// - Parameters:
	///   - regex: `NSRegularExpression` object.
	///   - matchingOptions: `NSRegularExpression.Options` object. Default is `[]`.
	///   - template: String object. Template for replace.
	public init(regex: NSRegularExpression, matchingOptions: NSRegularExpression.MatchingOptions = [], template: String) {
		self.regex = regex
		self.matchingOptions = matchingOptions
		self.template = template
	}
}
