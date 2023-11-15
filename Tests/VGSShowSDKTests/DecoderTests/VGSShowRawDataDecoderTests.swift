//
//  VGSShowRawDataDecoderTests.swift
//  VGSShowSDKTests
//

import XCTest
@testable import VGSShowSDK

class VGSShowRawDataDecoderTests: XCTestCase {

    var rawDataDecoder: VGSShowRawDataDecoder!

    override func setUp() {
        super.setUp()
        rawDataDecoder = VGSShowRawDataDecoder()
    }

    func testDecodeRawDataToJSONWithNilData() {
        let data: Data? = nil

        let result = rawDataDecoder.decodeRawDataToJSON(data)

        switch result {
        case .success:
            XCTFail("Decoding should fail when data is nil")
        case .failure(let error):
          if VGSErrorType.unexpectedResponseDataFormat == error.type {
            XCTAssertEqual(error.type, .unexpectedResponseDataFormat, "Error type should be .unexpectedResponseDataFormat")
            } else {
                XCTFail("Error should be of type .unexpectedResponseDataFormat")
            }
        }
    }

    func testDecodeRawDataToJSONWithInvalidJSON() {
        let invalidJSONString = "Invalid JSON"
        let data = invalidJSONString.data(using: .utf8)

        let result = rawDataDecoder.decodeRawDataToJSON(data)

        switch result {
        case .success:
            XCTFail("Decoding should fail when data is not valid JSON")
        case .failure(let error):
          if VGSErrorType.responseIsInvalidJSON == error.type {
            XCTAssertEqual(error.type, .responseIsInvalidJSON, "Error type should be .responseIsInvalidJSON")
            } else {
                XCTFail("Error should be of type .responseIsInvalidJSON")
            }
        }
    }

    func testDecodeRawDataToJSONWithValidJSON() {
        let validJSONString = "{\"key\":\"value\"}"
        let data = validJSONString.data(using: .utf8)

        let result = rawDataDecoder.decodeRawDataToJSON(data)

        switch result {
        case .success(let jsonData):
            XCTAssertEqual(jsonData["key"] as? String, "value", "The JSON should contain the key-value pair from the original data")
        case .failure:
            XCTFail("Decoding should succeed when data is valid JSON")
        }
    }
}

