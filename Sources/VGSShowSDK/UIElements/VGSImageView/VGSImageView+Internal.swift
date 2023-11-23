//
//  VGSImageView+Internal.swift
//  VGSShowSDK

import Foundation

internal protocol VGSImageViewProtocol: VGSViewProtocol, VGSBaseViewProtocol {
    var imageViewModel: VGSImageViewModelProtocol { get }
}

internal extension VGSImageView {

    /// Basic initialization & view setup.
    func mainInitialization() {
        /// Add UI elements
        buildUI()

        /// Add listeners
        imageViewModel.onValueChanged = { [weak self] (imageContent) in
            self?.revealedImageContent = imageContent
        }

        imageViewModel.onError = { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.imageView?(strongSelf, didFailWithError: error)
        }

        // Setup image view properties
        imageViewModel.view = self
    }

    /// Setup subviews.
    func buildUI() {
        baseImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(baseImageView)
        baseImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        baseImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        baseImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        baseImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
