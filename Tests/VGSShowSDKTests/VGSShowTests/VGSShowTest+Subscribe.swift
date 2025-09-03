//
//  VGSShowTest+Subscribe.swift
//  VGSShowTests
//
//  Created by Dima on 10.11.2020.
//

import XCTest
@testable import VGSShowSDK
@MainActor
extension VGSShowTests {

	func testSubscribeUnsubcribeLabels() {
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)

		let label1 = VGSLabel()
		label1.contentPath = "label1"
		vgsShow.subscribe(label1)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 1)
		XCTAssertTrue(vgsShow.subscribedViews.count == 1)

		let label2 = VGSLabel()
		label1.contentPath = "label2"
		vgsShow.subscribe(label2)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 2)
		XCTAssertTrue(vgsShow.subscribedViews.count == 2)

		/// test no dublicates
		vgsShow.subscribe(label2)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 2)
		XCTAssertTrue(vgsShow.subscribedViews.count == 2)

		vgsShow.unsubscribe(label2)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 1)
		XCTAssertTrue(vgsShow.subscribedViews.count == 1)

		vgsShow.unsubscribe(label1)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 0)

		vgsShow.subscribe(label1)
		vgsShow.subscribe(label2)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 2)
		XCTAssertTrue(vgsShow.subscribedViews.count == 2)

		vgsShow.unsubscribeAllViews()
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 0)
	}

	func testSubscribeExternalView() {
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 0)

		let customView = CustomView()
		vgsShow.subscribe(customView)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 0)

		vgsShow.unsubscribe(customView)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 0)
	}

	func testSubscribeDuplicateViews() {
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)

		let label1 = VGSLabel()
		label1.contentPath = "label1"
		vgsShow.subscribe(label1)
		vgsShow.subscribe(label1)
		vgsShow.subscribe(label1)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 1)
		XCTAssertTrue(vgsShow.subscribedViews.count == 1)
	}

	func testUnsubscribeFromEmptyArray() {
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)

		/// test no crash when unsubscribe from empty array
		let label1 = VGSLabel()
		label1.contentPath = "label1"
		vgsShow.subscribe(label1)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 1)

		vgsShow.unsubscribe(label1)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)

		vgsShow.unsubscribe(label1)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
	}

	func testSubscribeUnsubcribePDFViews() {
		XCTAssertTrue(vgsShow.subscribedPDFViews.count == 0)

		let pdfView1 = VGSPDFView()
		pdfView1.contentPath = "pdf_1"
		vgsShow.subscribe(pdfView1)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 1)
		XCTAssertTrue(vgsShow.subscribedPDFViews.count == 1)

		let pdfView2 = VGSPDFView()
		pdfView2.contentPath = "pdf_2"
		vgsShow.subscribe(pdfView2)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 2)
		XCTAssertTrue(vgsShow.subscribedPDFViews.count == 2)

		/// test no dublicates
		vgsShow.subscribe(pdfView2)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 2)
		XCTAssertTrue(vgsShow.subscribedPDFViews.count == 2)

		vgsShow.unsubscribe(pdfView2)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 1)
		XCTAssertTrue(vgsShow.subscribedPDFViews.count == 1)

		vgsShow.unsubscribe(pdfView1)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 0)
		XCTAssertTrue(vgsShow.subscribedPDFViews.count == 0)

		vgsShow.subscribe(pdfView1)
		vgsShow.subscribe(pdfView2)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 2)
		XCTAssertTrue(vgsShow.subscribedPDFViews.count == 2)

		vgsShow.unsubscribeAllViews()
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 0)
		XCTAssertTrue(vgsShow.subscribedPDFViews.count == 0)
	}

	func testSubscribeDuplicatePDFViews() {
		XCTAssertTrue(vgsShow.subscribedPDFViews.count == 0)

		let pdfView1 = VGSPDFView()
		pdfView1.contentPath = "label1"
		vgsShow.subscribe(pdfView1)
		vgsShow.subscribe(pdfView1)
		vgsShow.subscribe(pdfView1)
		XCTAssertTrue(vgsShow.subscribedLabels.count == 0)
		XCTAssertTrue(vgsShow.subscribedViews.count == 1)
		XCTAssertTrue(vgsShow.subscribedPDFViews.count == 1)
	}
}

/// Testable view that conforms to public VGSViewProtocol protocol
class CustomView: UIView, VGSViewProtocol {

	var contentPath: String! = "some_field"

}
