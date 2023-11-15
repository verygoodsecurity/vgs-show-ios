//
//  VGSDataDecoderFactoryTests.swift
//  VGSShowSDKTests
//

import XCTest
@testable import VGSShowSDK

class VGSDataDecoderFactoryTests: XCTestCase {

    func testProvideJSONDecoderForText() {
        let decoder = VGSDataDecoderFactory.provideJSONDecorder(for: .text)
        XCTAssertTrue(decoder is VGSShowTextDecoder, "Decoder should be of type VGSShowTextDecoder for text content mode")
    }

    func testProvideJSONDecoderForPDF() {
        let decoder = VGSDataDecoderFactory.provideJSONDecorder(for: .pdf(.rawData(.base64)))
        XCTAssertTrue(decoder is VGSShowBase64Decoder, "Decoder should be of type VGSShowBase64Decoder for PDF content mode with base64 format")
    }

    func testProvideJSONDecoderForImage() {
        let decoder = VGSDataDecoderFactory.provideJSONDecorder(for: .image(.rawData(.base64)))
        XCTAssertTrue(decoder is VGSShowBase64Decoder, "Decoder should be of type VGSShowBase64Decoder for image content mode with base64 format")
    }
}

