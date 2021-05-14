//
//  VGSShowDemoAppPDFFileTest.swift
//  VGSShowDemoAppUITests
//

import Foundation
import XCTest

class VGSShowDemoAppPDFFileTest: VGSShowDemoAppBaseTestCase {

	/// Views.
	enum Views {
		static let pdfView: VGSUITestElement = .init(type: .other, identifier: "VGSShowDemoApp.ShowPDFScreen.VGSPDFView")
	}

	/// Buttons.
	enum Buttons {
		/// Show button.
		static let show: VGSUITestElement = .init(type: .button, identifier: "VGSShowDemoApp.ShowPDFScreen.ShowButton")

		/// Share PDF button.
		static let sharePDF: VGSUITestElement = .init(type: .button, identifier: "VGSShowDemoApp.ShowPDFScreen.SharePDFButton")

		/// Print button in ui activity controller.
		static let print: VGSUITestElement = .init(type: .button, identifier: "Print")
	}

	/// Labels
	enum Labels {
		/// Unrevealed title label.
		static let unrevealedTitleLabel = VGSUITestElement(type: .label, identifier: "INPUT")

		/// Revealed title label.
		static let revealedTitleLabel = VGSUITestElement(type: .label, identifier: "REVEALED")
	}

	/// Test reveal PDF flow.
	func testShowPDF() {
		// Open PDF tab.
		navigateToPDFUseCase()

		// Check unrevealed state.
		XCTAssert(Labels.unrevealedTitleLabel.find(in: app).exists)

		// Tap on reveal button.
		Buttons.show.find(in: app).tap()

		// Wait for data to reveal.
		wait(forTimeInterval: 50)

		// Check title label for revealed state.
		XCTAssert(Labels.revealedTitleLabel.find(in: app).exists)

		// Check share button is visible.
		XCTAssert(Buttons.sharePDF.find(in: app).exists)

		// Tap to remove blurred view and show share pdf.
		Views.pdfView.find(in: app).tap()

		// Tap to share.
		Buttons.sharePDF.find(in: app).tap()

		// iPad displays sharing activity via pop over, cannot find access to buttons now.
		guard UIDevice.current.userInterfaceIdiom == .phone else {
			// Wait for activity view screen to appear.
			wait(forTimeInterval: 10)

			// Check if print button is available in sharing activity screen.
			XCTAssertTrue(Buttons.print.find(in: app).exists)
			return
		}
	}
}
