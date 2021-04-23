//
//  VGSSecurePDFView.swift
//  VGSShowSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(PDFKit)
import PDFKit
#endif

@available(iOS 11.0, *)
/// VGS PDF View subclass.
internal class VGSSecurePDFView: PDFView {

	/// Revealed pdf content.
	internal var pdfContent: VGSShowPDFContent? = nil {
		didSet {
			updateContent()
		}
	}

	/// Updates displayed content.
	internal func updateContent() {
		guard let content = pdfContent else {
			return
		}

		switch content {
		case .rawData(let rawData):
			secureDocument = PDFDocument(data: rawData)
		case .url(let url):
			secureDocument = PDFDocument(url: url)
		}
	}

	@available(*, deprecated, message: "Deprecated attribute.")
	override var document: PDFDocument? {
		set {
			secureDocument = newValue
		}
		get {
			return nil
		}
	}

	/// PDF document.
	internal var secureDocument: PDFDocument? {
		set {
			super.document = newValue
		}

		get {
			return super.document
		}
	}

	override var documentView: UIView? {
		return nil
	}
}
