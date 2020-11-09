//
//  VGSShowMaskRegex.swift
//  VGSShow
//
//  Created by Eugene on 09.11.2020.
//

import Foundation

internal protocol VGSShowRegexMaskable {
	var regex: NSRegularExpression {get}
	var template: String {get}
	var matchingOptions: NSRegularExpression.MatchingOptions {get}
}

/// Holds mask regex options.
public struct VGSShowRegexMask: VGSShowRegexMaskable {

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
	public init?(pattern: String, options: NSRegularExpression.Options = .caseInsensitive, matchingOptions: NSRegularExpression.MatchingOptions = [], template: String) {

		do {
			let regex = try NSRegularExpression(pattern: pattern, options: options)
			self.regex = regex
			self.matchingOptions = matchingOptions
			self.template = template
		} catch {
			print(error)
			return nil
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
