//
//  VGSAttributedLabelTests.swift
//  VGSShowSDKTests
//
import XCTest
@testable import VGSShowSDK

class VGSAttributedLabelTests: XCTestCase {

    var attributedLabel: VGSAttributedLabel!

    override func setUp() {
        super.setUp()
        attributedLabel = MainActor.assumeIsolated {VGSAttributedLabel()}
    }

    override func tearDown() {
        super.tearDown()
        attributedLabel = nil
    }
    @MainActor
    func testCustomStyleApplication() {
        attributedLabel.textMinLineHeight = 10
        attributedLabel.characterSpacing = 1.5
        attributedLabel.text = "Test String"
        
        XCTAssertNotNil(attributedLabel.attributedText)
    }
    @MainActor
    func testApplyPlaceholderStyle() {
            var style = VGSPlaceholderLabelStyle()
            style.color = UIColor.red
            style.font =  UIFont.systemFont(ofSize: 12)
            style.numberOfLines = 1
            style.textAlignment = NSTextAlignment.center
            style.characterSpacing = 2.0
            style.textMinLineHeight = 20.0
            style.lineBreakMode = NSLineBreakMode.byTruncatingTail
            attributedLabel.applyPlaceholderStyle(style)
            
            XCTAssertEqual(attributedLabel.textColor, style.color)
            XCTAssertEqual(attributedLabel.font, style.font)
            XCTAssertEqual(attributedLabel.numberOfLines, style.numberOfLines)
            XCTAssertEqual(attributedLabel.textAlignment, style.textAlignment)
            XCTAssertEqual(attributedLabel.characterSpacing, style.characterSpacing)
            XCTAssertEqual(attributedLabel.textMinLineHeight, style.textMinLineHeight)
            XCTAssertEqual(attributedLabel.lineBreakMode, style.lineBreakMode)
    }
    @MainActor
    func testTextSetting() {
        attributedLabel.ignoreCustomStringAttributes = false
        attributedLabel.characterSpacing = 1.5
        attributedLabel.text = "Test String"

        XCTAssertNotNil(attributedLabel.attributedText, "AttributedText should be set when custom attributes are specified")
    }
    @MainActor
    func testIntrinsicContentSize() {
        attributedLabel.text = "Test"
        let expectedSize = attributedLabel.computeTextSize(for: attributedLabel.text!)
        XCTAssertEqual(attributedLabel.intrinsicContentSize, expectedSize, "Intrinsic content size should match computed size for string")

        let attributedString = NSAttributedString(string: "Test", attributes: [.font: UIFont.systemFont(ofSize: 16)])
        let expectedAttributedStringSize = attributedLabel.computeTextSize(for: attributedString)
        // Set the attributed text and force layout
        attributedLabel.attributedText = attributedString
        attributedLabel.layoutIfNeeded()
        XCTAssertEqual(attributedLabel.intrinsicContentSize, expectedAttributedStringSize, "Intrinsic content size should match computed size for attributed string")
    }
}
