//
//  VGSShowRequestBodyPayloadTests.swift
//  VGSShowSDKTests
//
import XCTest
@testable import VGSShowSDK

class VGSRequestPayloadBodyTests: XCTestCase {

    func testJSONEncodingWithValidJSON() {
        let validJSON: VGSJSONData = ["key": "value"]
        let payloadBody = VGSRequestPayloadBody.json(validJSON)

        switch payloadBody.encodeToRequestBodyData() {
        case .success(let data):
            XCTAssertNotNil(data, "Data should not be nil for valid JSON")

            let decoded = try? JSONSerialization.jsonObject(with: data!, options: []) as? VGSJSONData
            let val1 = validJSON["key"] as? String
            let val2 = decoded?["key"] as? String
            XCTAssertEqual(val1, val2, "Encoded data should match the original JSON")
        case .failure(let error):
            XCTFail("Encoding should succeed, but failed with error: \(error)")
        }
    }

    func testJSONEncodingWithInvalidJSON() {
        let invalidJSON: VGSJSONData = ["key": NSDate()] // NSDate is not a valid JSON object
        let payloadBody = VGSRequestPayloadBody.json(invalidJSON)

        switch payloadBody.encodeToRequestBodyData() {
        case .success:
            XCTFail("Encoding should fail for invalid JSON")
        case .failure(let error):
            XCTAssertNotNil(error, "Error should not be nil for invalid JSON")
        }
    }

    func testAdditionalHeadersForJSONPayload() {
        let jsonPayload: VGSJSONData = ["key": "value"]
        let payloadBody = VGSRequestPayloadBody.json(jsonPayload)
        let headers = payloadBody.additionalHeaders

        XCTAssertEqual(headers["Content-Type"], "application/json", "Content-Type header should be set to application/json for JSON payload")
    }

    func testRawPayloadForJSON() {
        let jsonPayload: VGSJSONData = ["key": "value"]
        let payloadBody = VGSRequestPayloadBody.json(jsonPayload)

        guard let rawPayload = payloadBody.rawPayload as? VGSJSONData else {
            return XCTFail("Raw payload should be accessible and match the input JSON")
        }

        XCTAssertEqual(rawPayload["key"] as? String, "value", "Raw payload should match the original JSON payload")
    }
}
