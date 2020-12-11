//
//  VGSShowRawDataDecoder.swift
//  VGSShow
//
//  Created by Eugene on 04.11.2020.
//

import Foundation

internal enum VGSShowRawDataDecodingOutput {
	case success(_ data: VGSJSONData)
	case failure(_ error: VGSShowError)
}

internal protocol VGSShowRawDataDecodable {
	func decodeRawDataToJSON(_ data: Data?) -> VGSShowRawDataDecodingOutput
}

internal final class VGSShowRawDataDecoder: VGSShowRawDataDecodable {
	func decodeRawDataToJSON(_ data: Data?) -> VGSShowRawDataDecodingOutput {

		guard let rawData = data else {
			return .failure(VGSShowError(type: .unexpectedResponseDataFormat))
		}

		guard let jsonData = try? JSONSerialization.jsonObject(with: rawData, options: []) as? VGSJSONData else {
			return .failure(VGSShowError(type: .responseIsInvalidJSON))
		}

		return .success(jsonData)
	}
}
