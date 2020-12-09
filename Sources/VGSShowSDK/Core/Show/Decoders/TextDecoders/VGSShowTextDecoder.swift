//
//  VGSShowTextDecoder.swift
//  VGSShow
//
//  Created by Eugene on 27.10.2020.
//

import Foundation

final internal class VGSShowTextDecoder: VGSShowDecoderProtocol {

	func decodeJSONForContentPath(_ contentPath: String, json: VGSJSONData) -> VGSShowDecodingResult {

		guard let serializedText: String = json.valueForKeyPath(keyPath: contentPath) else {
			return .failure(VGSShowError(type: .fieldNotFound))
		}
		let textResult = VGSShowDecodedContent.text(serializedText)

		return .success(textResult)
	}
}
