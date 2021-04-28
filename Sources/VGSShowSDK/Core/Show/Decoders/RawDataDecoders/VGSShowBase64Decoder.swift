//
//  VGSShowBase64Decoder.swift
//  VGSShowSDK
//

import Foundation

/// Decodes to base64 data.
final internal class VGSShowBase64Decoder: VGSShowJSONDecoderProtocol {

	// MARK: - VGSShowJSONDecoderProtocol

	func decodeJSONForContentPath(_ contentPath: String, json: VGSJSONData) -> VGSShowDecodingResult {

		guard let encodedDataBase64: String = json.valueForKeyPath(keyPath: contentPath) else {
			return .failure(VGSShowError(type: .fieldNotFound))
		}

		guard let data = Data(base64Encoded: encodedDataBase64) else {
			return .failure(VGSShowError(type: .invalidBase64Payload))
		}

		let rawDataResult = VGSShowDecodedContent.rawData(data)

		return .success(rawDataResult)
	}
}
