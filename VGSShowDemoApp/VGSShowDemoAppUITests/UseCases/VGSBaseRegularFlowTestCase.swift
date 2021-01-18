//
//  VGSBaseRegularFlowTestCase.swift
//  VGSShowDemoAppUITests
//

import Foundation
import XCTest

class VGSBaseRegularFlowTestCase: VGSShowDemoAppBaseTestCase {

	enum VGSTextField {
		/// Card number.
		static let cardNumber: VGSUITestElement = .init(type: .textField, identifier: "4111 1111 1111 1111")

		/// Expiration date.
		static let expirationDate: VGSUITestElement = .init(type: .textField, identifier: "MM/YYYY")
	}

	enum Screens {
		/// Collect view.
		static let collect: VGSUITestElement = .init(type: .other, identifier: "VGSDemoApp.Screens.CollectViewController")

		/// Expiration date.
		static let expirationDate: VGSUITestElement = .init(type: .textField, identifier: "MM/YYYY")
	}

	enum Buttons {
		/// Collect button.
		static let collect: VGSUITestElement = .init(type: .button, identifier: "VGSShowDemoApp.CollectScreen.CollectButton")

		/// Show button.
		static let show: VGSUITestElement = .init(type: .button, identifier: "VGSShowDemoApp.ShowScreen.ShowButton")
	}

	enum Labels {

		enum VGSLabels {
			/// Card number VGSLabel.
			static let cardNumber: VGSUITestElement = .init(type: .other, identifier: "VGSShowDemoApp.ShowScreen.CardNumberLabel")

			/// Expiration date VGSLabel.
			static let expirationDate: VGSUITestElement = .init(type: .other, identifier: "VGSShowDemoApp.ShowScreen.ExpirationDateLabel")
		}

		enum MaskedLabels {
			/// Card number with revealed data.
			static let cardNumber: VGSUITestElement = .init(type: .label, identifier: "4111-1111-1111-1111")

			/// Card number with expiration date.
			static let expirationDate: VGSUITestElement = .init(type: .label, identifier: "10/2025")
		}

		enum PlaceholderLabels {
			/// Card number placeholder label.
			static let cardNumber: VGSUITestElement = .init(type: .label, identifier: "Card number")

			/// Expiration placeholder label.
			static let expirationDate: VGSUITestElement = .init(type: .label, identifier: "Expiration date")
		}
	}

	func fillInCorrectCardData() {
		VGSTextField.cardNumber.find(in: app).type("4111111111111111")
		VGSTextField.expirationDate.find(in: app).type("10")
		VGSTextField.expirationDate.find(in: app).type("2025", shouldClear: false)

		// Tap on view to close keyboard.
		Screens.collect.find(in: app).tap()
	}

	func fillInWrongCardData() {
		VGSTextField.cardNumber.find(in: app).type("123456789")
		VGSTextField.expirationDate.find(in: app).type("10")
		VGSTextField.expirationDate.find(in: app).type("2025", shouldClear: false)

		// Tap on view to close keyboard.
		Screens.collect.find(in: app).tap()
	}

	func tapToCollectData() {
		// Tap on collect button to send data.
		Buttons.collect.find(in: app).tap()

		// Wait some time for submit data.
		wait(forTimeInterval: 3)
	}

	func tapToShowData() {
		// Tap on collect button to send data.
		Buttons.show.find(in: app).tap()

		// Wait some time for submit data.
		wait(forTimeInterval: 3)
	}

	/// VGSShow state.
	enum VGSShowState {

		/// No revealed data, should be placeholders only.
		case unrevealed

		/// Has revealed data, placeholders are hidden and card data should be displayed.
		case revealed
	}

	func testVGSShowState(_ state: VGSShowState) {
		// Verify VGS labels exist.
		XCTAssert(Labels.VGSLabels.cardNumber.find(in: app).exists)
		XCTAssert(Labels.VGSLabels.expirationDate.find(in: app).exists)

		switch state {
		case .unrevealed:
			XCTAssertFalse(Labels.MaskedLabels.cardNumber.find(in: app).exists)
			XCTAssertFalse(Labels.MaskedLabels.expirationDate.find(in: app).exists)

			// Verify VGS label have placeholders.
			XCTAssert(Labels.PlaceholderLabels.cardNumber.find(in: app).exists)
			XCTAssert(Labels.PlaceholderLabels.expirationDate.find(in: app).exists)
		case .revealed:
			// Verify VGS masked labels are on screen.
			XCTAssert(Labels.MaskedLabels.cardNumber.find(in: app).exists)
			XCTAssert(Labels.MaskedLabels.expirationDate.find(in: app).exists)

			// Verify VGS placeholders are hidden.
			XCTAssertFalse(Labels.PlaceholderLabels.cardNumber.find(in: app).exists)
			XCTAssertFalse(Labels.PlaceholderLabels.expirationDate.find(in: app).exists)
		}
	}
}
