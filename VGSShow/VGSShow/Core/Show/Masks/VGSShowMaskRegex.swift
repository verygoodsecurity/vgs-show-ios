//
//  VGSShowMaskRegex.swift
//  VGSShow
//
//  Created by Eugene on 09.11.2020.
//

import Foundation

/// Holds mask regex options.
public struct VGSShowMaskRegex {

	/// Regex pattern.
	public let pattern: String

	/// Rexeg options.
	public var options: NSRegularExpression.Options = .caseInsensitive

  /// Matching options.
	public var matchingOptions: NSRegularExpression.MatchingOptions = []

  /// Replacement template.
	public let template: String
}
