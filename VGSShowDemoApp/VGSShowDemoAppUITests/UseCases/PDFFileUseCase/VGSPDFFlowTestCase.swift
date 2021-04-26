//
//  VGSPDFFlowTestCase.swift
//  VGSShowDemoAppUITests

import Foundation
import XCTest

//class VGSPDFFlowTestCase: VGSShowDemoAppBaseTestCase {
//
//	/// Buttons.
//	enum Buttons {
//		/// Show button.
//		static let show: VGSUITestElement = .init(type: .button, identifier: "VGSShowDemoApp.ShowPDFScreen.ShowButton")
//	}
//
//	/// Labels.
//	enum Labels {
//
//		/// VGSLabel views.
//		enum VGSLabels {
//			/// Card holder VGSLabel.
//			static let cardHolderName: VGSUITestElement = .init(type: .other, identifier: "VGSShowDemoApp.ShowScreen.CardHolderNameLabel")
//
//			/// Card number VGSLabel.
//			static let cardNumber: VGSUITestElement = .init(type: .other, identifier: "VGSShowDemoApp.ShowScreen.CardNumberLabel")
//
//			/// Expiration date VGSLabel.
//			static let expirationDate: VGSUITestElement = .init(type: .other, identifier: "VGSShowDemoApp.ShowScreen.ExpirationDateLabel")
//		}
//
//		/// Masked labels.
//		enum MaskedLabels {
//			/// Card holder name with revealed data.
//			static let cardHolderName: VGSUITestElement = .init(type: .label, identifier: "Joe Business")
//
//			/// Card number with revealed data.
//			static let cardNumber: VGSUITestElement = .init(type: .label, identifier: "4111 1111 1111 1111")
//
//			/// Card number with secured revealed data.
//			static let cardNumberWithSecureRange: VGSUITestElement = .init(type: .label, identifier: "4111 **** **** 1111")
//
//			/// Card number with expiration date.
//			static let expirationDate: VGSUITestElement = .init(type: .label, identifier: "10/2025")
//		}
//
//		/// Placeholder labels.
//		enum PlaceholderLabels {
//			/// Card name holder placeholder label.
//			static let cardHolderName: VGSUITestElement = .init(type: .label, identifier: "XXXXXXXXXXXXXXXXXXX")
//
//			/// Card number placeholder label.
//			static let cardNumber: VGSUITestElement = .init(type: .label, identifier: "XXXX XXXX XXXX XXXX")
//
//			/// Expiration placeholder label.
//			static let expirationDate: VGSUITestElement = .init(type: .label, identifier: "XX/XX")
//		}
//	}
//
//	/// Tap to collect data.
//	func tapToCollectData() {
//		// Tap on collect button to send data.
//		Buttons.collect.find(in: app).tap()
//
//		// Wait some time for submit data.
//		wait(forTimeInterval: 3)
//	}
//
//	/// Tap to reveal data.
//	func tapToShowData() {
//		// Tap on show button to reveal data.
//		Buttons.show.find(in: app).tap()
//
//		// Wait some time to reveal data.
//		wait(forTimeInterval: 3)
//	}
//
//	/// VGSShow state.
//	enum VGSShowState {
//
//		/// No revealed data, should be placeholders only.
//		case unrevealed
//
//		/// Has revealed data, placeholders are hidden and card data should be displayed.
//		case revealed
//	}
//}
