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
	@IBOutlet fileprivate weak var titleLabel: UILabel!
	@IBOutlet fileprivate weak var showButton: UIButton!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var copyCardButton: UIButton!
  // MARK: - Constants

	let vgsShow = VGSShow(id: DemoAppConfig.shared.vaultId, environment: .sandbox)
  let cardHolderNameLabel = VGSLabel()
	let cardNumberLabel = VGSLabel()
	let expDateLabel = VGSLabel()

	var isTransformedCardNumber: Bool = true

	// MARK: - Lifecycle

	override func awakeFromNib() {
		super.awakeFromNib()

		setupAccessabilityIdentifiers()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.

    // Subscribe VGSLabels.
		vgsShow.subscribe(cardNumberLabel)
		vgsShow.subscribe(expDateLabel)
    vgsShow.subscribe(cardHolderNameLabel)
    
    // Configure UI for VGSLabels.
    configureUI()
    
		setupShowButtonUI()
		setupTitleUI()

		inputLabel.font = UIFont.demoAppTextOutputFont
    copyCardButton.isHidden = true
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
    copyCardNumber()
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
		let backgroundColor = UIColor.clear
		let cornerRadius: CGFloat = 6
		let textAlignment = NSTextAlignment.left

		let placeholderColor = UIColor.white.withAlphaComponent(0.7)

    // Secure revealed data with mask in ranges
    cardNumberLabel.isSecureText = true
    cardNumberLabel.setSecureText(ranges: [VGSTextRange(start: 5, end: 8),
                                           VGSTextRange(start: 10, end: 13)])
    
    // Set placeholder text. Placeholder will appear until revealed text will be set in VGSLabel
    cardNumberLabel.placeholder = "XXXX XXXX XXXX XXXX"
		cardNumberLabel.contentPath = "json.payment_card_number"

		// Create regex object, split card number to XXXX-XXXX-XXXX-XXXX format.
		do {
			let cardNumberPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d{4})"
			let template = "$1 $2 $3 $4"
			let regex = try NSRegularExpression(pattern: cardNumberPattern, options: [])

			// Add transformation regex to your label.
			cardNumberLabel.addTransformationRegex(regex, template: template)
		} catch {
			assertionFailure("invalid regex, error: \(error)")
		}

    expDateLabel.placeholder = "XX/XX"
    expDateLabel.contentPath = "json.payment_card_expiration_date"
    
    cardHolderNameLabel.placeholder = "XXXXXXXXXXXXXXXXXXX"
    cardHolderNameLabel.contentPath = "json.payment_card_holder_name"
    
    // Set default VGSLabel UI style
    vgsShow.subscribedLabels.forEach {
      $0.textAlignment = textAlignment
      $0.textColor = textColor
      $0.paddings = paddings
      $0.borderColor = borderColor
      $0.font = font
      $0.backgroundColor = backgroundColor
      $0.layer.cornerRadius = cornerRadius
      $0.characterSpacing = 0.83
      $0.placeholderStyle.color = placeholderColor
      $0.placeholderStyle.textAlignment = textAlignment

      // set delegate to follow the updates in VGSLabel
      $0.delegate = self
    }
    
    stackView.addArrangedSubview(cardHolderNameLabel)
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
        self.copyCardButton.isHidden = false
				print("vgsshow success, code: \(code)")
			case .failure(let code, let error):
				self.showButton.isEnabled = true
				print("vgsshow failed, code: \(code), error: \(error)")
			}
		}
	}

	private func setupShowButtonUI() {
		showButton.setTitle("SHOW", for: .normal)
		showButton.setTitleColor(.white, for: .normal)

		showButton.setTitle("LOADING...", for: .disabled)
		showButton.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .disabled)
	}

	private func setupTitleUI() {
		titleLabel.font = UIFont.demoAppLargeTitleFont
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyCardNumber))
    stackView.addGestureRecognizer(tapGesture)
	}

  @objc func copyCardNumber() {
    if !isTransformedCardNumber {
      cardNumberLabel.copyTextToClipboard(format: .raw)
    } else {
      cardNumberLabel.copyTextToClipboard(format: .transformed)
    }
  }

	// *For UITests only.
	private func setupAccessabilityIdentifiers() {
		if UIApplication.isRunningUITest {
			// Force to load view.
			enforceLoadView()
			tabBarItem.accessibilityIdentifier = "VGSShowDemoApp.TabBar.TabButton.Show"
			showButton.accessibilityIdentifier = "VGSShowDemoApp.ShowScreen.ShowButton"
			copyCardButton.accessibilityIdentifier = "VGSShowDemoApp.ShowScreen.CopyCardButton"
			cardHolderNameLabel.accessibilityIdentifier = "VGSShowDemoApp.ShowScreen.CardHolderNameLabel"
			cardNumberLabel.accessibilityIdentifier = "VGSShowDemoApp.ShowScreen.CardNumberLabel"
			expDateLabel.accessibilityIdentifier = "VGSShowDemoApp.ShowScreen.ExpirationDateLabel"
		}
	}
}

// MARK: - VGSLabelDelegate

extension ShowDemoViewController: VGSLabelDelegate {
	func labelTextDidChange(_ label: VGSLabel) {
		label.textColor = .white
	}

	func labelRevealDataDidFail(_ label: VGSLabel, error: VGSShowError) {
		// Set label text placeholder to red color on error. You can make typo in label field to simulate this error case.
		label.textColor = .red
		label.placeholderStyle.color = UIColor.red
	}

	func labelCopyTextDidFinish(_ label: VGSLabel, format: VGSLabel.CopyTextFormat) {
    cardNumberLabel.isSecureText = false
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
