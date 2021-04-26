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
public final class VGSPDFView: UIView, VGSShowPdfViewProtocol {

	// MARK: - Public Vars

	/// The object that acts as the delegate of the `VGSPDFView`.
	public weak var delegate: VGSPDFViewDelegate?

  /// Pdf display mode, default is `.singlePageContinuous`.
	public var pdfDisplayMode: PDFDisplayMode = PDFDisplayMode.singlePageContinuous {
		didSet {
			maskedPdfView.displayMode = pdfDisplayMode
		}
	}

	/// PDf layout direction, either vertical or horizontal for the given display mode, default is `.vertical`.
	public var pdfDisplayDirection: PDFDisplayDirection = PDFDisplayDirection.vertical {
		didSet {
			maskedPdfView.displayDirection = pdfDisplayDirection
		}
	}

	/// A boolean value indicating whether pdf is autoscaling, default is `true`.
	public var isPdfAutoScales: Bool = true {
		didSet {
			maskedPdfView.autoScales = isPdfAutoScales
		}
	}

	/// A Boolean value determines whether the view will display the first page as a book cover (meaningful only when the document is in two-up or two-up continuous display mode).
	public var displayAsBook: Bool = true {
		didSet {
			maskedPdfView.displaysAsBook = displayAsBook
		}
	}

	/// Background color of pdf viewer. Default is `gray` with 50% opacity.
	public var pdfBackgroundColor: UIColor? {
		didSet {
			maskedPdfView.backgroundColor = pdfBackgroundColor ?? UIColor.gray.withAlphaComponent(0)
		}
	}

	/// Determines if shadows should be drawn around page borders in a pdfView, default is `true`.
	public var pageShadowsEnabled: Bool = true {
		didSet {
			if #available(iOS 12.0, *) {
				maskedPdfView.pageShadowsEnabled = pageShadowsEnabled
			} else {
				print("pageShadowsEnabled avaliable only in iOS 12.")
			}
		}
	}

	/// Name that will be associated with `VGSPDFView` and used as a decoding contentPath on request response with revealed data from your organization vault.
	public var contentPath: String! {
		set {
			pdfViewModel.decodingContentPath = newValue

			//let eventText = "Set content path: \(newValue ?? "*nil*")"
			//logInfoEventWithText(eventText)
		}
		get {
			return model.decodingContentPath
		}
	}

	public func sharePDF(from viewController: UIViewController) {
		guard let data = maskedPdfView.secureDocument?.dataRepresentation() else { return }

		let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
		viewController.present(activityController, animated: true)
	}

	// MARK: - Internal Vars

	/// PDF format. Default is `.rawData(.base64)`. Check `VGSShowPDFFormat`.
	internal var pdfFormat: VGSShowPDFFormat = .rawData(.base64) {
		didSet {
			pdfViewModel.decodingContentMode = .pdf(pdfFormat)
		}
	}

	/// View model, hodls business logic.
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
			maskedPdfView.pdfContent = revealedPdfContent
			delegate?.documentDidChange?(in: self)
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
