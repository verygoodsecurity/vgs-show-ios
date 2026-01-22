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
    /// Controls how the revealed image is displayed within the view's bounds.
        ///
        /// Uses standard `UIView.ContentMode` values to determine scaling and positioning.
        /// Default is `.scaleToFill`.
        ///
        /// ## Common Options
        ///
        /// - `.scaleToFill`: Scales to fill bounds (may distort aspect ratio)
        /// - `.scaleAspectFit`: Scales to fit within bounds while maintaining aspect ratio
        /// - `.scaleAspectFill`: Scales to fill bounds while maintaining aspect ratio (may clip)
        /// - `.center`: Centers image without scaling
        ///
        /// ## Example
        ///
        /// ```swift
        /// avatarView.imageContentMode = .scaleAspectFill
        /// ```
    public var imageContentMode: UIView.ContentMode = UIView.ContentMode.scaleToFill {
        didSet {
            baseImageView.contentMode = imageContentMode
        }
    }

    /// A Boolean value indicating whether the view has successfully loaded an image.
        ///
        /// Use this property to check if the image view contains revealed image data.
        ///
        /// - Returns: `true` if an image has been revealed and rendered; `false` otherwise.
        ///
        /// ## Example
        ///
        /// ```swift
        /// show.request(path: "/reveal") { result in
        ///     if avatarView.hasImage {
        ///         print("Avatar loaded successfully")
        ///     } else {
        ///         print("No avatar data")
        ///     }
        /// }
        /// ```
        ///
        /// - Note: This property is safe to access and log, as it only exposes metadata.
    public var hasImage: Bool {
        return baseImageView.secureImage != nil
    }

    /// Removes the currently revealed image from the view.
        ///
        /// After calling this method, the image view returns to its empty state. A new reveal request
        /// is required to display an image again.
        ///
        /// ## Example
        ///
        /// ```swift
        /// // Clear image when navigating away
        /// override func viewWillDisappear(_ animated: Bool) {
        ///     super.viewWillDisappear(animated)
        ///     avatarView.clear()
        /// }
        /// ```
        ///
        /// - Important: This operation is irreversible. To display an image again, you must make a new reveal request.
        ///
        /// - SeeAlso: `hasImage`
    public func clear() {
        baseImageView.secureImage = nil
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
                        delegate?.imageView?(self, didFailWithError: VGSShowError(type: .invalidImageData))

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
