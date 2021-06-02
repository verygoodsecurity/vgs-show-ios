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

	}

	/// Labels
	enum Labels {
		/// Unrevealed title label.
		static let unrevealedTitleLabel = VGSUITestElement(type: .label, identifier: "INPUT")

		/// Revealed title label.
		static let revealedTitleLabel = VGSUITestElement(type: .label, identifier: "REVEALED. TAP ON VIEW TO REMOVE BLUR.")
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
	}
}
