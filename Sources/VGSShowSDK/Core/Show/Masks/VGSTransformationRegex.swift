//
//  VGSTransformationRegex.swift
//  VGSShow
//
//  Created by Eugene on 09.11.2020.
//

import Foundation

/// Holds transformation regex options.
internal struct VGSTransformationRegex {

	/// Regex object.
	internal let regex: NSRegularExpression

  /// Replacement template.
	internal let template: String

  /// Matching options.
	internal var matchingOptions: NSRegularExpression.MatchingOptions = []

	/// Initializer with mask regex pattern.
	/// - Parameters:
	///   - regex: `NSRegularExpression` object, transformation regex.
	///   - template: `String` object, template for replacement.
	internal init(regex: NSRegularExpression, template: String) {
		self.regex = regex
		self.template = template
	}
}
