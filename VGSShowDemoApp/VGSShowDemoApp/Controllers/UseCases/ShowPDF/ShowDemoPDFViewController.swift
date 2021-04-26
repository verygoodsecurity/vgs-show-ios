//
//  ShowDemoPDFViewController.swift
//  VGSShowDemoApp
//

import Foundation
import UIKit
import VGSShowSDK

class ShowDemoPDFViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet fileprivate weak var stackView: UIStackView!
	@IBOutlet fileprivate weak var revealButton: UIButton!
	@IBOutlet fileprivate weak var innerTitleLabel: UILabel!
	@IBOutlet fileprivate weak var innerLabel: UILabel!
	@IBOutlet fileprivate weak var shareButton: UIButton!

	// MARK: - Vars

	fileprivate let pdfView = VGSPDFView()
	fileprivate let vgsShow = VGSShow(id: DemoAppConfig.shared.vaultId, environment: .sandbox)

	let tapGestureRecognizer = UITapGestureRecognizer()

	lazy var blurEffectView: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		
		return blurEffectView
	}()
	
	fileprivate func addBlurView() {
		blurEffectView.frame = pdfView.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		pdfView.addSubview(blurEffectView)
	}
	
	fileprivate func removeBlurView() {
		blurEffectView.removeFromSuperview()
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		shareButton.isHidden = true
		setupRevealButtonUI()
		setupPdfView()

		vgsShow.subscribe(pdfView)

		if UIApplication.isRunningUITest {
			setupIdentifiers()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)

		if let dataToReveal = DemoAppConfig.shared.pdfFilePayload.map({$0.value}) as? [String], dataToReveal.count > 0 {
			innerLabel.text = Array(dataToReveal).joined(separator: "\n\n")
		}
	}

	// MARK: - Helpers

	fileprivate func setupPdfView() {
		stackView.addArrangedSubview(pdfView)
		pdfView.contentPath = "json.pdf_file"
		pdfView.delegate = self
	}

	private func setupRevealButtonUI() {
		revealButton.setTitle("REVEAL", for: .normal)
		revealButton.setTitleColor(.white, for: .normal)

		revealButton.setTitle("LOADING...", for: .disabled)
		revealButton.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .disabled)

		pdfView.addGestureRecognizer(tapGestureRecognizer)
		tapGestureRecognizer.addTarget(self, action: #selector(handleTap))
	}

	fileprivate func setupIdentifiers() {
		revealButton.accessibilityIdentifier = "VGSShowDemoApp.ShowPDFScreen.ShowButton"
		pdfView.accessibilityIdentifier = "VGSShowDemoApp.ShowPDFScreen.VGSPDFView"
		shareButton.accessibilityIdentifier = "VGSShowDemoApp.ShowPDFScreen.SharePDFButton"
	}

	// MARK: - Actions

	@objc fileprivate func handleTap() {
		removeBlurView()
	}

	@IBAction fileprivate func sharePDF(_ sender: UIButton) {
		pdfView.sharePDF(from: self)
	}

	@IBAction fileprivate func revealPdf(_ sender: UIButton) {
		revealButton.isEnabled = false

		vgsShow.request(path: "/post", method: .post, payload:  DemoAppConfig.shared.pdfFilePayload) {[weak self] result in
			switch result {
			case .success(let code):
				self?.revealButton.isEnabled = true
			case .failure(let code, let error):
				self?.revealButton.isEnabled = true
				print("vgsshow failed, code: \(code), error: \(error)")
			}
		}
	}
}

// MARK: - VGSPDFViewDelegate

extension ShowDemoPDFViewController: VGSPDFViewDelegate {
	func documentDidChange(in pdfView: VGSPDFView) {
		if self.pdfView === pdfView {
			innerTitleLabel.text = "REVEALED"
			shareButton.isHidden = false
			addBlurView()
		}
	}
}
