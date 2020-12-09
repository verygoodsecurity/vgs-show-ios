//
//  VGSLabelModel.swift
//  VGSShow
//
//  Created by Dima on 29.10.2020.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Protocol describing VGS Show View ViewModel
internal protocol VGSViewModelProtocol {

	/// Content path to decode.
	var decodingContentPath: String { get set }

	/// Decoding content mode.
	var decodingContentMode: VGSShowDecodingContentMode {get set}

	/// Handle decoding result.
	/// - Parameter result: `VGSShowDecodingResult` object.
	func handleDecodingResult(_ result: VGSShowDecodingResult)

  /// View, that should be managed by model
	var view: VGSBaseViewProtocol? { get set }
}

/// Protocol describing VGS Show Label ViewModel.
internal protocol VGSLabelViewModelProtocol: VGSViewModelProtocol {
	/// Value.
	var value: String? { get set }

	/// Change value completion block.
	var onValueChanged: ((String?) -> Void)? { get set }

	/// Error completion block.
	var onError: ((VGSShowError) -> Void)? { get set }
}

internal class VGSLabelModel: VGSLabelViewModelProtocol {

  weak var view: VGSBaseViewProtocol?

	var decodingContentPath: String = ""

	var decodingContentMode: VGSShowDecodingContentMode = .text

	var value: String? {
		didSet {
			onValueChanged?(value)
		}
	}

	var onValueChanged: ((String?) -> Void)?
	var onError: ((VGSShowError) -> Void)?

	func handleDecodingResult(_ result: VGSShowDecodingResult) {
		switch result {
		case .success(let content):
			switch content {
			case .text(let text):
				self.value = text
			}
		case .failure(let error):
			onError?(error)
		}
	}
}
