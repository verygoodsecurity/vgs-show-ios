//
//  VGSShowPasswordRangesTests.swift
//  VGSShowSDKTests
//

import Foundation
import XCTest
@testable import VGSShowSDK

struct VGSPasswordRangeTestData {
	let textRange: VGSTextRange
	let maskedText: String
}

final class VGSShowPasswordRangesTests: XCTestCase {

	/// Test regex mask formatting.
	func testFormattedRanges() {

		let cardNumber = "4111111111111111"
		let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"

		let template = "$1-$2-$3-$4"
		let transformedText = "4111-1111-1111-1111"

		let testData: [VGSPasswordRangeTestData] = [
			// Start and end nil - mask everything.
			VGSPasswordRangeTestData(textRange: (start: nil, end: nil), maskedText: "*******************"),

			// Start is nil, end is 4 - set 0 for start.
			VGSPasswordRangeTestData(textRange: (start: nil, end: 3), maskedText: "****-1111-1111-1111"),

			// Start is -1, end is 5 - ignore invalid range.
			VGSPasswordRangeTestData(textRange: (start: -1, end: 5), maskedText: "4111-1111-1111-1111"),

			// Start is 0, end is -1 - ignore invalid range.
			VGSPasswordRangeTestData(textRange: (start: 0, end: -1), maskedText: "4111-1111-1111-1111"),

			// Start > end - ignore invalid range.
			VGSPasswordRangeTestData(textRange: (start: 5, end: 4), maskedText: "4111-1111-1111-1111"),

			// Start is 0, end is nil - mask everything.
			VGSPasswordRangeTestData(textRange: (start: 0, end: nil), maskedText: "*******************")
		]

		for index in 0..<testData.count {

			print("index: \(index)")

			// Reset previous regex.
			let vgsLabel = VGSLabel()
			vgsLabel.revealedRawText = cardNumber

			do {
				let regex = try NSRegularExpression(pattern: cardNumberPattern, options: [])
				vgsLabel.addTransformationRegex(regex, template: template)

			} catch {
				assertionFailure("invalid regex")
			}

			XCTAssert(vgsLabel.label.secureText == transformedText)

			let testItem = testData[index]
			vgsLabel.isSecureText = true

			let textRange = testItem.textRange
			vgsLabel.setSecureText(start: textRange.start, end: textRange.end)
			print("label.text: \(vgsLabel.label.secureText!)")
			print("range: \(textRange)")
			print("valid masked text: \(testItem.maskedText)")

			if vgsLabel.label.secureText != testItem.maskedText {
				assertionFailure("Failed!")
			}
		}
	}
}
