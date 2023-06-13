//
//  VGSImageView.swift
//  VGSShowSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// An object that displays revealed image data.
public final class VGSImageView: UIView, VGSImageViewProtocol {
    
    // MARK: - Public properties
    /// Image content mode, default is `.scaleToFill`.
    public var imageContentMode: UIView.ContentMode = UIView.ContentMode.scaleToFill {
        didSet {
            baseImageView.contentMode = imageContentMode
        }
    }
    
    /// A Boolean value determines whether the view has image.
    public var hasImage: Bool {
        return baseImageView.secureImage != nil
    }
    
    // MARK: - VGSViewProtocol implementation
    /// Name that will be associated with `VGSImageView` and used as a decoding contentPath on request response with revealed data from your organization vault.
    public var contentPath: String! {
        get {
            return model.decodingContentPath
        }
        set {
            imageViewModel.decodingContentPath = newValue
            
            let eventText = "Set content path: \(newValue ?? "*nil*")"
            logInfoEventWithText(eventText)
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
    /// View model, holds business logic.
    internal var imageViewModel: VGSImageViewModelProtocol = VGSImageViewModel()
    
    /// The object that acts as the delegate of the `VGSImageView`.
    public weak var delegate: VGSImageViewDelegate?
    
    /// Secure image view.
    internal var baseImageView = VGSSecureImageView(frame: .zero)
    
    /// Last revealed image content.
    internal var revealedImageContent: VGSShowImageContent? {
        didSet {
            if let content = revealedImageContent {
                switch content {
                case .rawData(let imageData):
                    let extraData: [String: Any] = ["field": model.viewType.analyticsName]
                    if let image = UIImage(data: imageData) {
                        baseImageView.secureImage = image
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
    /// :nodoc:
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainInitialization()
    }
    
    /// :nodoc:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mainInitialization()
    }
}
