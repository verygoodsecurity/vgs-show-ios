//
//  String+Exntesions.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal extension String {
	var isAlphaNumeric: Bool {
		return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
	}

	var isValidJSONKeyPath: Bool {
		return !isEmpty && range(of: "[^a-zA-Z.0-9-_]", options: .regularExpression) == nil
	}
}

internal extension Optional where Wrapped == String {
	var isNilOrEmpty: Bool {
		return self?.isEmpty ?? true
	}
}

/// String style attributes.
internal enum StringStyleAttribute {

	/**
	 Text color.

	 - Parameters:
		- color: `UIColor` object.
	*/
	case color(_ color: UIColor)

	/**
	 Text font.

	 - Parameters:
		- font: `UIFont` object.
	*/
	case font(_ font: UIFont)

	/**
	Text minimal line height.

	 - Parameters:
		- height: `CGFloat` object. Text height.
	*/
	case minimumLineHeight(_ height: CGFloat)

	/**
	Text alignment.

	 - Parameters:
		- alignment: `NSTextAlignment` object. Text alignment.
	*/
	case alignment(_ alignment: NSTextAlignment)

	/**
	Text character spacing.

	 - Parameters:
		- spacing: `CGFloat` object. Character spacing
	*/
	case characterSpacing(_ spacing: CGFloat)

	/**
	Text linebreaking mode.

	 - Parameters:
		- mode: `NSLineBreakMode` object. Text linebreaking mode.
	*/
	case lineBreakMode(_ mode: NSLineBreakMode)

	/**
	Text underline style.

	 - Parameters:
		- underlineStyle: `NSUnderlineStyle` object. Text underline style.
	*/
	case isUnderlined (_ underlineStyle: NSUnderlineStyle)
}

internal extension String {
	/// Style string with specific attributes.
	/// - Parameter attributes: `StringStyleAttribute`.
	/// - Returns: `NSAttributedString` string object.
	func attributed(_ attributes: StringStyleAttribute...) -> NSAttributedString {
		return attributed(with: attributes)
	}

	/// Style string with specific attributes.
	/// - Parameter attributes: Array of `StringStyleAttribute`.
	/// - Returns: `NSAttributedString` string object.
	func attributed(with attributes: [StringStyleAttribute]) -> NSAttributedString {
		let attributedString = NSMutableAttributedString.init(string: self)
		let pargraphStyle = NSMutableParagraphStyle()
		let range = NSRange(location: 0, length: attributedString.length)

		for attribute in attributes {
			switch attribute {
			case .color(let color):
				attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

			case .font(let font):
				attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)

			case .characterSpacing(let characterSpacing):
				attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: range)

			case .minimumLineHeight(let minimumLineHeight):
				pargraphStyle.minimumLineHeight = minimumLineHeight

			case .alignment(let alignment):
				pargraphStyle.alignment = alignment

			case .lineBreakMode(let lineBreakMode):
				pargraphStyle.lineBreakMode = lineBreakMode

			case .isUnderlined(let underlineStyle):
				attributedString.addAttributes([.underlineStyle: underlineStyle], range: range)
			}
		}

		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: pargraphStyle, range: range)

		return NSAttributedString(attributedString: attributedString)
	}
}

internal extension String {
	/// Transform string with mask regex.
	/// - Parameter regexMask: `VGSShowRegexMask` object.
	/// - Returns: Masked `String` object.
	func transformWithRegex(_ regexMask: VGSTransformationRegex) -> String {
		let initalString = self

		let fullLengthRange = NSRange(location: 0, length: initalString.count)

		let maskedString = regexMask.regex.stringByReplacingMatches(in: initalString, options: [], range: fullLengthRange, withTemplate: regexMask.template)

		return maskedString
	}

	func transformWithRegexes(_ transformationRegexes: [VGSTransformationRegex]) -> String {
		return transformationRegexes.reduce(self) { (text, regex) -> String in
			return text.transformWithRegex(regex)
		}
	}
}
