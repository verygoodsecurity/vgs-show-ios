//
//  VGSShowNestedDictionaryTests.swift
//  VGSShowTests
//
//  Created by Eugene on 28.10.2020.
//

import XCTest
import Foundation
@testable import VGSShow

class VGSShowNestedDictionaryTests: XCTestCase {

	/// Test nested dictionary parsing.
	func testNestedDictionaryParse() {
		let testCardType = "VISA"

		for data in provideTestData(validPaths: true) {
			let json = data.value
			let keyPath = data.key
			if let cardType: String = json.valueForKeyPath(keyPath: keyPath) {
				XCTAssert(cardType == testCardType)
			} else {
				XCTFail("Value not found for: \(keyPath) in json: \(json)")
			}
		}
	}

	/// Test nested dictionary parsing with wrong keys.
	func testNestedDictionaryParseWrongKeys() {
		for data in provideTestData(validPaths: false) {
			let json = data.value
			let keyPath = data.key
			if let _: String = json.valueForKeyPath(keyPath: keyPath) {
				XCTFail("wrong keypath: \(keyPath) in json: \(json)")
			}
		}
	}

	/// Return test data.
	/// - Parameter validPaths: `Bool` flag. `true` to test valid paths.
	/// - Returns: `[String: JsonData]` object.
	private func provideTestData(validPaths: Bool) -> [String: VGSJSONData] {
		let bundle = Bundle(for: type(of: self))

		let correctKeys = ["card_type",
								"json.card_type",
								"json.card_data.card_type",
								"json.card_data.data.card_type"]

		let wrongKeys = ["card_typ",
								"json.card-type",
								"json.card_data/card_type",
								"json.card_data-data.card_type"]

		let paths = validPaths ? correctKeys : wrongKeys

		var testData = [String: VGSJSONData]()
		for (index, path) in paths.enumerated() {
			if let json = VGSJSONData.init(jsonFileName: "validNestedJSON_\(index+1)", bundle: bundle) {
				testData[path] = json
			} else {
				XCTFail("local json not found for tests")
			}
		}

		return testData
	}
}
