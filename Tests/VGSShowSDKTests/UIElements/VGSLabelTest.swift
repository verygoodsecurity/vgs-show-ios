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
        XCTAssertEqual(labelView.label.accessibilityValue, accValue)
        labelView.isSecureText = true
        XCTAssertTrue(labelView.isEmpty)
        XCTAssertNil(labelView.label.accessibilityValue)
    }
}
