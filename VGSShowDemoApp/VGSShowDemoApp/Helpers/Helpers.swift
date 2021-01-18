//
//  Helpers.swift
//  VGSShowDemoApp
//
//  Created by Eugene on 27.10.2020.
//

import Foundation
import UIKit

/// Subscript `String` value from .evn.
/// - Parameter name: `String` object. Key name.
/// - Returns: `String?` value.
func environmentStringVar(_ name: String) -> String? {
	return ProcessInfo.processInfo.environment[name] 
}

extension UIApplication {
		static var isRunningUITest: Bool {
				return ProcessInfo().arguments.contains("VGSDemoAppUITests")
		}
}
