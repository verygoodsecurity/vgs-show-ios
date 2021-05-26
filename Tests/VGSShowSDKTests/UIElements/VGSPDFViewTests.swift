//
//  VGSPDFViewTests.swift
//  VGSShowSDKTests
//

import Foundation
import XCTest
import PDFKit
@testable import VGSShowSDK

class VGSPDFViewTests: XCTestCase {

	func testPDFDocument() {
		let pdfView = VGSPDFView()
		pdfView.contentPath = "test.pdf"

		XCTAssertTrue(pdfView.contentPath == "test.pdf")
		XCTAssertFalse(pdfView.hasDocument)

		pdfView.maskedPdfView.secureDocument = PDFDocument(url: URL(string: "http://www.orimi.com/pdf-test.pdf")!)
		XCTAssertTrue(pdfView.hasDocument)

		pdfView.maskedPdfView.secureDocument = nil
		XCTAssertFalse(pdfView.hasDocument)
	}
}
