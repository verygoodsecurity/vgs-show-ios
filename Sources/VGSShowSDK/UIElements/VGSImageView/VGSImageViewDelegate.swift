//
//  VGSImageViewDelegate.swift
//  VGSShowSDK

import Foundation

/// Delegate methods produced by `VGSImageView`.
@objc
@MainActor
public protocol VGSImageViewDelegate {

    /// Notifies the delegate that an image has been successfully decoded and rendered.
        ///
        /// This method is called immediately after the image view successfully decodes base64 or raw image
        /// data and displays it. Use this callback to hide loading indicators, enable dependent controls,
        /// or log success events.
        ///
        /// - Parameter imageView: The `VGSImageView` instance that rendered the image.
        ///
        /// ## Example
        ///
        /// ```swift
        /// func imageDidChange(in imageView: VGSImageView) {
        ///     loadingSpinner.stopAnimating()
        ///     imageLoadedLabel.isHidden = false
        ///     print("Image rendered successfully")
        /// }
        /// ```
        ///
        /// - Note: After this callback, `imageView.hasImage` returns `true`.
        ///
        /// - SeeAlso: `imageView(_:didFailWithError:)`
    @objc optional func imageDidChange(in imageView: VGSImageView)

    /// Notifies the delegate that the image reveal operation failed for this image view.
        ///
        /// This method is called when the SDK cannot decode or render image data, even if the overall
        /// reveal request succeeded. Common causes include corrupted base64 data, invalid image format,
        /// or missing field in the response JSON.
        ///
        /// - Parameters:
        ///   - imageView: The `VGSImageView` instance that failed to render.
        ///   - error: A `VGSShowError` object describing the failure.
        ///
        /// ## Common Error Types
        ///
        /// - `.fieldNotFound`: The `contentPath` doesn't exist in the response JSON
        /// - `.invalidImageData`: Data cannot be decoded as a valid image
        /// - `.invalidBase64Data`: Base64 decoding failed
        ///
        /// ## Example
        ///
        /// ```swift
        /// func imageView(_ imageView: VGSImageView, didFailWithError error: VGSShowError) {
        ///     loadingSpinner.stopAnimating()
        ///
        ///     switch error.type {
        ///     case .fieldNotFound:
        ///         // Show default placeholder
        ///         imageView.image = UIImage(named: "placeholder")
        ///         print("Image field '\(imageView.contentPath ?? "")' not found")
        ///     case .invalidImageData:
        ///         print("Image data is corrupted or invalid format")
        ///         showErrorState()
        ///     default:
        ///         print("Image reveal failed: \(error.localizedDescription)")
        ///     }
        /// }
        /// ```
        ///
        /// - Important: This is a per-image error. Other subscribed views may have succeeded. Check the overall
        ///              `VGSShowRequestResult` completion handler to determine request-level success.
        ///
        /// - SeeAlso: `VGSShowError`, `VGSErrorType`, `imageDidChange(in:)`
    @objc optional func imageView(_ imageView: VGSImageView, didFailWithError error: VGSShowError)
}
