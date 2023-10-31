//
//  VGSLabelTest.swift
//  VGSShowTests
//
//  Created by Dima on 04.11.2020.
//

import XCTest
@testable import VGSShowSDK

class VGSLabelTests: XCTestCase {
    
    /// Test valid jsonSelectors.
    func testLabelTextAttributes() {
        let label = VGSLabel()
        label.contentPath = "test.label"
        
        XCTAssertTrue(label.contentPath == "test.label")
        XCTAssertTrue(label.isEmpty)
        
        label.label.secureText = "123"
        XCTAssertFalse(label.isEmpty)
        XCTAssertTrue(label.label.text == nil)
        
        label.label.secureText = ""
        XCTAssertTrue(label.isEmpty)
    }
    
    /// Test accessibility properties
    func testLabelAccessibilityAttributes() {
        let labelView = VGSLabel()
        
        // Label
        let accLabel = "accessibility label"
        labelView.vgsAccessibilityLabel = accLabel
        XCTAssertNotNil(labelView.vgsAccessibilityLabel)
        XCTAssertEqual(labelView.vgsAccessibilityLabel, accLabel)
        
        // Hint
        let accHint = "accessibility hint"
        labelView.vgsAccessibilityHint = accHint
        XCTAssertNotNil(labelView.vgsAccessibilityHint)
        XCTAssertEqual(labelView.vgsAccessibilityHint, accHint)
        
        // Element
        labelView.vgsIsAccessibilityElement = true
        XCTAssertTrue(labelView.vgsIsAccessibilityElement)
        
        // Value
        let accValue = "123"
        labelView.label.secureText = accValue
        XCTAssertFalse(labelView.isEmpty)
        XCTAssertNil(labelView.label.accessibilityValue)
        labelView.isSecureText = true
        XCTAssertTrue(labelView.isEmpty)
        XCTAssertNil(labelView.label.accessibilityValue)
    }
    
    func testPlaceholder() {
        let label = VGSLabel()
        
        XCTAssertNil(label.placeholderLabel.attributedText)
        
        let placeholderStyle = VGSPlaceholderLabelStyle(
            color: UIColor.red,
            font: UIFont.preferredFont(forTextStyle: .body),
            adjustsFontForContentSizeCategory: true,
            numberOfLines: 1,
            textAlignment: .left,
            characterSpacing: 0.2,
            textMinLineHeight: 10,
            lineBreakMode: .byCharWrapping)
        
        label.placeholderStyle = placeholderStyle
        label.contentPath = "test.label"
        label.placeholder = "test.placeholder"
        
        XCTAssertTrue(label.contentPath == "test.label")
        XCTAssertTrue(label.placeholder == "test.placeholder")
        XCTAssertTrue(label.isEmpty)
        XCTAssertNotNil(label.placeholderLabel.attributedText)
    }
    
    func testIntrinsicContentSize() {
        let label = VGSLabel()
        
        XCTAssertEqual(label.intrinsicContentSize, CGSize.zero)
        XCTAssertEqual(label.placeholderLabel.intrinsicContentSize, CGSize.zero)
        
        label.label.text = "text.label"
        label.placeholder = "test.placeholder"
        
        XCTAssertNotEqual(label.intrinsicContentSize, CGSize.zero)
        XCTAssertNotEqual(label.placeholderLabel.intrinsicContentSize, CGSize.zero)
    }
    
    func testIntrinsicContentSizeWithAttributedString() {
        let label = VGSLabel()
        XCTAssertEqual(label.label.intrinsicContentSize, CGSize.zero)
        
        let value = "Some value"
        let range = NSRange(location: 0, length: value.count)
        let attributedString = NSMutableAttributedString.init(string: value)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .body), range: range)
        
        label.label.attributedText = attributedString
        
        XCTAssertNotEqual(label.label.intrinsicContentSize, CGSize.zero)
    }
}
