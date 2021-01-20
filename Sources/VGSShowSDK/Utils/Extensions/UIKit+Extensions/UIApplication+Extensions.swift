//
//  UIApplication+Extensions.swift
//  VGSShowSDK
//

import Foundation
import UIKit

internal extension UIApplication {
		static var isRunningUITest: Bool {
				return ProcessInfo().arguments.contains("VGSDemoAppUITests")
		}
}
