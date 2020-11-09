//
//  VGSShowRegexMaskTests.swift
//  VGSShowTests
//
//  Created by Eugene on 09.11.2020.
//

import XCTest
import Foundation

final class VGSShowRegexMaskTests: XCTestCase {

	/// Test regex mask formatting.
	func textRegexMask() {

		let cardNumber = "4111111111111111"

		// Test fomatting with `-`.
		if let regexMask = try? VGSShowRegexMask(pattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})", template: "$1-$2-$3-$4") {
			let formattedNumber = cardNumber.transformWithRegexMask(regexMask)
			XCTAssert(formattedNumber == "4111-1111-1111-1111")
		}

		// Test fomatting with ` `.
		if let regexMask = try? VGSShowRegexMask(pattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})", template: "$1 $2 $3 $4") {
			let formattedNumber = cardNumber.transformWithRegexMask(regexMask)
			XCTAssert(formattedNumber == "4111 1111 1111 1111")
		}

		// Test fomatting with `/`.
		if let regexMask = try? VGSShowRegexMask(pattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})", template: "$1/$2/$3/$4") {
			let formattedNumber = cardNumber.transformWithRegexMask(regexMask)
			XCTAssert(formattedNumber == "4111/1111/1111/1111")
		}
	}
}
