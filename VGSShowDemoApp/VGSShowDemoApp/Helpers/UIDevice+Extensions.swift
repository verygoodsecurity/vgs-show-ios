//
//  UIDevice+Extensions.swift
//  VGSShowDemoApp
//

import Foundation
import UIKit

extension UIDevice {
	static var isSmallScreen: Bool {
		return UIScreen.main.bounds.size.height <= 568
	}
}
