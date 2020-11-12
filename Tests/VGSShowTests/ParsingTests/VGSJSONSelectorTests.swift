//
//  VGSJSONSelectorTests.swift
//  VGSShowTests
//
//  Created by Eugene on 28.10.2020.
//

import XCTest
import Foundation
@testable import VGSShow

class VGSJSONSelectorTests: XCTestCase {

	/// Test valid jsonSelectors.
	func testValidJSONSelectors() {
		let validJSONKeyPaths = [
			"card_brand_name",
			"card-brand-name",
			"cardBrandName",
			"card_type",
			"CARD_BRAND_NAME",
			"json.card_name",
			"user_info.CARD_DATA.card-brand-name"
		]

		validJSONKeyPaths.forEach { (jsonKeyPath) in
			XCTAssert(jsonKeyPath.isValidJSONKeyPath)
		}
	}

	/// Test invalid jsonSelectors.
	func testInvalidJSONSelectors() {
		let invalidJSONKeyPaths = [
			"/card_brand_name",
			"{card_name}",
			"card-brand-name  ",
			"  cardBrandName  ",
			"card _ type",
			"CARD_BRAND_NAME%",
			"json.card_name>",
			"user_info.CARD_DATA.card-brand-name?",
			"json.  ",
			" json",
			"json.  card-name",
			"json.card-name*"
		]

		invalidJSONKeyPaths.forEach { (jsonKeyPath) in
			XCTAssertFalse(jsonKeyPath.isValidJSONKeyPath)
		}
	}
}
