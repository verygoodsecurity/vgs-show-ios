//
//  VGSPDFViewDelegate.swift
//  VGSShowSDK
//

import Foundation

/// Delegate methods produced by `VGSPDFView`.
@available(iOS 11.0, *)
@objc
@MainActor
public protocol VGSPDFViewDelegate {

	/// Tells the delegate the document was displayed in view.
	/// - Parameter pdfView: `VGSPDFView` view in which document was changed.
	/// Discussion.
	/// A pdf view sends this message to its delegate just after it updated the document.
	@objc optional func documentDidChange(in pdfView: VGSPDFView)

	/// Tells the delegate when pdf view encounters an error.
	/// - Parameter pdfView: `VGSPDFView` view in which error was occurred.
	/// - Parameter error: `VGSShowError` object, contains error information.
	@objc optional func pdfView(_ pdfView: VGSPDFView, didFailWithError error: VGSShowError)
}
