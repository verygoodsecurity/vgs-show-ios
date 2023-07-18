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
        
        // Hint
        let accHint = "accessibility hint"
        labelView.vgsAccessibilityHint = accHint
        XCTAssertNotNil(labelView.vgsAccessibilityHint)
        XCTAssertEqual(labelView.vgsAccessibilityHint, accHint)
        
        labelView.accessibilityHint = accHint
        XCTAssertNotNil(labelView.accessibilityHint)
        XCTAssertEqual(labelView.accessibilityHint, accHint)
        
        // Label
        let accLabel = "accessibility label"
        labelView.vgsAccessibilityLabel = accLabel
        XCTAssertNotNil(labelView.vgsAccessibilityLabel)
        XCTAssertEqual(labelView.vgsAccessibilityLabel, accLabel)
        
        labelView.accessibilityLabel = accLabel
        XCTAssertNotNil(labelView.accessibilityLabel)
        XCTAssertEqual(labelView.accessibilityLabel, accLabel)
        
        // Element
        labelView.vgsIsAccessibilityElement = true
        XCTAssertTrue(labelView.vgsIsAccessibilityElement)
        
        labelView.isAccessibilityElement = true
        XCTAssertTrue(labelView.isAccessibilityElement)
        
        // Value
        let accValue = "acc value"
        labelView.accessibilityValue = accValue
        XCTAssertNil(labelView.accessibilityValue)
    }
}
