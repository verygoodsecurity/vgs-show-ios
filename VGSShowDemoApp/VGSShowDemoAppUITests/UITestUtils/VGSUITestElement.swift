//
//  VGSUITestElement.swift
//  VGSShowDemoAppUITests
//

import XCTest
import Foundation

/// Holds XCUIElement identifiers and types.
struct VGSUITestElement {

	/// For simple element lookup. Check `UITestElement.find()`.
	let type: VGSUITestElementType

	/// Accessibility identifier of the UI element.
	let identifier: String

	/// Find element in app.
	/// - Parameter app: `XCUIApplication` object.
	/// - Returns: `XCUIElement` object.
    @MainActor
	func find(in app: XCUIApplication) -> XCUIElement {
		switch type {
		case .label:
			return app.staticTexts[identifier]
		case .button:
			return app.buttons[identifier]
		case .table:
			return app.tables[identifier]
		case .slider:
			return app.sliders[identifier]
		case .other:
			return app.otherElements[identifier]
		case .collection:
			return app.collectionViews[identifier]
		case .image:
			return app.images[identifier]
		case .textField:
			return app.textFields[identifier]
		case .tabBar:
			return app.tabBars[identifier]
		}
	}

	/// Check if element exists in app.
	/// - Parameters:
	///   - app: `XCUIApplication` object.
	///   - timeout: `TimeInterval` to wait, default is `3`.
	/// - Returns: `Bool` flag, `true` if exists.
    @MainActor
	func exists(in app: XCUIApplication, timeout: TimeInterval = 3) -> Bool {
		return find(in: app).waitForExistence(timeout: timeout)
	}
}
