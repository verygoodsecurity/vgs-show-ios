//
//  ShowDemoViewController.swift
//  VGSShowDemoApp
//
//  Created by Dima on 23.10.2020.
//

import UIKit
import VGSShowSDK

class ShowDemoViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet fileprivate weak var stackView: UIStackView!
	@IBOutlet fileprivate weak var inputLabel: UILabel!
	@IBOutlet fileprivate weak var copyCardNumberButton: UIButton!
	@IBOutlet fileprivate weak var titleLabel: UILabel!

	// MARK: - Constants

	let vgsShow = VGSShow(id: DemoAppConfig.shared.vaultId, environment: .sandbox)
	let cardNumberLabel = VGSLabel()
	let expDateLabel = VGSLabel()

	var isFormattedCardNumber: Bool = true

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

    // Setup VGSLabels.
		configureUI()
		vgsShow.subscribe(cardNumberLabel)
		vgsShow.subscribe(expDateLabel)

		// Setup demo copy button UI and title.
		setupCopyButtonUI()
		setupTitleUI()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		if let dataToReveal = DemoAppConfig.shared.collectPayload.map({$0.value}) as? [String], dataToReveal.count > 0 {
			inputLabel.text = Array(dataToReveal).joined(separator: "\n\n")
		}
	}

	// MARK: - Actions

	@IBAction private func revealButtonAction(_ sender: Any) {
		loadData()
	}

	@IBAction private func copyCardAction(_ sender: UIButton) {
		if !isFormattedCardNumber {
			cardNumberLabel.copyTextToClipboard(format: .raw)
		} else {
			cardNumberLabel.copyTextToClipboard(format: .formatted)
		}
	}

	@IBAction private func switchChangeAction(_ sender: UISwitch) {
		isFormattedCardNumber = sender.isOn
	}

	// MARK: - Helpers

	private func configureUI() {
		let paddings = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
		let textColor = UIColor.white
		let borderColor = UIColor.clear
		let font = UIFont.systemFont(ofSize: 20)
		let backgroundColor = UIColor.systemBlue
		let cornerRadius: CGFloat = 0

		cardNumberLabel.textColor = textColor
		cardNumberLabel.paddings = paddings
		cardNumberLabel.borderColor = borderColor
		cardNumberLabel.font = font
		cardNumberLabel.backgroundColor = backgroundColor
		cardNumberLabel.layer.cornerRadius = cornerRadius
		cardNumberLabel.fieldName = "json.account_number2"

		// Split card number to XXXX-XXXX-XXXX-XXXX format.
		// You can use do/try/catch if you want to check errors on creating regex. To keep example short, we use just if/let statement.
		if let transformationRegex = try? VGSTransformationRegex(pattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})", template: "$1-$2-$3-$4") {
			cardNumberLabel.transformationRegex = transformationRegex
		}

		cardNumberLabel.delegate = self

		expDateLabel.textColor = textColor
		expDateLabel.paddings = paddings
		expDateLabel.borderColor = borderColor
		expDateLabel.font = font
		expDateLabel.backgroundColor = backgroundColor
		expDateLabel.layer.cornerRadius = cornerRadius
		expDateLabel.fieldName = "json.exp_date"
		expDateLabel.delegate = self

		stackView.addArrangedSubview(cardNumberLabel)
		stackView.addArrangedSubview(expDateLabel)
	}

	private func loadData() {

		vgsShow.request(path: DemoAppConfig.shared.path,
										method: .post, payload: DemoAppConfig.shared.collectPayload) { (requestResult) in

			switch requestResult {
			case .success(let code):
				self.copyCardNumberButton.isEnabled = true
				print("vgsshow success, code: \(code)")
			case .failure(let code, let error):
				print("vgsshow failed, code: \(code), error: \(error)")
			}
		}
	}

	private func setupCopyButtonUI() {
		copyCardNumberButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .disabled)
		copyCardNumberButton.setTitleColor(UIColor.white, for: .normal)
		copyCardNumberButton.isEnabled = false
		copyCardNumberButton.layer.cornerRadius = 6
		copyCardNumberButton.layer.masksToBounds = true
	}

	private func setupTitleUI() {
		if #available(iOS 11.0, *) {
			titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
		} else {
			titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		}
	}
}

// MARK: - VGSLabelDelegate

extension ShowDemoViewController: VGSLabelDelegate {
	func labelTextDidChange(_ label: VGSLabel) {
		label.backgroundColor = .black
	}

	func labelCopyTextDidFinish(_ label: VGSLabel, format: VGSLabel.CopyTextFormat) {

		if !label.isEmpty {
			var textFormat = "Formatted"
			switch format {
			case .raw:
				textFormat = "raw"
			default:
				break
			}
			UIViewController.show(message: "\(textFormat) card number is copied!", controller: self)
		}
	}
}
