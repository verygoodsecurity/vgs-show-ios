//
//  CollectViewController.swift
//  VGSShowDemoApp
//
//  Created by Dima on 29.10.2020.
//

import Foundation
import UIKit
import VGSCollectSDK

class CollectViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet fileprivate weak var stackView: UIStackView!
	@IBOutlet fileprivate weak var resultLabel: UILabel!
	@IBOutlet fileprivate weak var titleLabel: UILabel!

	// MARK: - Vars

	// Init VGS Collector
	var vgsCollect = VGSCollect(id: DemoAppConfig.shared.vaultId, environment: .sandbox)

	// VGS UI Elements
	var cardNumber = VGSCardTextField()
	var expCardDate = VGSExpDateTextField()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		setupElementsConfiguration()
	}

	// MARK: - Init UI

	private func setupUI() {
		if #available(iOS 11.0, *) {
			titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
		} else {
			titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		}

		// Add fields.
		stackView.addArrangedSubview(cardNumber)
		stackView.addArrangedSubview(expCardDate)

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		navigationController?.navigationBar.addGestureRecognizer(tapGesture)
		view.addGestureRecognizer(tapGesture)
	}

	@objc
	func hideKeyboard() {
		view.endEditing(true)
	}

	private func setupElementsConfiguration() {

		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "account_number_1")
		cardConfiguration.type = .cardNumber
		cardConfiguration.isRequiredValidOnly = false
		cardConfiguration.keyboardType = .asciiCapableNumberPad
		cardNumber.configuration = cardConfiguration
		cardNumber.placeholder = "4111 1111 1111 1111"
		cardNumber.textAlignment = .natural
		cardNumber.cardIconLocation = .right

		cardNumber.becomeFirstResponder()

		let expDateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "exp_date_1")
		expDateConfiguration.isRequiredValidOnly = true
		expDateConfiguration.type = .expDate

		// Default .expDate format is "##/##"
		expDateConfiguration.formatPattern = "##/####"

		// Update validation rules
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .longYear, error: VGSValidationErrorType.expDate.rawValue)
		])

		expCardDate.configuration = expDateConfiguration
		expCardDate.placeholder = "MM/YYYY"
		expCardDate.monthPickerFormat = .longSymbols

		vgsCollect.textFields.forEach { textField in
			textField.textColor = .darkText
			textField.font = .systemFont(ofSize: 22)
			textField.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
			textField.tintColor = .lightGray
		}
	}

	// MARK: - Actions

	@IBAction func uploadButtonAction(_ sender: Any) {
		// hide kayboard
		hideKeyboard()

		// send extra data
		var extraData = [String: Any]()
		extraData["customKey"] = "Custom Value"

		// New sendRequest func
		vgsCollect.sendData(path: "/post", extraData: extraData) { [weak self](response) in

			switch response {
			case .success(_, let data, _):
				if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

					print("SUCCESS: \(jsonData)")
					if let aliases = jsonData["json"] as? [String: Any],
						let cardNumber = aliases["account_number_1"],
						let expDate = aliases["exp_date_1"] {

						self?.resultLabel.text =  """
						card_namber: \(cardNumber)\n
						expiration_date: \(expDate)
						"""
						let payload = ["account_number2": cardNumber,
													 "exp_date": expDate]

						DemoAppConfig.shared.collectPayload = payload
						print(payload)
					}
				}
				return
			case .failure(let code, _, _, let error):
				self?.resultLabel.text = "Error \(code)"
				switch code {
				case 400..<499:
					// Wrong request. This also can happend when your Routs not setup yet or your <vaultId> is wrong
					print("Error: Wrong Request, code: \(code)")
				case VGSErrorType.inputDataIsNotValid.rawValue:
					if let error = error as? VGSError {
						print("Error: Input data is not valid. Details:\n \(error)")
					}
				default:
					print("Error: Something went wrong. Code: \(code)")
				}
				print("Submit request error: \(code), \(String(describing: error))")
				return
			}
		}
	}
}
