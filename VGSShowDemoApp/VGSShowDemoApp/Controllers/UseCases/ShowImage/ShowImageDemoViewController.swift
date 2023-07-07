//
//  ShowImageDemoViewController.swift
//  VGSShowDemoApp

import Foundation
import UIKit
import VGSShowSDK

class ShowImageDemoViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var revealButton: UIButton!
    @IBOutlet private weak var innerTitleLabel: UILabel!
    @IBOutlet private weak var innerLabel: UILabel!
    
    // MARK: - Properties
    private let imageView = VGSImageView()
    private let vgsShow = VGSShow(id: DemoAppConfig.shared.vaultId, environment: .sandbox)
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        innerTitleLabel.text = ""
        setupRevealButton()
        setupImageView()
        
        vgsShow.subscribe(imageView)
        
        if UIApplication.isRunningUITest {
            setupIdentifiers()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let dataToReveal = DemoAppConfig.shared.imageFilePayload.map({$0.value}) as? [String], dataToReveal.count > 0 {
            innerLabel.text = Array(dataToReveal).joined(separator: "\n\n")
        }
    }
    
    // MARK: - Actions
    @IBAction private func revealImage(_ sender: UIButton) {
        if imageView.hasImage {
            imageView.clear()
            updateRevealButton()
            innerTitleLabel.text = nil
            innerLabel.adjustsFontSizeToFitWidth = true
            removeBlurView()
        } else {
            revealButton.isEnabled = false
            
            var options = VGSShowRequestOptions()
            options.requestTimeoutInterval = 360
            
            vgsShow.request(path: "/post",
                            method: .post,
                            payload: DemoAppConfig.shared.imageFilePayload,
                            requestOptions: options) { [weak self] result in
                switch result {
                case .success(let code):
                    self?.updateRevealButton()
                    print("vgsshow success, code: \(code)")
                case .failure(let code, let error):
                    self?.updateRevealButton()
                    print("vgsshow failed, code: \(code), error: \(String(describing: error))")
                }
            }
        }
    }
    
    private func updateRevealButton() {
        revealButton.isEnabled = true
        if imageView.hasImage {
            revealButton.setTitle("CLEAR", for: .normal)
        } else {
            revealButton.setTitle("REVEAL", for: .normal)
        }
    }
    
    @objc fileprivate func handleTap() {
        removeBlurView()
    }
    
    // MARK: - Private methods
    private func setupImageView() {
        imageView.imageContentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        stackView.addArrangedSubview(imageView)
        imageView.contentPath = "json.image_file"
        imageView.delegate = self
    }
    
    private func setupRevealButton() {
        revealButton.setTitle("REVEAL", for: .normal)
        revealButton.setTitleColor(.white, for: .normal)
        
        revealButton.setTitle("LOADING...", for: .disabled)
        revealButton.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .disabled)
        
        imageView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap))
    }
    
    private func addBlurView() {
        blurEffectView.frame = imageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)
    }
    
    private func removeBlurView() {
        blurEffectView.removeFromSuperview()
    }
    
    fileprivate func setupIdentifiers() {
        revealButton.accessibilityIdentifier = "VGSShowDemoApp.ShowImageScreen.ShowButton"
        imageView.accessibilityIdentifier = "VGSShowDemoApp.ShowImageScreen.VGSImageView"
    }
}

// MARK: - VGSImageViewDelegate implementation
extension ShowImageDemoViewController: VGSImageViewDelegate {
    
    func imageDidChange(in imageView: VGSImageView) {
        if self.imageView === imageView {
            innerTitleLabel.text = "REVEALED. TAP ON VIEW TO REMOVE BLUR."
            innerLabel.adjustsFontSizeToFitWidth = true
            addBlurView()
        }
    }
    
    func imageView(_ imageView: VGSImageView, didFailWithError error: VGSShowError) {
        print(error.localizedDescription)
    }
}
