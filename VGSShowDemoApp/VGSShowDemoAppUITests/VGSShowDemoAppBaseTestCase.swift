//
//  VGSShowDemoAppBaseTestCase.swift
//  VGSShowDemoAppUITests
//

import Foundation
import XCTest

class VGSShowDemoAppBaseTestCase: XCTestCase {

	var app: XCUIApplication!

	override func setUp() {
		super.setUp()

		continueAfterFailure = false

		app = XCUIApplication()
		app.launchArguments.append("VGSDemoAppUITests")

		// Start the app.
		app.launch()
	}

	override func tearDown() {
		super.tearDown()
	}

	enum TabBar {
		/// Show tab bar button.
		static let show: VGSUITestElement = .init(type: .button, identifier: "VGSShowDemoApp.TabBar.TabButton.Show")

		/// Collect tab bar button.
		static let collect: VGSUITestElement = .init(type: .button, identifier: "VGSShowDemoApp.TabBar.TabButton.Collect")
	}

	/// Demo app use cases.
	enum UseCases {
		/// Show card data use case flow cell.
		static let showCardData = "Show Collected Card Data"
	}

	/// Navigate to Card Data use case.
	func navigateToCardDataUseCase() {
		app.tables.staticTexts[UseCases.showCardData].tap()
	}

	/// Start app and navigate to specific tab.
	func navigateToTab(identifier tabAccessebilityIdentifier: String) {
		let tabItem = VGSUITestElement(type: .button, identifier: tabAccessebilityIdentifier)

		XCTAssert(tabItem.exists( in: app, timeout: 1))
		tabItem.find(in: app).tap()
	}

	/// Select collect tab.
	func navigateToCollectScreen() {
		// Apple Bug - accessory id is not set for tabBarItem on iOS 12 https://developer.apple.com/forums/thread/64157
		if #available(iOS 13, *) {
			navigateToTab(identifier: TabBar.collect.identifier)
		} else {
			// Before switching to collect screen we have only one `Collect` button in tab bar view hierarchy.
			navigateToTab(identifier: "Collect")
		}
	}

	/// Select show tab.
	func navigateToShowScreen() {
		// Apple Bug - accessory id is not set for tabBarItem on iOS 12 https://developer.apple.com/forums/thread/64157
		if #available(iOS 13, *) {
			navigateToTab(identifier: TabBar.show.identifier)
		} else {
			navigateToTab(identifier: "Show")
		}
	}
}
