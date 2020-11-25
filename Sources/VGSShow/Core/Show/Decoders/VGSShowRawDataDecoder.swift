//
//  VGSShowRawDataDecoder.swift
//  VGSShow
//
//  Created by Eugene on 04.11.2020.
//

import Foundation

internal enum VGSShowRawDataDecodingOutput {
	case success(_ data: JsonData)
	case failure(_ error: VGSShowError)
}

internal protocol VGSShowRawDataDecodable {
	func decodeRawDataToJSON(_ data: Data?, decodingFormat: VGSShowResponseDecodingFormat) -> VGSShowRawDataDecodingOutput
}

internal final class VGSShowRawDataDecoder: VGSShowRawDataDecodable {
	func decodeRawDataToJSON(_ data: Data?, decodingFormat: VGSShowResponseDecodingFormat) -> VGSShowRawDataDecodingOutput {

		guard let rawData = data else {
			return .failure(VGSShowError(type: .unexpectedResponseDataFormat))
		}

		switch decodingFormat {

		case .json:
			guard let jsonData = try? JSONSerialization.jsonObject(with: rawData, options: []) as? JsonData else {
				return .failure(VGSShowError(type: .invalidJSON))
			}

			return .success(jsonData)
		}
	}
}
