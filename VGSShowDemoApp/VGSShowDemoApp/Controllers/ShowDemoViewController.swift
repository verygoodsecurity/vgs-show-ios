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
	@IBOutlet fileprivate weak var showButton: UIButton!

	// MARK: - Constants

	let vgsShow = VGSShow(id: DemoAppConfig.shared.vaultId, environment: .sandbox)
	let cardNumberLabel = VGSLabel()
	let expDateLabel = VGSLabel()

	var isTransformedCardNumber: Bool = true

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
		setupShowButtonUI()
		setupTitleUI()

		inputLabel.font = UIFont.demoAppTextOutputFont
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
		if !isTransformedCardNumber {
			cardNumberLabel.copyTextToClipboard(format: .raw)
		} else {
			cardNumberLabel.copyTextToClipboard(format: .transformed)
		}
	}

	@IBAction private func switchChangeAction(_ sender: UISwitch) {
		isTransformedCardNumber = sender.isOn
	}

	// MARK: - Helpers

	private func configureUI() {
		let paddings = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
		let textColor = UIColor.white
		let borderColor = UIColor.clear
		let font = UIFont.systemFont(ofSize: 20)
		let backgroundColor = UIColor.systemBlue
		let cornerRadius: CGFloat = 0
		let textAlignment = NSTextAlignment.center

		let placeholderColor = UIColor.white.withAlphaComponent(0.7)

//    cardNumberLabel.setSecureText()
//    cardNumberLabel.setSecureText(start: nil, end: 15)
//    cardNumberLabel.setSecureTextRanges(ranges: [VGSTextRange(start: 4, end: 15)])
//    cardNumberLabel.setSecureTextRanges(ranges: [VGSTextRange(start: 5, end: 9),
//                                                 VGSTextRange(start: 10, end: 14)])
    
		cardNumberLabel.textAlignment = textAlignment
		cardNumberLabel.textColor = textColor
		cardNumberLabel.paddings = paddings
		cardNumberLabel.borderColor = borderColor
		cardNumberLabel.font = font
		cardNumberLabel.backgroundColor = backgroundColor
		cardNumberLabel.layer.cornerRadius = cornerRadius
		cardNumberLabel.contentPath = "json.payment_card_number"

		cardNumberLabel.placeholder = "Card number"
		cardNumberLabel.placeholderStyle.color = placeholderColor
		cardNumberLabel.placeholderStyle.textAlignment = textAlignment

		// Create regex object, split card number to XXXX-XXXX-XXXX-XXXX format.
		do {
			let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"
			let template = "$1-$2-$3-$4"
			let regex = try NSRegularExpression(pattern: cardNumberPattern, options: [])

			// Add transformation regex to your label.
			cardNumberLabel.addTransformationRegex(regex, template: template)
		} catch {
			assertionFailure("invalid regex, error: \(error)")
		}

		cardNumberLabel.delegate = self

		expDateLabel.textAlignment = textAlignment
		expDateLabel.textColor = textColor
		expDateLabel.paddings = paddings
		expDateLabel.borderColor = borderColor
		expDateLabel.font = font
		expDateLabel.backgroundColor = backgroundColor
		expDateLabel.layer.cornerRadius = cornerRadius
		expDateLabel.characterSpacing = 0.83
		expDateLabel.contentPath = "json.payment_card_expiration_date"

		expDateLabel.placeholder = "Expiration date"
		expDateLabel.placeholderStyle.color = placeholderColor
		expDateLabel.placeholderStyle.textAlignment = textAlignment

		expDateLabel.delegate = self

		stackView.addArrangedSubview(cardNumberLabel)
		stackView.addArrangedSubview(expDateLabel)
	}

	private func loadData() {

		showButton.isEnabled = false
		vgsShow.request(path: DemoAppConfig.shared.path,
										method: .post, payload: DemoAppConfig.shared.collectPayload) { (requestResult) in

			switch requestResult {
			case .success(let code):
				self.showButton.isEnabled = true
				self.copyCardNumberButton.isEnabled = true
				print("vgsshow success, code: \(code)")
			case .failure(let code, let error):
				self.showButton.isEnabled = true
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

	private func setupShowButtonUI() {
		showButton.setTitle("SHOW", for: .normal)
		showButton.setTitleColor(.white, for: .normal)

		showButton.setTitle("LOADING...", for: .disabled)
		showButton.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .disabled)
	}

	private func setupTitleUI() {
		titleLabel.font = UIFont.demoAppLargeTitleFont
	}
}

// MARK: - VGSLabelDelegate

extension ShowDemoViewController: VGSLabelDelegate {
	func labelTextDidChange(_ label: VGSLabel) {
		label.backgroundColor = .black
		label.backgroundColor = .systemBlue
		label.borderColor = .clear
	}

	func labelRevealDataDidFail(_ label: VGSLabel, error: VGSShowError) {
		// Set label border to red color on error. You can make typo in label field to simulate this error case.
		label.borderColor = .systemRed
		label.backgroundColor = .systemYellow
	}

	func labelCopyTextDidFinish(_ label: VGSLabel, format: VGSLabel.CopyTextFormat) {
    cardNumberLabel.isSecureText = !cardNumberLabel.isSecureText
		if !label.isEmpty {
			var textFormat = "Transformed"
			switch format {
			case .raw:
				textFormat = "Raw"
			default:
				break
			}
			UIViewController.show(message: "\(textFormat) card number is copied!", controller: self)
		}
	}
}
