//
//  UIApplication+Extensions.swift
//  VGSShowSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal extension UIApplication {
		static var isRunningUITest: Bool {
				return ProcessInfo().arguments.contains("VGSDemoAppUITests")
		}
}
