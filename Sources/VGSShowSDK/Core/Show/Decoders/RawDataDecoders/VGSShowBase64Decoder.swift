//
//  VGSShowBase64Decoder.swift
//  VGSShowSDK
//

import Foundation

/// Decodes to base64 data.
final internal class VGSShowBase64Decoder: VGSShowJSONDecoderProtocol {

	func decodeJSONForContentPath(_ contentPath: String, json: VGSJSONData) -> VGSShowDecodingResult {

		guard let endodedDataBase64: String = json.valueForKeyPath(keyPath: contentPath) else {
			return .failure(VGSShowError(type: .fieldNotFound))
		}

		guard let data = Data(base64Encoded: endodedDataBase64) else {
			// Add base64 error!
			return .failure(VGSShowError(type: .invalidJSONPayload))
		}

		let rawDataResult = VGSShowDecodedContent.rawData(data)

		return .success(rawDataResult)
	}
}
