//
//  VGSLabelModelTests.swift
//  VGSShowSDKTests
//
import XCTest
@testable import VGSShowSDK
@MainActor
class VGSLabelModelTests: XCTestCase {

    var labelModel: VGSLabelModel!

    override func setUp()  {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testOnValueChanged() {
        labelModel = VGSLabelModel()
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
        labelModel = VGSLabelModel()
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
        labelModel = VGSLabelModel()
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
        labelModel = VGSLabelModel()
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
