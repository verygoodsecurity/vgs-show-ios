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
        attributedLabel = VGSAttributedLabel()
    }
    
    override func tearDown() {
        attributedLabel = nil
        super.tearDown()
    }
    
    func testCustomStyleApplication() {
        attributedLabel.textMinLineHeight = 10
        attributedLabel.characterSpacing = 1.5
        attributedLabel.text = "Test String"
        
        XCTAssertNotNil(attributedLabel.attributedText)
    }
    
    func testApplyPlaceholderStyle() {
        let style = VGSPlaceholderLabelStyle(color: .red, font: .systemFont(ofSize: 12), numberOfLines: 1, textAlignment: .center, characterSpacing: 2.0, textMinLineHeight: 20, lineBreakMode: .byTruncatingTail)
        attributedLabel.applyPlaceholderStyle(style)
        
        XCTAssertEqual(attributedLabel.textColor, style.color)
        XCTAssertEqual(attributedLabel.font, style.font)
        XCTAssertEqual(attributedLabel.numberOfLines, style.numberOfLines)
        XCTAssertEqual(attributedLabel.textAlignment, style.textAlignment)
        XCTAssertEqual(attributedLabel.characterSpacing, style.characterSpacing)
        XCTAssertEqual(attributedLabel.textMinLineHeight, style.textMinLineHeight)
        XCTAssertEqual(attributedLabel.lineBreakMode, style.lineBreakMode)
    }
    
    func testTextSetting() {
        attributedLabel.ignoreCustomStringAttributes = false
        attributedLabel.characterSpacing = 1.5
        attributedLabel.text = "Test String"
        
        XCTAssertNotNil(attributedLabel.attributedText, "AttributedText should be set when custom attributes are specified")
    }
    
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

