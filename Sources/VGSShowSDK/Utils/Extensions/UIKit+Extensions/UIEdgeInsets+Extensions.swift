//
//  UIEdgeInsets+Extensions.swift
//  VGSShow
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal extension UIEdgeInsets {
	var hasNegativeValue: Bool {
		return top < 0 || left < 0 || right < 0 || bottom < 0
	}
}
