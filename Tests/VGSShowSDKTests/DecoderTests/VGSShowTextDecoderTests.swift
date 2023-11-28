//
//  VGSShowTextDecoderTests.swift
//  VGSShowSDKTests
//
import XCTest
@testable import VGSShowSDK

// Mock JSON data and errors
struct MockJSON {
    static let valid = ["path": "text to decode"]
    static let invalid = ["invalidPath": "error text"]
}

class VGSShowTextDecoderTests: XCTestCase {

    var decoder: VGSShowTextDecoder!

    override func setUp() {
        super.setUp()
        decoder = VGSShowTextDecoder()
    }

    func testDecodeJSONSuccess() {
        let json: VGSJSONData = MockJSON.valid
        let contentPath = "path"

        let result = decoder.decodeJSONForContentPath(contentPath, json: json)

        // Then
        switch result {
        case .success(let content):
            if case let .text(decodedText) = content {
                XCTAssertEqual(decodedText, "text to decode", "Decoded text should match the text in the JSON")
            } else {
                XCTFail("Result content should be .text type")
            }
        case .failure:
            XCTFail("Decoding should succeed")
        }
    }

    func testDecodeJSONFailure() {
        let json: VGSJSONData = MockJSON.invalid
        let contentPath = "path"

        let result = decoder.decodeJSONForContentPath(contentPath, json: json)

        switch result {
        case .success:
            XCTFail("Decoding should fail when the content path is incorrect")
        case .failure(let error):
          if error.type == VGSErrorType.fieldNotFound {
            XCTAssertEqual(error.type, .fieldNotFound, "Error type should be .fieldNotFound")
          } else {
            XCTFail("Error should be of type .fieldNotFound")
          }
        }
    }
}
