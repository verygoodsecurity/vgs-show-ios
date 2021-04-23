//
//  VGSPDFView+Internal.swift
//  VGSShowSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

@available(iOS 11.0, *)
internal extension VGSPDFView {

	/// Basic initialization & view setup.
	func mainInitialization() {
		// add UI elements
		buildUI()

		pdfViewModel.onValueChanged = { [weak self] (pdfContent) in
			self?.revealedPdfContent = pdfContent
		}

		pdfViewModel.onError = {[weak self] (error) in
			guard let strongSelf = self else {return}
			strongSelf.delegate?.pdfView?(strongSelf, didFailWithError: error)
		}

		//maskedPdfView.placeholderImage = placeholder
	}

	/// Setup subviews.
	func buildUI() {
		maskedPdfView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(maskedPdfView)
		maskedPdfView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		maskedPdfView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		maskedPdfView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		maskedPdfView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
}
