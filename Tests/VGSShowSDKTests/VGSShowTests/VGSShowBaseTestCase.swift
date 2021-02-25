//
//  VGSShowBaseTestCase.swift
//  VGSShowSDKTests
//
//  Created on 22.02.2021.
//

import Foundation
import XCTest
@testable import VGSShowSDK

/// Base VGSShow test case for common setup.
class VGSShowBaseTestCase: XCTestCase {

	/// Setup collect before tests.
	override func setUp() {
		super.setUp()

		// Disable analytics in unit tests.
		VGSAnalyticsClient.shared.shouldCollectAnalytics = false
	}
}
