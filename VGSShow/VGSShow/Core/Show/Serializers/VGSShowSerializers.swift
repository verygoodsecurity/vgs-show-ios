//
//  VGSShowSerializers.swift
//  VGSShow
//
//  Created by Eugene on 27.10.2020.
//

import Foundation

protocol VGSShowSerializerProtocol {
	static func serializeDataByPath(_ path: String, data: Data?, showDataType: VGSShowDataType) -> VGSShowSerializerResult
}

enum VGSShowSerializerResult {
	case success(_ data: VGSShowResultData)
	case failure(_ error: VGSShowError)
}

final class VGSShowJSONSerializer: VGSShowSerializerProtocol {

	// MARK: - VGSShowSerializerProtocol

	/// Serialize data by specified path.
	/// - Parameters:
	///   - path: `String` object. Path for serialization.
	///   - data: `Data?` object. Raw data to serialize.
	///   - showDataType: `VGSShowDataType` enum object.
	/// - Returns: `VGSShowSerializerResult` object. `success` if object is found, failure with associated error.
	static func serializeDataByPath(_ path: String, data: Data?, showDataType: VGSShowDataType) -> VGSShowSerializerResult {
		guard let rawData = data else {
			return .failure(VGSShowError(type: .noRawData))
		}

		guard let jsonData = try? JSONSerialization.jsonObject(with: rawData, options: []) as? JsonData else {
			return .failure(VGSShowError(type: .invalidJSON))
		}

		guard let json = jsonData["json"] as? JsonData else {
			return .failure(VGSShowError(type: .jsonNotFound))
		}

		guard let serializedText = json[path] as? String else {
			return .failure(VGSShowError(type: .valueNotFoundInJSON))
		}

		let textResult = VGSShowResultData.text(serializedText)

		return .success(textResult)
	}
}
