//
//  VGSBaseRegularFlowTestCase.swift
//  VGSShowDemoAppUITests
//

import Foundation
import XCTest

class VGSBaseRegularFlowTestCase: VGSShowDemoAppBaseTestCase {

	enum VGSTextField {
		/// Card holder name.
		static let cardHolderName: VGSUITestElement = .init(type: .textField, identifier: "Joe Business")

		/// Card number.
		static let cardNumber: VGSUITestElement = .init(type: .textField, identifier: "4111 1111 1111 1111")

		/// Expiration date.
		static let expirationDate: VGSUITestElement = .init(type: .textField, identifier: "MM/YYYY")
	}

	enum Screens {
		/// Collect view.
		static let collect: VGSUITestElement = .init(type: .other, identifier: "VGSDemoApp.Screens.CollectViewController")
	}

	enum Buttons {
		/// Collect button.
		static let collect: VGSUITestElement = .init(type: .button, identifier: "VGSShowDemoApp.CollectScreen.CollectButton")

		/// Show button.
		static let show: VGSUITestElement = .init(type: .button, identifier: "VGSShowDemoApp.ShowScreen.ShowButton")

		/// Copy button.
		static let copyCard: VGSUITestElement = .init(type: .button, identifier: "VGSShowDemoApp.ShowScreen.CopyCardButton")
	}

	enum Labels {

		enum VGSLabels {
			/// Card holder VGSLabel.
			static let cardHolderName: VGSUITestElement = .init(type: .other, identifier: "VGSShowDemoApp.ShowScreen.CardHolderNameLabel")

			/// Card number VGSLabel.
			static let cardNumber: VGSUITestElement = .init(type: .other, identifier: "VGSShowDemoApp.ShowScreen.CardNumberLabel")

			/// Expiration date VGSLabel.
			static let expirationDate: VGSUITestElement = .init(type: .other, identifier: "VGSShowDemoApp.ShowScreen.ExpirationDateLabel")
		}

		enum MaskedLabels {
			/// Card holder name with revealed data.
			static let cardHolderName: VGSUITestElement = .init(type: .label, identifier: "Joe Business")

			/// Card number with revealed data.
			static let cardNumber: VGSUITestElement = .init(type: .label, identifier: "4111 1111 1111 1111")

			/// Card number with secured revealed data.
			static let cardNumberWithSecureRange: VGSUITestElement = .init(type: .label, identifier: "4111 **** **** 1111")

			/// Card number with expiration date.
			static let expirationDate: VGSUITestElement = .init(type: .label, identifier: "10/2025")
		}

		enum PlaceholderLabels {
			/// Card number placeholder label.
			static let cardHolderName: VGSUITestElement = .init(type: .label, identifier: "XXXXXXXXXXXXXXXXXXX")

			/// Card number placeholder label.
			static let cardNumber: VGSUITestElement = .init(type: .label, identifier: "XXXX XXXX XXXX XXXX")

			/// Expiration placeholder label.
			static let expirationDate: VGSUITestElement = .init(type: .label, identifier: "XX/XX")
		}
	}

	func fillInCorrectCardData() {
		VGSTextField.cardHolderName.find(in: app).type("Joe Business")
		wait(forTimeInterval: 0.2)
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
		// Tap on show button to reveal data.
		Buttons.show.find(in: app).tap()

		// Wait some time to reveal data.
		wait(forTimeInterval: 3)
	}

	func tapToCopyCardNumber() {
		// Tap on copy card number button to hide secure mask.
		Buttons.copyCard.find(in: app).tap()

		// Wait to update UI.
		wait(forTimeInterval: 0.1)
	}

	/// VGSShow state.
	enum VGSShowState {

		/// No revealed data, should be placeholders only.
		case unrevealed

		/// Has revealed data, placeholders are hidden and card data should be displayed.
		case revealed
	}

	func testSecuredCardNumber(isSecured: Bool) {
		if isSecured {
			XCTAssert(Labels.MaskedLabels.cardNumberWithSecureRange.find(in: app).exists)
			XCTAssertFalse(Labels.MaskedLabels.cardNumber.find(in: app).exists)
		} else {
			XCTAssert(Labels.MaskedLabels.cardNumber.find(in: app).exists)
			XCTAssertFalse(Labels.MaskedLabels.cardNumberWithSecureRange.find(in: app).exists)
		}
	}

	func testVGSShowState(_ state: VGSShowState, isSecuredCardNumber: Bool) {
		// Verify VGS labels exist.
		XCTAssert(Labels.VGSLabels.cardHolderName.find(in: app).exists)
		XCTAssert(Labels.VGSLabels.cardNumber.find(in: app).exists)
		XCTAssert(Labels.VGSLabels.expirationDate.find(in: app).exists)

		switch state {
		case .unrevealed:
			XCTAssertFalse(Labels.MaskedLabels.cardHolderName.find(in: app).exists)
			XCTAssertFalse(Labels.MaskedLabels.cardNumber.find(in: app).exists)
			XCTAssertFalse(Labels.MaskedLabels.expirationDate.find(in: app).exists)

			// Verify VGS label have placeholders.
			XCTAssert(Labels.PlaceholderLabels.cardHolderName.find(in: app).exists)
			XCTAssert(Labels.PlaceholderLabels.cardNumber.find(in: app).exists)
			XCTAssert(Labels.PlaceholderLabels.expirationDate.find(in: app).exists)
		case .revealed:
			// Verify VGS masked labels are on screen.
			XCTAssert(Labels.MaskedLabels.cardHolderName.find(in: app).exists)
			XCTAssert(Labels.MaskedLabels.expirationDate.find(in: app).exists)

			// Test revealed state depending on isSecureText.
			testSecuredCardNumber(isSecured: isSecuredCardNumber)

			// Verify VGS placeholders are hidden.
			XCTAssertFalse(Labels.PlaceholderLabels.cardHolderName.find(in: app).exists)
			XCTAssertFalse(Labels.PlaceholderLabels.cardNumber.find(in: app).exists)
			XCTAssertFalse(Labels.PlaceholderLabels.expirationDate.find(in: app).exists)
		}
	}
}
