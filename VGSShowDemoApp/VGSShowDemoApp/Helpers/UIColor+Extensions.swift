//
//  UIColor+Extensions.swift
//  VGSShowDemoApp
//

import Foundation
import UIKit

extension UIColor {
	static var inputBlackTextColor: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor {(traits) -> UIColor in
				return traits.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
			}
		} else {
			return .black
		}
	}
}
