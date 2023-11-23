//
//  VGSLabelCopyPasteTests.swift
//  VGSShowSDKTests
//

import Foundation

import XCTest
@testable import VGSShowSDK

class VGSLabelCopyPasteTests: VGSShowBaseTestCase {

  /// Test copy raw text option.
  func testLabelCopyRawText() {
    let label = VGSLabel()
    label.contentPath = "test.label"
    label.revealedRawText = "4111111111111111"

    // Label has no formatting. Copy raw text.
    let textToCopy = label.provideTextForPasteboard(with: .raw)
    XCTAssertTrue(textToCopy == "4111111111111111")

    // Reset text.
    label.revealedRawText = nil
    let clearTextToCopy = label.provideTextForPasteboard(with: .raw)
    XCTAssertTrue(clearTextToCopy == nil)
  }

  /// Test copy text option with applied formatting .
  func testLabelCopyTextWithFormatting() {
    let label = VGSLabel()
    label.contentPath = "test.label"

    let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"
    let template = "$1-$2-$3-$4"

    do {
      let regex = try NSRegularExpression(pattern: cardNumberPattern, options: [])
      // Apply regex.
      label.addTransformationRegex(regex, template: template)
    } catch {
      XCTFail("invalid regex")
    }

    label.revealedRawText = "4111111111111111"

    let rawTextToCopy = label.provideTextForPasteboard(with: .raw)
    XCTAssertTrue(rawTextToCopy == "4111111111111111")

    let transformedTextToCopy = label.provideTextForPasteboard(with: .transformed)
    XCTAssertTrue(transformedTextToCopy == "4111-1111-1111-1111")

    // Clear regex masks.
    label.resetAllMasks()

    let rawTextToCopyAfterMaskReset = label.provideTextForPasteboard(with: .raw)
    XCTAssertTrue(rawTextToCopy == "4111111111111111")

    let transformedTextToCopyAfterMaskReset = label.provideTextForPasteboard(with: .transformed)
    XCTAssertTrue(transformedTextToCopyAfterMaskReset == "4111111111111111")

  }
  
  func testCopyTextDelegate() {
        let label = VGSLabel()
        let mockDelegate = MockVGSLabelDelegate()
        label.delegate = mockDelegate
        label.copyText(format: .raw)

        XCTAssertTrue(mockDelegate.didFinishCopyingText, "Delegate method should be called after copying text")
        XCTAssertEqual(mockDelegate.lastFormatUsed, .raw, "The format passed to the delegate should be .raw")
    }
}

// Mock Delegate
class MockVGSLabelDelegate: VGSLabelDelegate {
    var didFinishCopyingText: Bool = false
    var lastFormatUsed: VGSLabel.CopyTextFormat?

    func labelCopyTextDidFinish(_ label: VGSLabel, format: VGSLabel.CopyTextFormat) {
        didFinishCopyingText = true
        lastFormatUsed = format
    }
}
