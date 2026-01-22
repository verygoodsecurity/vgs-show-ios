//
//  VGSPDFView.swift
//  VGSShowSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import PDFKit

/// An object that displays revealed pdf data.
@available(iOS 11.0, *)
@MainActor
public final class VGSPDFView: UIView, VGSShowPdfViewProtocol {

    // MARK: - Public Vars

    /// The object that acts as the delegate of the `VGSPDFView`.
    ///
    /// Set the delegate to receive callbacks when the PDF document changes or when errors occur during rendering.
    ///
    /// - SeeAlso: `VGSPDFViewDelegate`
    public weak var delegate: VGSPDFViewDelegate?

  /// The display mode for rendering PDF pages.
    ///
    /// Controls how pages are laid out in the view. Default is `.singlePageContinuous`.
    ///
    /// ## Available Modes
    ///
    /// - `.singlePage`: One page at a time
    /// - `.singlePageContinuous`: Continuous vertical scrolling (default)
    /// - `.twoUp`: Two pages side-by-side
    /// - `.twoUpContinuous`: Two-page spreads with continuous scrolling
    ///
    /// ## Example
    ///
    /// ```swift
    /// pdfView.pdfDisplayMode = .twoUpContinuous
    /// pdfView.displayAsBook = true // Show first page as cover
    /// ```
    public var pdfDisplayMode: PDFDisplayMode = PDFDisplayMode.singlePageContinuous {
        didSet {
            maskedPdfView.displayMode = pdfDisplayMode
        }
    }

    /// The scroll direction for PDF pages.
    ///
    /// Determines whether pages scroll vertically or horizontally. Default is `.vertical`.
    ///
    /// ## Available Directions
    ///
    /// - `.vertical`: Scroll vertically (default)
    /// - `.horizontal`: Scroll horizontally
    ///
    /// ## Example
    ///
    /// ```swift
    /// pdfView.pdfDisplayDirection = .horizontal
    /// ```
    public var pdfDisplayDirection: PDFDisplayDirection = PDFDisplayDirection.vertical {
        didSet {
            maskedPdfView.displayDirection = pdfDisplayDirection
        }
    }

    /// A Boolean value indicating whether PDF pages automatically scale to fit the view.
    ///
    /// When `true`, pages are scaled to fit within the view's bounds. Default is `true`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// pdfView.pdfAutoScales = true // Fit to view
    /// ```
    public var pdfAutoScales: Bool = true {
        didSet {
            maskedPdfView.autoScales = pdfAutoScales
        }
    }

    /// A Boolean value indicating whether the first page should be displayed as a book cover.
    ///
    /// Only meaningful when using `.twoUp` or `.twoUpContinuous` display modes. When `true`,
    /// the first page appears alone on the right (in LTR languages), like a book cover.
    /// Default is `false`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// pdfView.pdfDisplayMode = .twoUpContinuous
    /// pdfView.displayAsBook = true
    /// ```
    public var displayAsBook: Bool = false {
        didSet {
            maskedPdfView.displaysAsBook = displayAsBook
        }
    }

    /// The background color of the PDF viewer.
    ///
    /// Set a custom background color for the PDF viewing area. Default is transparent gray.
    ///
    /// ## Example
    ///
    /// ```swift
    /// pdfView.pdfBackgroundColor = .white
    /// ```
    public var pdfBackgroundColor: UIColor? {
        didSet {
            maskedPdfView.backgroundColor = pdfBackgroundColor ?? UIColor.gray.withAlphaComponent(0)
        }
    }

