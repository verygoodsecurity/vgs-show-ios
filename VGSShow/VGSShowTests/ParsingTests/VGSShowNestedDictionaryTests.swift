//
//  VGSShowNestedDictionaryTests.swift
//  VGSShowTests
//
//  Created by Eugene on 28.10.2020.
//

import XCTest
import Foundation

class VGSShowNestedDictionaryTests: XCTestCase {

	/// Test nested dictionary parsing.
	func testNestedDictionaryParse() {
		let testCardType = "VISA"
		let testData: [String: JsonData] = [
			"card_type": ["card_type": testCardType],
			"json.card_type": ["json": ["card_type": testCardType]],
			"json.card_data.card_type": ["json": ["card_data": ["card_type": testCardType]]],
			"json.card_data.data.card_type": ["json": ["card_data": ["cardType": "MASTERCARD"], "data": ["card_type": testCardType]]]
		]

		for data in testData {
			let json = data.value
			let keyPath = data.key
			if let cardType: String = json.valueForKeyPath(keyPath: keyPath) {
				XCTAssert(cardType == testCardType)
			}
		}
	}

	/// Test nested dictionary parsing with wrong keys.
	func testNestedDictionaryParseWrongKeys() {
		let testCardType = "VISA"
		let testData: [String: JsonData] = [
			"card_typ": ["card_type": testCardType],
			"json.card-type": ["json": ["card_type": testCardType]],
			"json.card_data.card_Type": ["json": ["card_data": ["card_type": testCardType]]]
		]

		for data in testData {
			let json = data.value
			let keyPath = data.key
			if let _: String = json.valueForKeyPath(keyPath: keyPath) {
				XCTFail("wrong keypath: \(keyPath) used in json: \(json)")
			}
		}
	}
}
