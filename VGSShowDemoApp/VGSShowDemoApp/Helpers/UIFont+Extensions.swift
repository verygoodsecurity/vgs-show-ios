//
//  UIFont+Extensions.swift
//  VGSShowDemoApp
//

import Foundation
import UIKit

extension UIFont {

	/// Large title font with fallback for earlier iOS versions.
	static var demoAppLargeTitleFont: UIFont {
		if #available(iOS 11.0, *) {
			return UIFont.preferredFont(forTextStyle: .largeTitle)
		} else {
			return UIFont.systemFont(ofSize: 18, weight: .bold)
		}
	}

	static var demoAppTextOutputFont: UIFont {
		if UIDevice.isSmallScreen {
			return UIFont.systemFont(ofSize: 14, weight: .semibold)
		} else {
			return UIFont.systemFont(ofSize: 17, weight: .semibold)
		}
	}
}
