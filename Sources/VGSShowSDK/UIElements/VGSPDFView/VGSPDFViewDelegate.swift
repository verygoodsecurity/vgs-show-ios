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

    /// Notifies the delegate that a PDF document has been successfully decoded and rendered.
    ///
    /// This method is called immediately after the PDF view successfully decodes base64 PDF data
    /// and displays the document. Use this callback to hide loading indicators, enable navigation
    /// controls, display page counts, or log success events.
    ///
    /// - Parameter pdfView: The `VGSPDFView` instance that rendered the document.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func documentDidChange(in pdfView: VGSPDFView) {
    ///     loadingSpinner.stopAnimating()
    ///     navigationControls.isHidden = false
    ///
    ///     if let document = pdfView.document {
    ///         pageCountLabel.text = "Pages: \(document.pageCount)"
    ///     }
    ///     print("PDF document rendered successfully")
    /// }
    /// ```
    ///
    /// - Note: After this callback, `pdfView.hasDocument` returns `true`.
    ///
    /// - SeeAlso: `pdfView(_:didFailWithError:)`
    @objc optional func documentDidChange(in pdfView: VGSPDFView)

    /// Notifies the delegate that the PDF reveal operation failed for this PDF view.
    ///
    /// This method is called when the SDK cannot decode or render PDF data, even if the overall
    /// reveal request succeeded. Common causes include corrupted base64 data, invalid PDF format,
    /// or missing field in the response JSON.
    ///
    /// - Parameters:
    ///   - pdfView: The `VGSPDFView` instance that failed to render.
    ///   - error: A `VGSShowError` object describing the failure.
    ///
    /// ## Common Error Types
    ///
    /// - `.fieldNotFound`: The `contentPath` doesn't exist in the response JSON
    /// - `.invalidPDFData`: Data cannot be decoded as a valid PDF document
    /// - `.invalidBase64Data`: Base64 decoding failed
    ///
    /// ## Example
    ///
    /// ```swift
    /// func pdfView(_ pdfView: VGSPDFView, didFailWithError error: VGSShowError) {
    ///     loadingSpinner.stopAnimating()
    ///
    ///     switch error.type {
    ///     case .fieldNotFound:
    ///         errorLabel.text = "Document not available"
    ///         print("PDF field '\(pdfView.contentPath ?? "")' not found")
    ///     case .invalidPDFData:
    ///         errorLabel.text = "Invalid document format"
    ///         print("PDF data is corrupted or not a valid PDF")
    ///     case .invalidBase64Data:
    ///         errorLabel.text = "Corrupted data"
    ///         print("Failed to decode base64 PDF data")
    ///     default:
    ///         errorLabel.text = "Failed to load document"
    ///         print("PDF reveal failed: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    ///
    /// - Important: This is a per-PDF error. Other subscribed views may have succeeded. Check the overall
    ///              `VGSShowRequestResult` completion handler to determine request-level success.
    ///
    /// - SeeAlso: `VGSShowError`, `VGSErrorType`, `documentDidChange(in:)`
    @objc optional func pdfView(_ pdfView: VGSPDFView, didFailWithError error: VGSShowError)
}
