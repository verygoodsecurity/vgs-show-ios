//
//  VGSShowRequestOptionsTests.swift
//  VGSShowSDKTests
//

import XCTest
@testable import VGSShowSDK

class VGSShowRequestOptionsTests: XCTestCase {

    func testInitSetsDefaultValues() {
        let requestOptions = VGSShowRequestOptions()
        XCTAssertNil(requestOptions.requestTimeoutInterval, "Default requestTimeoutInterval should be nil")
    }

    func testSettingRequestTimeoutInterval() {
        var requestOptions = VGSShowRequestOptions()
        requestOptions.requestTimeoutInterval = 10.0
        XCTAssertEqual(requestOptions.requestTimeoutInterval, 10.0, "The requestTimeoutInterval should be set to 10.0")
    }

    func testRequestTimeoutIntervalDefaultIsNil() {
        let requestOptions = VGSShowRequestOptions()
        XCTAssertNil(requestOptions.requestTimeoutInterval, "requestTimeoutInterval should be nil by default")
    }
}

