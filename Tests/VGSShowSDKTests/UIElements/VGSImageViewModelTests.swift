//
//  VGSImageViewModelTests.swift
//  VGSShowSDKTests
//
import XCTest
@testable import VGSShowSDK

class VGSImageViewModelTests: XCTestCase {

    var viewModel: VGSImageViewModel!

    override func setUp() {
        super.setUp()
        viewModel = VGSImageViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testOnValueChanged() {
        let expect = expectation(description: "onValueChanged should be triggered")
        let expectedData = Data("imageData".utf8)

        viewModel.onValueChanged = { content in
            if case .rawData(let data) = content {
                XCTAssertEqual(data, expectedData, "Data should match expected data")
                expect.fulfill()
            } else {
                XCTFail("Value should be of type .rawData")
            }
        }

        viewModel.value = .rawData(expectedData)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testOnError() {
        let expect = expectation(description: "onError should be triggered")
        let expectedError = VGSShowError(type: .invalidJSONPayload)

        viewModel.onError = { error in
            XCTAssertEqual(error, expectedError, "Error should match expected error")
            expect.fulfill()
        }
        viewModel.handleDecodingResult(.failure(expectedError))
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHandleDecodingResultSuccess() {
        let expect = expectation(description: "handleDecodingResult should handle success correctly")
        let expectedData = Data("imageData".utf8)

        viewModel.onValueChanged = { content in
            if case .rawData(let data) = content {
                XCTAssertEqual(data, expectedData, "Data should match expected data")
                expect.fulfill()
            } else {
                XCTFail("Value should be of type .rawData")
            }
        }

        viewModel.handleDecodingResult(.success(.rawData(expectedData)))
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHandleDecodingResultFailure() {
        let expect = expectation(description: "handleDecodingResult should handle failure correctly")
        let expectedError = VGSShowError(type: .invalidJSONPayload)

        viewModel.onError = { error in
            XCTAssertEqual(error, expectedError, "Error should match expected error")
            expect.fulfill()
        }

        viewModel.handleDecodingResult(.failure(expectedError))
        waitForExpectations(timeout: 1, handler: nil)
    }
}
