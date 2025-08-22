//
//  VGSLabelTest.swift
//  VGSShowTests
//
//  Created by Dima on 04.11.2020.
//

import XCTest
@testable import VGSShowSDK

class VGSLabelTests: XCTestCase {
      var vgsLabel: VGSLabel!

      override func setUp() {
          super.setUp()
          vgsLabel = MainActor.assumeIsolated{VGSLabel()}
//          vgsLabel.mainInitialization()
      }

      override func tearDown() {
          vgsLabel = nil
          super.tearDown()
      }

    /// Test valid jsonSelectors.
    @MainActor
    func testLabelTextAttributes() {
        vgsLabel.contentPath = "test.label"

        XCTAssertTrue(vgsLabel.contentPath == "test.label")
        XCTAssertTrue(vgsLabel.isEmpty)

        vgsLabel.label.secureText = "123"
        XCTAssertFalse(vgsLabel.isEmpty)
        XCTAssertTrue(vgsLabel.label.text == nil)

      vgsLabel.label.secureText = ""
        XCTAssertTrue(vgsLabel.isEmpty)
    }

    /// Test accessibility properties
    @MainActor
    func testLabelAccessibilityAttributes() {
        let accLabel = "accessibility label"
      vgsLabel.vgsAccessibilityLabel = accLabel
        XCTAssertNotNil(vgsLabel.vgsAccessibilityLabel)
        XCTAssertEqual(vgsLabel.vgsAccessibilityLabel, accLabel)

        // Hint
        let accHint = "accessibility hint"
      vgsLabel.vgsAccessibilityHint = accHint
        XCTAssertNotNil(vgsLabel.vgsAccessibilityHint)
        XCTAssertEqual(vgsLabel.vgsAccessibilityHint, accHint)

        // Element
      vgsLabel.vgsIsAccessibilityElement = true
        XCTAssertTrue(vgsLabel.vgsIsAccessibilityElement)

        // Value
        let accValue = "123"
        vgsLabel.label.secureText = accValue
        XCTAssertFalse(vgsLabel.isEmpty)
        XCTAssertNil(vgsLabel.label.accessibilityValue)
      vgsLabel.isSecureText = true
        XCTAssertTrue(vgsLabel.isEmpty)
        XCTAssertNil(vgsLabel.label.accessibilityValue)
    }
    @MainActor
      func testDefaultStyle() {
          XCTAssertTrue(vgsLabel.clipsToBounds, "clipsToBounds should be true")
          XCTAssertEqual(vgsLabel.layer.borderColor, UIColor.lightGray.cgColor, "Border color should be set to light gray")
          XCTAssertEqual(vgsLabel.layer.borderWidth, 1, "Border width should be 1")
          XCTAssertEqual(vgsLabel.layer.cornerRadius, 4, "Corner radius should be 4")
      }
    @MainActor
      func testUIElementsSetup() {
          vgsLabel.placeholder = "placegolder"
          XCTAssertTrue(vgsLabel.subviews.contains(vgsLabel.label), "label should be a subview of VGSLabel")
          XCTAssertTrue(vgsLabel.subviews.contains(vgsLabel.placeholderLabel), "placeholderLabel should be a subview of VGSLabel")
          XCTAssertFalse(vgsLabel.placeholderLabel.isHidden, "placeholderLabel should not be hidden after initialization")
      }
    @MainActor
      func testCallbacksSetup() {
          // Simulate text value change
          let mockText = "test"
          vgsLabel.labelModel.onValueChanged?(mockText)
          XCTAssertEqual(vgsLabel.revealedRawText, mockText, "revealedRawText should be updated with the mock text")

          // Simulate an error
          let mockError = VGSShowError(type: .fieldNotFound)
          let mockDelegate = MockVGSLabelErrorDelegate()
          vgsLabel.delegate = mockDelegate
          vgsLabel.labelModel.onError?(mockError)
          // Check if the delegate method was called
          XCTAssertTrue(mockDelegate.didFailWithError, "Delegate should be notified of the error")
      }
    @MainActor
  func testClearText() {
    let accValue = "123"
    vgsLabel.revealedRawText = accValue
    vgsLabel.clearText()
    XCTAssertNil(vgsLabel.revealedRawText, "Label text should be cleared")
  }
    @MainActor
  func testPropertySetters() {
         let textColor = UIColor.red
         vgsLabel.textColor = textColor
         XCTAssertEqual(vgsLabel.label.textColor, textColor)

         let font = UIFont.systemFont(ofSize: 14)
         vgsLabel.font = font
         XCTAssertEqual(vgsLabel.label.font, font)

         let textAlignment = NSTextAlignment.center
         vgsLabel.textAlignment = textAlignment
         XCTAssertEqual(vgsLabel.label.textAlignment, textAlignment)

        let numberOfLines = 3
        vgsLabel.numberOfLines = numberOfLines
        XCTAssertEqual(vgsLabel.label.numberOfLines, numberOfLines, "numberOfLines should be set correctly on the internal label")

        let lineBreakMode = NSLineBreakMode.byTruncatingTail
        vgsLabel.lineBreakMode = lineBreakMode
        XCTAssertEqual(vgsLabel.label.lineBreakMode, lineBreakMode, "lineBreakMode should be set correctly on the internal label")

        let cornerRadius: CGFloat = 5.0
        vgsLabel.cornerRadius = cornerRadius
        XCTAssertEqual(vgsLabel.layer.cornerRadius, cornerRadius, "cornerRadius should be set correctly on the VGSLabel layer")

        let borderWidth: CGFloat = 1.0
        vgsLabel.borderWidth = borderWidth
        XCTAssertEqual(vgsLabel.layer.borderWidth, borderWidth, "borderWidth should be set correctly on the VGSLabel layer")

        let borderColor = UIColor.green
        vgsLabel.borderColor = borderColor
        XCTAssertEqual(vgsLabel.layer.borderColor, borderColor.cgColor, "borderColor should be set correctly on the VGSLabel layer")

        let textMinLineHeight: CGFloat = 10.0
        vgsLabel.textMinLineHeight = textMinLineHeight
        XCTAssertEqual(vgsLabel.label.textMinLineHeight, textMinLineHeight, "textMinLineHeight should be set correctly on the internal label")

        let characterSpacing: CGFloat = 1.2
        vgsLabel.characterSpacing = characterSpacing
        XCTAssertEqual(vgsLabel.label.characterSpacing, characterSpacing, "characterSpacing should be set correctly on the internal label")

        let adjustsFontSizeToFitWidth = true
        vgsLabel.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        XCTAssertEqual(vgsLabel.label.adjustsFontSizeToFitWidth, adjustsFontSizeToFitWidth, "adjustsFontSizeToFitWidth should be set correctly on the internal label")

        let baselineAlignment = UIBaselineAdjustment.alignCenters
        vgsLabel.baselineAlignment = baselineAlignment
        XCTAssertEqual(vgsLabel.label.baselineAdjustment, baselineAlignment, "baselineAlignment should be set correctly on the internal label")
     }
    @MainActor
     func testSetSecureText() {
         // Test the setSecureText method
         let start = 0
         let end = 5
         vgsLabel.setSecureText(start: start, end: end)
         if let range = vgsLabel.secureTextRanges?.first {
             XCTAssertEqual(range.start, start)
             XCTAssertEqual(range.end, end)
         } else {
             XCTFail("Secure text ranges should be set")
         }
     }
    @MainActor
     func testIntrinsicContentSize() {
         // Test the intrinsicContentSize property
         let testString = "Test String"
         vgsLabel.label.text = testString
         let expectedSize = vgsLabel.label.intrinsicContentSize
         XCTAssertEqual(vgsLabel.intrinsicContentSize, expectedSize)
     }
    @MainActor
  func testFontAndStyleAttributes() {
      let adjustsFontForContentSizeCategory = true
      vgsLabel.vgsAdjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
      XCTAssertEqual(vgsLabel.label.adjustsFontForContentSizeCategory, adjustsFontForContentSizeCategory, "adjustsFontForContentSizeCategory should be set correctly on the internal label")

      let font = UIFont.systemFont(ofSize: 14)
      vgsLabel.font = font
      XCTAssertEqual(vgsLabel.label.font, font, "Font should be set correctly on the internal label")

      let textColor = UIColor.blue
      vgsLabel.textColor = textColor
      XCTAssertEqual(vgsLabel.label.textColor, textColor, "TextColor should be set correctly on the internal label")

      let textAlignment = NSTextAlignment.justified
      vgsLabel.textAlignment = textAlignment
      XCTAssertEqual(vgsLabel.label.textAlignment, textAlignment, "TextAlignment should be set correctly on the internal label")

      let lineBreakMode = NSLineBreakMode.byWordWrapping
      vgsLabel.lineBreakMode = lineBreakMode
      XCTAssertEqual(vgsLabel.label.lineBreakMode, lineBreakMode, "LineBreakMode should be set correctly on the internal label")

      let textMinLineHeight: CGFloat = 12.0
      vgsLabel.textMinLineHeight = textMinLineHeight

      let characterSpacing: CGFloat = 2.0
      vgsLabel.characterSpacing = characterSpacing
  }
}

// Mock Delegate to test error callback
class MockVGSLabelErrorDelegate: VGSLabelDelegate {
    var didFailWithError: Bool = false

    func labelRevealDataDidFail(_ label: VGSLabel, error: VGSShowError) {
        didFailWithError = true
    }
}
