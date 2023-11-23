//
//  VGSLabelModelTests.swift
//  VGSShowSDKTests
//
import XCTest
@testable import VGSShowSDK

class VGSLabelModelTests: XCTestCase {

    var labelModel: VGSLabelModel!

    override func setUp() {
        super.setUp()
        labelModel = VGSLabelModel()
    }

    override func tearDown() {
        labelModel = nil
        super.tearDown()
    }

    func testOnValueChanged() {
        let expect = expectation(description: "onValueChanged should be triggered")
        let expectedValue = "Test String"

        labelModel.onValueChanged = { value in
            XCTAssertEqual(value, expectedValue, "Value should match expected value")
            expect.fulfill()
        }

        labelModel.value = expectedValue

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testOnError() {
        let expect = expectation(description: "onError should be triggered")
        let expectedError = VGSShowError(type: .invalidJSONPayload)

        labelModel.onError = { error in
            XCTAssertEqual(error, expectedError, "Error should match expected error")
            expect.fulfill()
        }

        labelModel.handleDecodingResult(.failure(expectedError))

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHandleDecodingResultSuccess() {
        let expect = expectation(description: "handleDecodingResult should handle success correctly")
        let expectedValue = "Test String"

        labelModel.onValueChanged = { value in
            XCTAssertEqual(value, expectedValue, "Value should match expected value")
            expect.fulfill()
        }

        labelModel.handleDecodingResult(.success(.text(expectedValue)))

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHandleDecodingResultFailure() {
        let expect = expectation(description: "handleDecodingResult should handle failure correctly")
        let expectedError = VGSShowError(type: .invalidJSONPayload)

        labelModel.onError = { error in
            XCTAssertEqual(error, expectedError, "Error should match expected error")
            expect.fulfill()
        }

        labelModel.handleDecodingResult(.failure(expectedError))

        waitForExpectations(timeout: 1, handler: nil)
    }

}
