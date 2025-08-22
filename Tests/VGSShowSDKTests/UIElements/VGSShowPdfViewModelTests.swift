//
//  VGSShowPdfViewModelTests.swift
//  VGSShowSDKTests
//

import XCTest
@testable import VGSShowSDK
@MainActor
class VGSShowPdfViewModelTests: XCTestCase {

    var viewModel: VGSShowPdfViewModel!

    override func setUp() {
        super.setUp()
    }

    func testHandleDecodingResultSuccess() {
        viewModel = VGSShowPdfViewModel()
        let expectedData = Data(repeating: 0, count: 5)
        let decodingResult: VGSShowDecodingResult = .success(.rawData(expectedData))

        let expectation = self.expectation(description: "Value changed")
        viewModel.onValueChanged = { value in
            if case let .rawData(data)? = value {
                XCTAssertEqual(data, expectedData, "Value should be updated with expected raw data")
            } else {
                XCTFail("Value should be of type VGSShowPDFContent.rawData")
            }
            expectation.fulfill()
        }

        viewModel.handleDecodingResult(decodingResult)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHandleDecodingResultFailure() {
        viewModel = VGSShowPdfViewModel()
        let expectedError = VGSShowError(type: .invalidBase64Data)
        let decodingResult: VGSShowDecodingResult = .failure(expectedError)

        let expectation = self.expectation(description: "Error occurred")
        viewModel.onError = { error in
            XCTAssertEqual(error.type, expectedError.type, "Error type should be the expected type")
            expectation.fulfill()
        }

        viewModel.handleDecodingResult(decodingResult)
        waitForExpectations(timeout: 1, handler: nil)
    }
}
