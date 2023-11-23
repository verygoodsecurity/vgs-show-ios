//
//  VGSPDFViewTests.swift
//  VGSShowSDKTests
//

import Foundation
import XCTest
import PDFKit
@testable import VGSShowSDK

class VGSPDFViewTests: XCTestCase {

  var pdfView: VGSPDFView!
  var mockDelegate: MockVGSPDFViewDelegate!

  override func setUp() {
    super.setUp()
    pdfView = VGSPDFView()
    mockDelegate = MockVGSPDFViewDelegate()
    pdfView.delegate = mockDelegate
  }

    // MARK: - Test PDF document and delegates
    func testPDFDocument() {
      pdfView.contentPath = "test.pdf"

      XCTAssertTrue(pdfView.contentPath == "test.pdf")
      XCTAssertFalse(pdfView.hasDocument)

      pdfView.maskedPdfView.secureDocument = PDFDocument(url: URL(string: "https://www.gemini.com/documents/credit/Test_PDF.pdf")!)
      XCTAssertTrue(pdfView.hasDocument)

      pdfView.maskedPdfView.secureDocument = nil
      XCTAssertFalse(pdfView.hasDocument)
    }

    func testRevealedPdfContentWithValidData() {
      // swiftlint:disable:next force_try
      let validPdfData = try! Data(contentsOf: URL(string: "https://www.gemini.com/documents/credit/Test_PDF.pdf")!)
      pdfView.revealedPdfContent = .rawData(validPdfData)

      XCTAssertNotNil(pdfView.maskedPdfView.secureDocument, "maskedPdfView should have a secureDocument when valid PDF data is set")
      XCTAssertTrue(mockDelegate.didChangeDocument, "Delegate should be notified that document did change")
    }

    func testRevealedPdfContentWithInvalidData() {
      let invalidPdfData = Data() // Assuming empty data is invalid for a PDF
      pdfView.revealedPdfContent = .rawData(invalidPdfData)

      XCTAssertNil(pdfView.maskedPdfView.secureDocument, "maskedPdfView should not have a secureDocument when invalid PDF data is set")
      XCTAssertTrue(mockDelegate.didFailWithError, "Delegate should be notified of an error")
    }

    // MARK: - Test accessibility properties
    func testPDFAccessibilityAttributes() {
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

    func testPDFDisplayMode() {
        let defaultMode = PDFDisplayMode.singlePageContinuous
        XCTAssertEqual(pdfView.maskedPdfView.displayMode, defaultMode, "Default pdf mode  should be .singlePage")
    }

    func testSetPDFDisplayMode() {
        let newMode = PDFDisplayMode.twoUpContinuous
        pdfView.pdfDisplayMode = newMode
        XCTAssertEqual(pdfView.maskedPdfView.displayMode, newMode, "maskedPdfView's pdfDisplayMode set to the new mode")
    }

    func testSetPDFBackgroundColor() {
        let newColor = UIColor.red
        pdfView.pdfBackgroundColor = newColor
        XCTAssertEqual(pdfView.maskedPdfView.backgroundColor, newColor, "maskedPdfView's background color should be set to the new color")
    }

    func testSetPDFBackgroundColorNil() {
        pdfView.pdfBackgroundColor = nil
        let defaultColor = UIColor.gray.withAlphaComponent(0)
        XCTAssertEqual(pdfView.maskedPdfView.backgroundColor, defaultColor, "maskedPdfView's background color should be set to default color when pdfBackgroundColor is nil")
    }

    func testPdfDisplayDirection() {
        let expectedDirection: PDFDisplayDirection = .horizontal
        pdfView.pdfDisplayDirection = expectedDirection
        XCTAssertEqual(pdfView.maskedPdfView.displayDirection, expectedDirection, "maskedPdfView display direction should be updated to the new direction")
    }

    func testPdfAutoScales() {
        let expectedAutoScales = false
        pdfView.pdfAutoScales = expectedAutoScales
        XCTAssertEqual(pdfView.maskedPdfView.autoScales, expectedAutoScales, "maskedPdfView auto scales should be updated to the new value")
    }

    func testDisplayAsBook() {
        let expectedDisplayAsBook = true
        pdfView.displayAsBook = expectedDisplayAsBook
        XCTAssertEqual(pdfView.maskedPdfView.displaysAsBook, expectedDisplayAsBook, "maskedPdfView display as book should be updated to the new value")
    }

    @available(iOS 12.0, *)
    func testPageShadowsEnabled() {
        let expectedShadowsEnabled = false
        pdfView.pageShadowsEnabled = expectedShadowsEnabled
        XCTAssertEqual(pdfView.maskedPdfView.pageShadowsEnabled, expectedShadowsEnabled, "maskedPdfView pageShadowsEnabled should be updated to the new value")
    }

  // MARK: - Test content path
    func testContentPathSetter() {
        let newPath = "new.content.path"
        pdfView.contentPath = newPath

        XCTAssertEqual(pdfView.contentPath, newPath, "The contentPath getter should return the new path")
        XCTAssertEqual(pdfView.pdfViewModel.decodingContentPath, newPath, "The viewModel's decodingContentPath should be updated to the new path")
    }

    func testContentPathGetter() {
        let expectedPath = "expected.content.path"
        pdfView.pdfViewModel.decodingContentPath = expectedPath
        let path = pdfView.contentPath

        XCTAssertEqual(path, expectedPath, "The contentPath getter should return the expected path")
    }

  // MARK: - Test pdf format
  func testPdfFormatSetter() {
      let newFormat: VGSShowPDFFormat = .rawData(.base64)
      pdfView.pdfFormat = newFormat

      if case .pdf(let pdfFormat) = pdfView.pdfViewModel.decodingContentMode {
          if case .rawData(let rawDataFormat) = pdfFormat {
              XCTAssertEqual(rawDataFormat, .base64, "The decodingContentMode on the viewModel should be updated to the new format")
          } else {
              XCTFail("decodingContentMode should be updated with .rawData format")
          }
      } else {
          XCTFail("decodingContentMode should be updated with .pdf format")
      }
  }
}

class MockVGSPDFViewDelegate: VGSPDFViewDelegate {
    var didChangeDocument = false
    var didFailWithError = false

    func documentDidChange(in pdfView: VGSPDFView) {
        didChangeDocument = true
    }

    func pdfView(_ pdfView: VGSPDFView, didFailWithError error: VGSShowError) {
        didFailWithError = true
    }
}
