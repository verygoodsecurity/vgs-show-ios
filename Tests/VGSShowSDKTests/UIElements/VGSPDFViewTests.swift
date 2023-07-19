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
    
    /// Test accessibility properties
    func testPDFAccessibilityAttributes() {
        let pdfView = VGSPDFView()
        
        // Hint
        let accHint = "accessibility hint"
        pdfView.accessibilityHint = accHint
        XCTAssertNotNil(pdfView.accessibilityHint)
        XCTAssertEqual(pdfView.accessibilityHint, accHint)
        
        // Label
        let accLabel = "accessibility label"
        pdfView.accessibilityLabel = accLabel
        XCTAssertNotNil(pdfView.accessibilityLabel)
        XCTAssertEqual(pdfView.accessibilityLabel, accLabel)
        
        // Element
        pdfView.isAccessibilityElement = true
        XCTAssertTrue(pdfView.isAccessibilityElement)
        
        // Value
        let accValue = "acc value"
        pdfView.accessibilityValue = accValue
        XCTAssertNotNil(pdfView.accessibilityValue)
        XCTAssertEqual(pdfView.accessibilityValue, accValue)
    }
}
