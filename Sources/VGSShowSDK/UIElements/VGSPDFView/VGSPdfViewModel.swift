//
//  VGSPdfViewModel.swift
//  VGSShowSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Protocol for imageView extending VGS view protocols.
@MainActor
internal protocol VGSShowPdfViewProtocol: VGSViewProtocol, VGSBaseViewProtocol {
	var pdfViewModel: VGSShowPdfViewModelProtocol { get }
}

/// Protocol describing VGS Show Label ViewModel.
@MainActor
internal protocol VGSShowPdfViewModelProtocol: VGSViewModelProtocol {
	/// Value.
	var value: VGSShowPDFContent? { get set }

	/// Change value completion block.
	var onValueChanged: ((VGSShowPDFContent?) -> Void)? { get set }

	/// Error completion block.
	var onError: ((VGSShowError) -> Void)? { get set }
}

/// `VGSShowPdfViewModel` holds pdf view model logic.
@MainActor
internal class VGSShowPdfViewModel: VGSShowPdfViewModelProtocol {

	/// View type.
	let viewType: VGSShowViewType = .pdf

	/// Reference to binded view.
    weak var view: VGSBaseViewProtocol?

	/// Decoding path.
	var decodingContentPath: String = ""

	/// Decoding content mode.
	var decodingContentMode: VGSShowDecodingContentMode = .pdf(.rawData(.base64))

	/// Value.
	var value: VGSShowPDFContent? {
		didSet {
			onValueChanged?(value)
		}
	}

	/// Completion to call on value change.
	var onValueChanged: ((VGSShowPDFContent?) -> Void)?

	/// Completion to call on error.
	var onError: ((VGSShowError) -> Void)?

	/// Handle decoding result.
	/// - Parameter result: `VGSShowDecodingResult` object, decoding result to handle.
	func handleDecodingResult(_ result: VGSShowDecodingResult) {
		switch result {
		case .success(let content):
			switch content {
			case .rawData(let data):
				value = .rawData(data)
			default:
				assertionFailure("VGS Show error! Decode unsupported type in ImageView Model")
			}
		case .failure(let error):
			onError?(error)
		}
	}
}
