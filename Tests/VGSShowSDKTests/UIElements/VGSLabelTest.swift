//
//  VGSLabelTest.swift
//  VGSShowTests
//
//  Created by Dima on 04.11.2020.
//

import XCTest
@testable import VGSShowSDK
@testable import VGSShowSDK

class VGSLabelTests: XCTestCase {

  /// Test valid jsonSelectors.
  func testLabelTextAttributes() {
    let label = VGSLabel()
    label.fieldName = "test.label"
    
    XCTAssertTrue(label.fieldName == "test.label")
    XCTAssertTrue(label.isEmpty)
    
    label.label.secureText = "123"
    XCTAssertFalse(label.isEmpty)
    XCTAssertTrue( label.label.text == nil)
    
    label.label.secureText = ""
    XCTAssertTrue(label.isEmpty)
  }
}
