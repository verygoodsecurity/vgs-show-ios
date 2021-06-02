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

		pdfViewModel.view = self

		pdfAutoScales = true
		maskedPdfView.usePageViewController(true)
		maskedPdfView.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

	/// Log info event. Should be used for `.info` level events only.
	/// - Parameter text: `String` object, event text.
	func logInfoEventWithText(_ text: String) {
		let event = VGSLogEvent(level: .info, text: text)
		logEvent(event)
	}

	/// Log info event. Should be used for `.warning` level.
	/// - Parameter text: `String` object, event text.
	/// - Parameter severityLevel: `VGSLogEvent.SeverityLevel` object, severity level, default is `.warning`.
	func logWarningEventWithText(_ text: String, severityLevel: VGSLogEvent.SeverityLevel = .warning) {
		let event = VGSLogEvent(level: .warning, text: text, severityLevel: severityLevel)
		logEvent(event)
	}

	/// Log event.
	/// - Parameter event: `VGSLogEvent` event object.
	func logEvent(_ event: VGSLogEvent) {
		VGSLogger.shared.forwardLogEvent(event)
	}
}
