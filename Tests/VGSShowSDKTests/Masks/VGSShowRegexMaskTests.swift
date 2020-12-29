//
//  VGSShowRegexMaskTests.swift
//  VGSShowTests
//
//  Created by Eugene on 09.11.2020.
//

import XCTest
import Foundation
@testable import VGSShowSDK

final class VGSShowRegexMaskTests: XCTestCase {

	/// Test regex mask formatting.
	func testRegexMask() {

		let cardNumber = "4111111111111111"
		let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"

		let templates = ["$1-$2-$3-$4", "$1 $2 $3 $4", "$1/$2/$3/$4"]
		let transformedTexts = ["4111-1111-1111-1111", "4111 1111 1111 1111", "4111/1111/1111/1111"]

		let vgsLabel = VGSLabel()
		vgsLabel.revealedRawText = cardNumber

		for index in 0..<templates.count {
      // Reset previous regex.
			vgsLabel.resetAllMasks()

			do {
				let regex = try NSRegularExpression(pattern: cardNumberPattern, options: [])
				vgsLabel.addTransformationRegex(regex, template: templates[index])
			} catch {
				assertionFailure("invalid regex")
			}

			print("label.text: \(vgsLabel.label.secureText)")
			XCTAssert(vgsLabel.label.secureText == transformedTexts[index])
		}

		// Test reset to raw text.
		vgsLabel.resetAllMasks()
		XCTAssert(vgsLabel.label.secureText == cardNumber)

		// Test multiple formatters.
		for index in 0..<templates.count {
			do {
				let regex = try NSRegularExpression(pattern: cardNumberPattern, options: [])
				vgsLabel.addTransformationRegex(regex, template: templates[index])
			} catch {
				assertionFailure("invalid regex")
			}
		}

		XCTAssert(vgsLabel.textFormattersContainer.transformationRegexes.count == templates.count)
	}
}
