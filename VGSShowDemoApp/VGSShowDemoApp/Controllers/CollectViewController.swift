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
	@IBOutlet fileprivate weak var collectButton: UIButton!

	// MARK: - Vars

	// Init VGS Collector
	var vgsCollect = VGSCollect(id: DemoAppConfig.shared.vaultId, environment: .sandbox)

	// VGS UI Elements
  var cardHolderName = VGSTextField()
	var cardNumber = VGSCardTextField()
	var expCardDate = VGSExpDateTextField()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		setupCollectButtonUI()
		setupElementsConfiguration()

		resultLabel.font = UIFont.demoAppTextOutputFont
	}

	// MARK: - Init UI

	private func setupUI() {
		titleLabel.font = UIFont.demoAppLargeTitleFont

		// Add fields.
    stackView.addArrangedSubview(cardHolderName)
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

    let cardHolderNameConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "cardHolderName")
    cardHolderNameConfiguration.type = .cardHolderName
    cardHolderNameConfiguration.isRequiredValidOnly = false
    cardHolderNameConfiguration.keyboardType = .asciiCapableNumberPad
    cardHolderName.configuration = cardHolderNameConfiguration
    cardHolderName.placeholder = "Joe Business"
    cardHolderName.textAlignment = .natural

    cardHolderName.becomeFirstResponder()
    
		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "cardNumber")
		cardConfiguration.type = .cardNumber
		cardConfiguration.isRequiredValidOnly = false
		cardConfiguration.keyboardType = .asciiCapableNumberPad
		cardNumber.configuration = cardConfiguration
		cardNumber.placeholder = "4111 1111 1111 1111"
		cardNumber.textAlignment = .natural
		cardNumber.cardIconLocation = .right

		let expDateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "expDate")
		expDateConfiguration.isRequiredValidOnly = true
		expDateConfiguration.type = .expDate

		// Default .expDate format is "##/##"
		expDateConfiguration.formatPattern = "##/####"

		// Update validation rules
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .longYear, error: VGSValidationErrorType.expDate.rawValue)
		])

    expCardDate.isSecureTextEntry = false
		expCardDate.configuration = expDateConfiguration
		expCardDate.placeholder = "MM/YYYY"
		expCardDate.monthPickerFormat = .longSymbols

		vgsCollect.textFields.forEach { textField in
			textField.textColor = UIColor.inputBlackTextColor
			textField.font = .systemFont(ofSize: 22)
			textField.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
			textField.tintColor = .lightGray
		}
	}

	private func setupCollectButtonUI() {
		collectButton.setTitle("Collect", for: .normal)
		collectButton.setTitleColor(.white, for: .normal)

		collectButton.setTitle("Loading...", for: .disabled)
		collectButton.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .disabled)
	}

	// MARK: - Actions

	@IBAction func uploadButtonAction(_ sender: Any) {
		// hide kayboard
		hideKeyboard()

		// send extra data
		var extraData = [String: Any]()
		extraData["customKey"] = "Custom Value"

		collectButton.isEnabled = false

		// New sendRequest func
		vgsCollect.sendData(path: "/post", extraData: extraData) { [weak self](response) in

			self?.collectButton.isEnabled = true
			switch response {
			case .success(_, let data, _):
				if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

					print("SUCCESS: \(jsonData)")
					if let aliases = jsonData["json"] as? [String: Any],
						let cardNumber = aliases["cardNumber"],
            let expDate = aliases["expDate"],
            let cardHolderName = aliases["cardHolderName"] {
          
						self?.resultLabel.text =  """
						card_namber: \(cardNumber)\n
						expiration_date: \(expDate)
						"""
            let payload = ["payment_card_holder_name": cardHolderName,
                          "payment_card_number": cardNumber,
													 "payment_card_expiration_date": expDate]

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