    /// A Boolean value indicating whether shadows are drawn around page borders.
    ///
    /// Default is `true`. Available on iOS 12.0 and later.
    ///
    /// ## Example
    ///
    /// ```swift
    /// if #available(iOS 12.0, *) {
    ///     pdfView.pageShadowsEnabled = false
    /// }
    /// ```
    ///
    /// - Note: This property has no effect on iOS versions earlier than 12.0.
    public var pageShadowsEnabled: Bool = true {
        didSet {
            if #available(iOS 12.0, *) {
                maskedPdfView.pageShadowsEnabled = pageShadowsEnabled
            } else {
                print("pageShadowsEnabled is avaliable only in iOS 12.")
            }
        }
    }

    /// The JSON key path used to extract revealed PDF data from the response payload.
    ///
    /// This property specifies which field from the reveal request's JSON response should populate this PDF view.
    /// The field should contain base64-encoded PDF data.
    ///
    /// - Important: Must be set to a non-empty value before making a reveal request. Empty or `nil` values
    ///              will generate warnings and the PDF view will not receive data.
    ///
    /// ## Examples
    ///
    /// ### Simple Field
    ///
    /// ```swift
    /// // JSON: { "statement": "JVBERi0xLjQKJeLjz9MK..." }
    /// pdfView.contentPath = "statement"
    /// ```
    ///
    /// ### Nested Field
    ///
    /// ```swift
    /// // JSON: { "documents": { "invoices": { "latest": "JVBERi..." } } }
    /// pdfView.contentPath = "documents.invoices.latest"
    /// ```
    ///
    /// - SeeAlso: `VGSShow.subscribe(_:)`
    public var contentPath: String! {
    get {
      return model.decodingContentPath
    }
        set {
            pdfViewModel.decodingContentPath = newValue

            let eventText = "Set content path: \(newValue ?? "*nil*")"
            logInfoEventWithText(eventText)
        }
    }

    /// A Boolean value indicating whether the view has successfully loaded a PDF document.
    ///
    /// Use this property to check if the PDF view contains revealed document data.
    ///
    /// - Returns: `true` if a PDF has been revealed and rendered; `false` otherwise.
    ///
    /// ## Example
    ///
    /// ```swift
    /// show.request(path: "/reveal") { result in
    ///     if pdfView.hasDocument {
    ///         print("PDF loaded successfully")
    ///     } else {
    ///         print("No PDF data")
    ///     }
    /// }
    /// ```
    ///
    /// - Note: This property is safe to access and log, as it only exposes metadata.
    public var hasDocument: Bool {
        return maskedPdfView.secureDocument != nil
    }

    // MARK: - Internal Vars

    /// PDF format. Default is `.rawData(.base64)`. Check `VGSShowPDFFormat`.
    internal var pdfFormat: VGSShowPDFFormat = .rawData(.base64) {
        didSet {
            pdfViewModel.decodingContentMode = .pdf(pdfFormat)
        }
    }

    /// View model, holds business logic.
    internal var pdfViewModel: VGSShowPdfViewModelProtocol = VGSShowPdfViewModel()

    /// Wrapper to support internal `VGSBaseViewProtocol`.
    internal var model: VGSViewModelProtocol {
        return pdfViewModel
    }

    /// Field content type (will be used for decoding).
    internal let fieldType: VGSShowDecodingContentMode = .pdf(.rawData(.base64))

    /// Show form that will be assiciated with `VGSPDFView`.
    internal weak var vgsShow: VGSShow?

    /// Last revealed pdf content.
    internal var revealedPdfContent: VGSShowPDFContent? {
        didSet {
            if let content = revealedPdfContent {
                switch content {
                case .rawData(let pdfData):
                    let extraData: [String: Any] = ["field": model.viewType.analyticsName]
                    if let document = PDFDocument(data: pdfData) {
                        maskedPdfView.secureDocument = document
                        // maskedPdfView.secureDocument = PDFDocument(url: URL(string: ""))
                        let eventText = "PDF has been rendered from data."
                        logInfoEventWithText(eventText)
                        delegate?.documentDidChange?(in: self)

                        VGSAnalyticsClient.shared.trackEvent(.contentRendering, status: .success, extraData: extraData)
                    } else {
                        let eventText = "PDF rendering did failed. Invalid PDF data."
                        logWarningEventWithText(eventText, severityLevel: .error)
                        delegate?.pdfView?(self, didFailWithError: VGSShowError(type: .invalidPDFData))

                        VGSAnalyticsClient.shared.trackEvent(.contentRendering, status: .failed, extraData: extraData)
                    }
                }
            }
        }
    }

    /// Secure pdf view.
    internal var maskedPdfView = VGSSecurePDFView(frame: .zero)

    // MARK: - Initialization

    ///:nodoc:
    override init(frame: CGRect) {
            super.init(frame: frame)
            mainInitialization()
    }

    ///:nodoc:
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            mainInitialization()
    }
}
