//
//  VGSAttributedLabel.swift
//  VGSShowSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSAttributedLabel: UILabel {

	/// Minimum text line height. Default is 0 (ignored on styling).
	internal var textMinLineHeight: CGFloat = 0

	/// Spacings between charactes. Default is 0 (ignored on styling).
	internal var characterSpacing: CGFloat = 0

	/// Ingore custom text attributes which can be applied only as `NSAttributedString`. Default is `false`.
	internal var ignoreCustomStringAttributes: Bool = false

	/// Custom styles.
	private var customStyleAttributes: [StringStyleAttribute] {
		var attributes: [StringStyleAttribute] = []

		if textMinLineHeight > 0 {
			attributes.append(.minimumLineHeight(textMinLineHeight))
		}

		// Ignore 0 character spacing (can be negative).
		if characterSpacing != 0 {
			attributes.append(.characterSpacing(characterSpacing))
		}

		// Need to apply current lineBreaking mode.
		if !attributes.isEmpty {
			attributes.append(.lineBreakMode(lineBreakMode))
			attributes.append(.alignment(textAlignment))
		}

		return attributes
	}

	/// `True` if has custom styles which can be applied only as `NSAttributedString`.
	private var hasCustomStyleAttributes: Bool {
		return !customStyleAttributes.isEmpty
	}

	/// `Bool` flag. `true` if custom styles are used and text should be set as `NSAttributedString`.
	private var isCustomAttributedString: Bool {
		return !ignoreCustomStringAttributes && hasCustomStyleAttributes
	}

	// MARK: - Public

	/// Apply styles for placeholder.
	/// - Parameter style: `VGSPlaceholderLabelStyle` object.
	func applyPlaceholderStyle(_ style: VGSPlaceholderLabelStyle) {
		textColor = style.color
		font = style.font
		numberOfLines = style.numberOfLines
		if let alignment = style.textAlignment {
			textAlignment = alignment
		}
		characterSpacing = style.characterSpacing
		textMinLineHeight = style.textMinLineHeight
		if let lineMode = style.lineBreakMode {
			lineBreakMode = lineMode
		}
	}

	// MARK: - Override
	override var text: String? {
		set {
			if let string = newValue {
				if isCustomAttributedString {
					// Create mutable attributed string
					let attributedString = string.attributed(with: customStyleAttributes)

					super.text = newValue
					super.attributedText = attributedString
					return
				}
			}

			// Set text if custom attributes not specified.
			super.text = newValue
		}
		get { return super.text }
	}
}
