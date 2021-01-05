//
//  VGSShowPasswordRangesTests.swift
//  VGSShowSDKTests
//

import Foundation
import XCTest
@testable import VGSShowSDK

struct VGSSecureTextTestData {
	let textRange: VGSTextRange
	let maskedText: String
}

typealias VGSSecureTextTestRanges = (ranges: [VGSTextRange], espectedResult: String)

final class VGSShowSecureTextRangesTests: XCTestCase {

	/// Test regex mask formatting.
	func testFormattedRanges() {

		let cardNumber = "4111111111111111"
		let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"

		let template = "$1-$2-$3-$4"
		let transformedText = "4111-1111-1111-1111"

		let testData: [VGSSecureTextTestData] = [
      // [nil, nil] Start and end nil - mask everything.
      VGSSecureTextTestData(textRange: VGSTextRange(start: nil, end: nil), maskedText: "*******************"),

			// [nil, 3] Start is nil, end is 3 - set 0 for start.
      VGSSecureTextTestData(textRange: VGSTextRange(start: nil, end: 3), maskedText: "****-1111-1111-1111"),

			// [-1, 3] Start is -1, end is 5 - ignore invalid range.
      VGSSecureTextTestData(textRange: VGSTextRange(start: -1, end: 5), maskedText: "4111-1111-1111-1111"),

			// [0, -1] Start is 0, end is -1 - ignore invalid range.
      VGSSecureTextTestData(textRange: VGSTextRange(start: 0, end: -1), maskedText: "4111-1111-1111-1111"),

			// [5, 4] Start > end - ignore invalid range.
      VGSSecureTextTestData(textRange: VGSTextRange(start: 5, end: 4), maskedText: "4111-1111-1111-1111"),

			// [0, nil] Start is 0, end is nil - mask everything.
      VGSSecureTextTestData(textRange: VGSTextRange(start: 0, end: nil), maskedText: "*******************"),

			// [0, nil] Start is 0, end is nil - mask everything.
      VGSSecureTextTestData(textRange: VGSTextRange(start: 0, end: nil), maskedText: "*******************"),

			// [5, 8] Start is 5, end is 8 - apply secure mask.
      VGSSecureTextTestData(textRange: VGSTextRange(start: 5, end: 8), maskedText: "4111-****-1111-1111"),

			// [15, 18] Start is 15, end is 18 - apply secure mask.
      VGSSecureTextTestData(textRange: VGSTextRange(start: 15, end: 18), maskedText: "4111-1111-1111-****"),
      
      // [0, 0] Start is 0, end is 0 - apply secure mask.
      VGSSecureTextTestData(textRange: VGSTextRange(start: 0, end: 0), maskedText: "*111-1111-1111-1111"),
      
      // [18, nil] Start is 18, end is nil - apply secure mask.
      VGSSecureTextTestData(textRange: VGSTextRange(start: 0, end: 0), maskedText: "4111-1111-1111-111*")
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

	/// Test regex mask formatting.
	func testFormattedRangesWithEmojis() {

		let rawText = "🇺🇸123"

		let testData: [VGSSecureTextTestData] = [
			// [nil, nil] Start and end nil - mask everything.
      VGSSecureTextTestData(textRange: VGSTextRange(start: nil, end: nil), maskedText: "****")
		]

		for index in 0..<testData.count {

			print("index: \(index)")

			// Reset previous regex.
			let vgsLabel = VGSLabel()
			vgsLabel.revealedRawText = rawText

			XCTAssert(vgsLabel.label.secureText == rawText)

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
  
  func testValidRangesArray() {
    let cardNumber = "4111111111111111"
    let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"

    let template = "$1-$2-$3-$4"
    let transformedText = "4111-1111-1111-1111"

    let vgsLabel = VGSLabel()
    vgsLabel.revealedRawText = cardNumber

    do {
      let regex = try NSRegularExpression(pattern: cardNumberPattern, options: [])
      vgsLabel.addTransformationRegex(regex, template: template)
    } catch {
      assertionFailure("invalid regex")
    }

    XCTAssert(vgsLabel.label.secureText == transformedText)
    vgsLabel.isSecureText = true

    let testData: [VGSSecureTextTestRanges] = [
                                              ([VGSTextRange(start: nil, end: 3),
                                               VGSTextRange(start: 5, end: 13),
                                               VGSTextRange(start: 15, end: nil)],
                                               espectedResult: "****-*********-****"),

                                              ([VGSTextRange(start: 5, end: 13),
                                               VGSTextRange()],
                                               espectedResult: "*******************"),

                                              ([VGSTextRange(start: 0, end: 0),
                                               VGSTextRange(start: 5, end: 5),
                                               VGSTextRange(start: 18, end: 18)],
                                               espectedResult: "*111*1111-1111-111*"),

                                              ([VGSTextRange(start: 1, end: 10),
                                               VGSTextRange(start: 5, end: 15),
                                               VGSTextRange(start: 18, end: nil)],
                                               espectedResult: "4***************11*")]

      for index in 0..<testData.count {
        let testItem = testData[index]

        let textRanges = testItem.ranges
        vgsLabel.setSecureText(ranges: textRanges)

        XCTAssertTrue(vgsLabel.label.secureText == testItem.espectedResult, "Failed:\n  -espectedResult: \(testItem.espectedResult)\n  -result: \(vgsLabel.label.secureText)")
      }
  }
  
  func testInvalidRangesArray() {
    let cardNumber = "4111111111111111"
    let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"

    let template = "$1-$2-$3-$4"
    let transformedText = "4111-1111-1111-1111"

    let vgsLabel = VGSLabel()
    vgsLabel.revealedRawText = cardNumber

    do {
      let regex = try NSRegularExpression(pattern: cardNumberPattern, options: [])
      vgsLabel.addTransformationRegex(regex, template: template)
    } catch {
      assertionFailure("invalid regex")
    }

    XCTAssert(vgsLabel.label.secureText == transformedText)
    vgsLabel.isSecureText = true

    let testData: [VGSSecureTextTestRanges] = [
                                        ([VGSTextRange(start: -10, end: -3),
                                         VGSTextRange(start: -1, end: 1),
                                         VGSTextRange(start: nil, end: -1),
                                         VGSTextRange(start: 3, end: 1)],
                                         espectedResult: "4111-1111-1111-1111"),

                                        ([VGSTextRange(start: 5, end: 13),
                                         VGSTextRange(start: -5, end: 20)],
                                         espectedResult: "4111-*********-1111"),

                                        ([VGSTextRange(start: 10, end: 9),
                                         VGSTextRange(start: 3, end: -5),
                                         VGSTextRange(start: 0, end: 1)],
                                         espectedResult: "**11-1111-1111-1111"),

                                        ([VGSTextRange(),
                                         VGSTextRange(start: -5, end: 15),
                                         VGSTextRange(start: 18, end: 0)],
                                         espectedResult: "*******************")]

      for testItem in testData {

        let textRanges = testItem.ranges
        vgsLabel.setSecureText(ranges: textRanges)
        
        XCTAssertTrue(vgsLabel.label.secureText == testItem.espectedResult, "Failed:\n  -espectedResult: \(testItem.espectedResult)\n  -result: \(vgsLabel.label.secureText)")
      }
  }
  
  func testNonASCIICharacters() {

    let vgsLabel = VGSLabel()
    vgsLabel.isSecureText = true

    let testData: [VGSSecureTextTestRanges] = [
                                              ([VGSTextRange(start: nil, end: 3),
                                               VGSTextRange(start: 5, end: 13),
                                               VGSTextRange(start: 15, end: nil)],
                                               espectedResult: "****-*********-****"),

                                              ([VGSTextRange(start: 5, end: 13),
                                               VGSTextRange()],
                                               espectedResult: "*******************")]
    
      let testRevealedData = [
        "٤١١١-١١١١-١١١١-١١١١",
        "考拉睡覺-考拉睡覺-考拉睡覺-考拉睡覺",
        "🙈🙉🙊🐒-🐔🐧🐦🐤-♳♴♵♶-1111",
        "@#$%-*()_-:<?/-~!^]"
      ]

    for testText in testRevealedData {
      vgsLabel.revealedRawText = testText
      for index in 0..<testData.count {
        let testItem = testData[index]

        let textRanges = testItem.ranges
        vgsLabel.setSecureText(ranges: textRanges)

        XCTAssertTrue(vgsLabel.label.secureText == testItem.espectedResult, "Failed:\n  -espectedResult: \(testItem.espectedResult)\n  -result: \(vgsLabel.label.secureText)")
      }
    }
      
  }

  func testSecureTextSymbol() {
    let vgsLabel = VGSLabel()
    vgsLabel.revealedRawText = "Hello WORLD"
    vgsLabel.isSecureText = true
    
    XCTAssertTrue(vgsLabel.label.secureText == "***********")
    
    vgsLabel.secureTextSymbol = "🔥"
    XCTAssertTrue(vgsLabel.label.secureText == "🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
    
    vgsLabel.secureTextSymbol = "X"
    XCTAssertTrue(vgsLabel.label.secureText == "XXXXXXXXXXX")
    
    vgsLabel.secureTextSymbol = ""
    XCTAssertTrue(vgsLabel.label.secureText == "Hello WORLD")
  }
}
