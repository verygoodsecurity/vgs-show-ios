//
//  VGSMaskedLabel.swift
//  VGSShow
//
//  Created by Dima on 26.10.2020.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSMaskedLabel: VGSAttributedLabel {

	// MARK: - Override
	@available(*, deprecated, message: "Deprecated attribute.")
	override var text: String? {
		set {
			secureText = newValue
		}
		get {
			if UIApplication.isRunningUITest {
				return super.text
			} else {
				return nil
			}
		}
	}

	@available(*, deprecated, message: "Deprecated attribute.")
	override var attributedText: NSAttributedString? {
		set {
			secureAttributedText = newValue
		}
		get { return nil }
	}

	/// set/get text just for internal using
	internal var secureText: String? {
		set {
			// Set text if custom attributes not specified.
			super.text = newValue
		}
		get {
			return super.text
		}
	}

	/// set/get attribute text just for internal using
	internal var secureAttributedText: NSAttributedString? {
		set {
			super.attributedText = newValue
		}
		get {
			return super.attributedText
		}
	}

	internal var isEmpty: Bool {
		return secureText?.isEmpty ?? true
	}

  override var accessibilityValue: String? {
    get {
      return super.accessibilityValue
    }

    set {
      // Don't set accessibility value in UITests since UITest manager
      // uses current accessibility value for text which won't match with
      // secured masked text.
      if !UIApplication.isRunningUITest {
        super.accessibilityValue = newValue
      }
    }
  }

  /// The natural size for the Lbel, considering only properties of the view itself.
  override var intrinsicContentSize: CGSize {
    return getIntrinsicContentSize()
  }

  /// Calculate internal label IntrinsicContentSize
  func getIntrinsicContentSize() -> CGSize {
    /// Get formatted text from label
    guard let txt = secureAttributedText else { return super.intrinsicContentSize }
    return self.computeTextSize(for: txt)
  }
}
