//
//  VGSShowTextDecoder.swift
//  VGSShow
//
//  Created by Eugene on 27.10.2020.
//

import Foundation

final internal class VGSShowTextDecoder: VGSShowDecoderProtocol {

	// MARK: - VGSShowDecoderProtocol

	/// Decode data as text for specified path.
	/// - Parameters:
	///   - path: `String` object. Path for serialization.
	///   - responseFormat: `VGSResponseDecodingFormat` object. Response data decoding format.
	///   - data: `Data?` object. Raw data to serialize.
	/// - Returns: `VGSShowDecoderResult` object. `success` if object is found, failure with associated error.
	func decodeDataForKeyPath(_ path: String, responseFormat: VGSShowResponseDecodingFormat, data: Data?) -> VGSShowDecodingResult {

		switch responseFormat {
		case .json:
			let decoder = VGSShowRawDataDecoder()
			let rawDataDecodingResult = decoder.decodeRawDataToJSON(data, decodingFormat: responseFormat)

			switch rawDataDecodingResult {
			case .success(let jsonData):
				return decodeJsonDataToText(jsonData, keyPath: path)
			case .failure(let error):
				return .failure(error)
			}
		}
	}

	// MARK: - Private

	private	func decodeJsonDataToText(_ jsonData: JsonData, keyPath: String) -> VGSShowDecodingResult {

		guard let serializedText: String = jsonData.valueForKeyPath(keyPath: keyPath) else {
			return .failure(VGSShowError(type: .fieldNotFound))
		}
		let textResult = VGSShowDecodedContent.text(serializedText)

		return .success(textResult)
	}
}
