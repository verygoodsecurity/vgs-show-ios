//
//  VGSLabelModel.swift
//  VGSShow
//
//  Created by Dima on 29.10.2020.
//

import Foundation

/// Protocol describing VGS Show View ViewModel
internal protocol VGSShowViewModelProtocol {

	/// KeyPath to decode.
	var decodingKeyPath: String { get set }

	/// Decoding content mode.
	var decodingContentMode: VGSShowDecodingContentMode {get set}

	/// Handle decoding result.
	/// - Parameter result: `VGSShowDecodingResult` object.
	func handleDecodingResult(_ result: VGSShowDecodingResult)
}

/// Protocol describing VGS Show Label ViewModel
internal protocol VGSLabelViewModelProtocol: VGSShowViewModelProtocol {
	var value: String? { get set }
	var onValueChanged: ((String?) -> Void)? { get set }
}

internal class VGSLabelModel: VGSLabelViewModelProtocol {

	var decodingKeyPath: String = ""

	var decodingContentMode: VGSShowDecodingContentMode = .text

	var value: String? {
		didSet {
			onValueChanged?(value)
		}
	}

	var onValueChanged: ((String?) -> Void)?

	func handleDecodingResult(_ result: VGSShowDecodingResult) {
		switch result {
		case .success(let content):
			switch content {
			case .text(let text):
				self.value = text
			default:
				#warning("not supported data format")
			}
		case .failure(let error):
			break
		}
	}
}
