//
//  VGSShowBase64Decoder.swift
//  VGSShowSDKTests
//
import XCTest
@testable import VGSShowSDK

class VGSShowBase64DecoderTests: XCTestCase {

    var base64Decoder: VGSShowBase64Decoder!

    override func setUp() {
        super.setUp()
        base64Decoder = VGSShowBase64Decoder()
    }

    func testDecodeJSONForContentPathWithValidBase64() {
        // Given
        let contentPath = "data"
        let originalString = "vgs show test string"
        let base64String = "dmdzIHNob3cgdGVzdCBzdHJpbmc=" // `originalString` encoded in base64
        let json: VGSJSONData = ["data": base64String]

        let result = base64Decoder.decodeJSONForContentPath(contentPath, json: json)

        switch result {
        case .success(let content):
            if case let .rawData(decodedData) = content {
                let decodedString = String(data: decodedData, encoding: .utf8)
                XCTAssertEqual(decodedString, originalString, "Decoded string should match the original string")
            } else {
                XCTFail("Result content should be .rawData type")
            }
        case .failure:
            XCTFail("Decoding should succeed with valid base64 data")
        }
    }

    func testDecodeJSONForContentPathWithInvalidBase64() {
        // Given
        let contentPath = "data"
        let invalidBase64String = "Invalid Base64"
        let json: VGSJSONData = ["data": invalidBase64String]

        // When
        let result = base64Decoder.decodeJSONForContentPath(contentPath, json: json)

        // Then
        switch result {
        case .success:
            XCTFail("Decoding should fail with invalid base64 data")
        case .failure(let error):
          if VGSErrorType.invalidBase64Data == error.type {
            XCTAssertEqual(error.type, .invalidBase64Data, "Error type should be .invalidBase64Data")
            } else {
                XCTFail("Error should be of type .invalidBase64Data")
            }
        }
    }

    func testDecodeJSONForContentPathWithNotFoundField() {
        // Given
        let contentPath = "nonExistingPath"
        let base64String = "dmdzIHNob3cgdGVzdCBzdHJpbmc=" // Valid base64
        let json: VGSJSONData = ["data": base64String]

        // When
        let result = base64Decoder.decodeJSONForContentPath(contentPath, json: json)

        // Then
        switch result {
        case .success:
            XCTFail("Decoding should fail when the content path is incorrect")
        case .failure(let error):
          if VGSErrorType.fieldNotFound == error.type {
            XCTAssertEqual(error.type, .fieldNotFound, "Error type should be .fieldNotFound")
            } else {
                XCTFail("Error should be of type .fieldNotFound")
            }
        }
    }
}
