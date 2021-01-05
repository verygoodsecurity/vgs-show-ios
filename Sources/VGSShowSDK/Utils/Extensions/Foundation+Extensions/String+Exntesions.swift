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

		let range: NSRange
		if let customRange = regexMask.customRange {
			range = customRange
		} else {
			let fullLengthRange = NSRange(location: 0, length: initalString.count)
			range = fullLengthRange
		}

		let maskedString = regexMask.regex.stringByReplacingMatches(in: initalString, options: [], range: range, withTemplate: regexMask.template)

		return maskedString
	}

	func transformWithRegexes(_ transformationRegexes: [VGSTransformationRegex]) -> String {
		return transformationRegexes.reduce(self) { (text, regex) -> String in
			return text.transformWithRegex(regex)
		}
	}
}

internal extension String {
	func normalizedHostname() -> String? {

		// Create component.
		guard var component = URLComponents(string: self) else {return nil}

		if component.query != nil {
			// Clear all queries.
			component.query = nil

			print("WARNING! YOUR HOSTNAME HAS QUERIES AND WILL BE NORMALIZED!")
		}

		var path: String
		if let componentHost = component.host {
			// Use hostname if component is url with scheme.
			path = componentHost
		} else {
			// Use path if component has path only.
			path = component.path
		}

		return path.removeExtraPath()
	}

	func removeExtraPath() -> String {
		guard let index = range(of: "/")?.upperBound else {
			return removeLastSlash()
		}

		let substring = String(self.prefix(upTo: index))
		return substring.removeLastSlash()
	}

	func removeLastSlash() -> String {
		var path = self
		if hasSuffix("/") {
			path = String(path.dropLast())
		}

		return path
	}
}

internal extension String {

	/// Start index from text range. `0` if start is `nil`.
	/// - Parameter range: `VGSTextRange` object.
	/// - Returns: `Int` object, index of start position.
	func startTextRangeIndex(from range: VGSTextRange) -> Int {
		let first: Int
		if let start = range.start {
			first = start
		} else {
			// Take 0 as start index.
			first = 0
		}

		return first
	}

	/// End index from text range. Will be equal to string (length - 1) if text range `end` is `nil`.
	/// - Parameter range: `VGSTextRange` object.
	/// - Returns: `Int` object, index of end position.
	func endTextRangeIndex(from range: VGSTextRange) -> Int {
		let end: Int
		if let last = range.end {
			end = last
		} else {
			// Last index will be text length - 1 for non-empty string.
			if !isEmpty {
				end = count - 1
			} else {
				end = 0
			}
		}

		return end
	}

	func isTextRangeValid(_ range: VGSTextRange) -> Bool {
		let start = startTextRangeIndex(from: range)
		let end = endTextRangeIndex(from: range)

		// Ignore negative ranges.
		if start < 0 || end < 0 {return false}

		// Ignore start > length.
		if start > count {return false}

		// Ignore range if start > end.
		return start < end
	}

	/// Characters count to replace.
	/// - Parameter range: `VGSTextRange` object.
	/// - Returns: `Int` object. Characters count to replace.
	func charactersCountToReplace(from range: VGSTextRange) -> Int {

		let start = startTextRangeIndex(from: range)
		let end = endTextRangeIndex(from: range)

		// Add 1 since we consider closed ranges: [3,3] => 1 string character to replace, [0,1] => 2 string characters to replace.
		return (end - start) + 1
	}

	/// Convert `VGSTextRange` range to Swift String index range. If start or end are beyond the string boundaries, default `startIndex` and `endIndex` will be used.
	/// - Parameter range: `VGSTextRange` object.
	/// - Returns: `Range<String.Index>` object.
	func stringRangeFromIntRange(range: VGSTextRange) -> ClosedRange<String.Index> {

		let first = startTextRangeIndex(from: range)
		let last = endTextRangeIndex(from: range)

		let replacementStartIndex: Index
		let replacementEndIndex: Index

		// Get start index considering endIndex as a limit.
		if let index = self.index(self.startIndex, offsetBy: first, limitedBy: endIndex) {
			replacementStartIndex = index
		} else {
			replacementStartIndex = startIndex
		}

		print("replacementStartIndex.encodedOffset: \(replacementStartIndex.encodedOffset)")

		// Get end index considering endIndex as a limit.
		if let index = self.index(self.startIndex, offsetBy: last, limitedBy: endIndex) {
			replacementEndIndex = index
		} else {
			replacementEndIndex = endIndex
		}

		print(replacementEndIndex.encodedOffset)
		print("replacementEndIndex.encodedOffset: \(replacementEndIndex.encodedOffset)")

		// Return Closed Swift ClosedRange<String.Index> from start and end to include both.
		return replacementStartIndex...replacementEndIndex
	}

	/// Return replacement string from secure range and secureSymbol.
	/// - Parameters:
	///   - range: `VGSTextRange` object.
	///   - secureSymbol: `String` object, default is `*`.
	/// - Returns: `String` object. Replacement secured string.
	func replacementStringFromSecureRange(_ range: VGSTextRange, secureSymbol: String = "*") -> String {
		let replaceCount = charactersCountToReplace(from: range)

		/// Replace all if negative valur or range is bigger that string length.
		if replaceCount <= 0 || replaceCount > self.count {
			return String(repeating: secureSymbol, count: count)
		}

		return String(repeating: secureSymbol, count: replaceCount)
	}

	/// Return new secured string from range and secureSymbol.
	/// - Parameters:
	///   - range: `VGSTextRange` object.
	///   - secureSymbol: `String` object, default is `*`.
	/// - Returns: `String` object, secured string.
	func secure(in range: VGSTextRange, secureSymbol: String = "*") -> String {

		// Don't mask empty text.
		guard !self.isEmpty else {
			return ""
		}

		let securedString: String

		// If start and end are nil mask all text.
		if range.start == nil, range.end == nil {
			securedString = String(repeating: secureSymbol, count: count)
		} else {

			// Don't mask text if range is invalid.
			if !isTextRangeValid(range) {
				return self
			}

			// Get replacement range.
			let replacementRange = stringRangeFromIntRange(range: range)

			// Replacement string.
			let replacementString = replacementStringFromSecureRange(range, secureSymbol: secureSymbol)

			securedString = self.replacingCharacters(in: replacementRange, with: replacementString)
		}
		return securedString
	}
}
