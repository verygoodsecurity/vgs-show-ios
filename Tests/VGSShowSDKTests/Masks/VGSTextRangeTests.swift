//
//  VGSTextRangeTests.swift
//  VGSShowSDKTests
//

import Foundation
import XCTest
@testable import VGSShowSDK

final class VGSTextRangeTests: XCTestCase {

	struct VGSTextRangeTestItem {
		let range: VGSTextRange
		let isValid: Bool
	}

	func testStartIndexes() {

		let cardData = "4111-1111-1111-1111"

		let testData: [VGSTextRangeTestItem] = [
			// Case 0.
			VGSTextRangeTestItem(range: VGSTextRange(start: nil, end: nil), isValid: true),

			// Case 1.
			VGSTextRangeTestItem(range: VGSTextRange(start: 0, end: nil), isValid: true),

			// Case 2.
			VGSTextRangeTestItem(range: VGSTextRange(start: nil, end: 4), isValid: true),

			// Case 3.
			VGSTextRangeTestItem(range: VGSTextRange(start: 5, end: 4), isValid: false),

			// Case 4.
			VGSTextRangeTestItem(range: VGSTextRange(start: 100, end: 4), isValid: false),

			// Case 5.
			VGSTextRangeTestItem(range: VGSTextRange(start: -1, end: 4), isValid: false),

			// Case 6.
			VGSTextRangeTestItem(range: VGSTextRange(start: 1, end: -4), isValid: false),

			// Case 7.
			VGSTextRangeTestItem(range: VGSTextRange(start: 0, end: 100), isValid: true),

			// Case 8.
			VGSTextRangeTestItem(range: VGSTextRange(start: 3, end: 3), isValid: true)
		]

		for index in 0..<testData.count {
			print("Case: \(index)")

			let range = testData[index].range
			let shouldBeValid = testData[index].isValid

			print("")

			let isRangeValid = cardData.isTextRangeValid(range)

			if shouldBeValid != isRangeValid {
				assertionFailure("Failed. Range: \(range). Actual: \(isRangeValid). Expected: \(shouldBeValid)")
			}
		}
	}
}
