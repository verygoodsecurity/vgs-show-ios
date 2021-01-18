//
//  VGSShowDemoAppNormalFlowTest.swift
//  VGSShowDemoAppUITests
//

import Foundation
import XCTest

class VGSShowDemoAppNormalFlowTest: VGSBaseRegularFlowTestCase {

	func testCorrectDataFlow() {
		// Open collect screen.
		navigateToCollectScreen()

		// Type data.
		fillInCorrectCardData()

		// Collect data.
		tapToCollectData()

		// Open show screen.
		navigateToShowScreen()

		// Wait until switch screen.
		wait(forTimeInterval: 0.3)

		// Verify unrevealed state.
		testVGSShowState(.unrevealed)

		// Reveal data.
		tapToShowData()

		// Verify revealed state.
		testVGSShowState(.revealed)

		// For debug.
		wait(forTimeInterval: 3)
	}

	func testErrorFlow() {
		// Open collect screen.
		navigateToCollectScreen()

		// Type data.
		fillInWrongCardData()

		// Collect data.
		tapToCollectData()

		// Open show screen.
		navigateToShowScreen()

		// Wait until switch screen.
		wait(forTimeInterval: 0.3)

		// Verify unrevealed state.
		testVGSShowState(.unrevealed)

		// Reveal data.
		tapToShowData()

		// Verify we still in unrevealed state.
		testVGSShowState(.unrevealed)

		// For debug.
		wait(forTimeInterval: 3)
	}
}
