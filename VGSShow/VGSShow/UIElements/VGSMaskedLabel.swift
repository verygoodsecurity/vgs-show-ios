//
//  VGSMaskedLabel.swift
//  VGSShow
//
//  Created by Dima on 26.10.2020.
//

import Foundation
#if os(iOS)
import UIKit
#endif

internal class VGSMaskedLabel: UILabel {

	/// set/get text just for internal using
	internal var secureText: String? {
		set {
			super.text = newValue
		}
		get {
			return super.text
		}
	}

	/// Minimum text line height. Default is 0 (ignored on styling).
	internal var textMinLineHeight: CGFloat = 0

	/// Spacings between charactes. Default is 0 (ignored on styling).
	internal var characterSpacing: CGFloat = 0

	/// Ingore custom text attributes which can be applied only as `NSAttributedString`. Default is `false`.
	internal var ignoreCustomStringAttributes: Bool = false

	/// Custom styles.
	private var customStyleAttributes: [StringStyleAttribute] {
		var attributes: [StringStyleAttribute] = []
			attributes.append(.minimumLineHeight(textMinLineHeight))

		  attributes.append(.characterSpacing(characterSpacing))

		  attributes.append(.lineBreakMode(lineBreakMode))

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

	// MARK: - Override

	override var text: String? {
		set {
			if let string = newValue {
				if isCustomAttributedString {
					// Create mutable attributed string
					let attributedString = string.attributed(with: customStyleAttributes)

					self.secureText = newValue
					super.attributedText = attributedString
					return
				}
			}

			// Set text if custom attributes not specified.
			self.secureText = newValue
			super.text = newValue
		}

		get {
			return super.text
		}
	}
}
