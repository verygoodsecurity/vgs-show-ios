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

	/// PDF document.
	internal var secureDocument: PDFDocument? {
		set {
			super.document = newValue
		}

		get {
			return super.document
		}
	}

	/// :nodoc:
	override public weak var delegate: PDFViewDelegate? {
			get { return nil }
			set {}
	}

	/// :nodoc:
	override public func perform(_ action: PDFAction) {}
}
