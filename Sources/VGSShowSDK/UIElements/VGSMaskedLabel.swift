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

	internal var isEmpty: Bool {
		return secureText?.isEmpty ?? true
	}
}
