//
//  VGSImageViewDelegate.swift
//  VGSShowSDK

import Foundation

/// Delegate methods produced by `VGSImageView`.
@objc
public protocol VGSImageViewDelegate {

    /// Tells the delegate the image was displayed in view.
    /// - Parameter imageView: `VGSImageView` view in which image was changed.
    @objc optional func imageDidChange(in imageView: VGSImageView)

    /// Tells the delegate when image view encounters an error.
    /// - Parameters:
    ///     - imageView: `VGSImageView` view in which error was occurred.
    ///     - error: `VGSShowError` object, contains error information.
    @objc optional func imageView(_ imageView: VGSImageView, didFailWithError error: VGSShowError)
}
