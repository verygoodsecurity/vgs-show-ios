//
//  XCUIElement+Extensions.swift
//  VGSShowDemoAppUITests
//

import Foundation
import XCTest

extension XCUIElement {
	/**
	Type text into the textField. Clear previous content if specified.

	- parameters:
		- text: `String` object. Text to type.
		- shouldClear: `Bool` flag. If `true` clears previous input. Default is `true`.
	*/
	func type(_ text: String, shouldClear: Bool = true) {
		tap()

		// Clear previous input if needed.
		if shouldClear, let currentText = value as? String, !currentText.isEmpty {
			let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText.count)
			typeText(deleteString)
		}

		typeText(text)
	}
}
