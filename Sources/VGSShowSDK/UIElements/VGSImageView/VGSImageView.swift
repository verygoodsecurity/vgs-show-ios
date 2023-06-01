//
//  VGSImageView.swift
//  VGSShowSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public final class VGSImageView: UIView, VGSImageViewProtocol {
    
    // MARK: - VGSViewProtocol implementation
    /// Name that will be associated with `VGSImageView` and used as a decoding contentPath on request response with revealed data from your organization vault.
    public var contentPath: String! {
        set {
            imageViewModel.decodingContentPath = newValue
            
            let eventText = "Set content path: \(newValue ?? "*nil*")"
            logInfoEventWithText(eventText)
        }
        get {
            return model.decodingContentPath
        }
    }
    // MARK: - VGSBaseViewProtocol implementation
    /// Wrapper to support internal `VGSBaseViewProtocol`.
    internal var model: VGSViewModelProtocol {
        return imageViewModel
    }
    
    /// Show form that will be assiciated with `VGSImageView`.
    internal var vgsShow: VGSShow?
    
    // MARK: - VGSImageViewProtocol implementation
    internal var imageViewModel: VGSImageViewModelProtocol = VGSImageViewModel()
    
    /// The object that acts as the delegate of the VGSLabel.
    public weak var delegate: VGSImageViewDelegate?
    
    /// Secure image view.
    internal var maskedImageView = VGSSecureImageView(frame: .zero)
    
    /// Field content type (will be used for decoding).
    internal let fieldType: VGSShowDecodingContentMode = .image(.rawData(.base64))
    
    /// Last revealed pdf content.
    internal var revealedImageContent: VGSShowImageContent? {
        didSet {
            if let content = revealedImageContent {
                switch content {
                case .rawData(let imageData):
                    let extraData: [String: Any] = ["field" : model.viewType.analyticsName]
                    if let image = UIImage(data: imageData) {
                        maskedImageView.secureImage = image
                        let eventText = "Image has been rendered from data."
                        logInfoEventWithText(eventText)
                        delegate?.imageDidChange?(in: self)
                        
                        VGSAnalyticsClient.shared.trackEvent(.contentRendering, status: .success, extraData: extraData)
                    } else {
                        let eventText = "Image rendering did failed. Invalid image data."
                        logWarningEventWithText(eventText, severityLevel: .error)
                        delegate?.imageView?(self, didFailWithError: VGSShowError(type: .invalidPDFData))
                        
                        VGSAnalyticsClient.shared.trackEvent(.contentRendering, status: .failed, extraData: extraData)
                    }
                }
            }
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mainInitialization()
    }
}
