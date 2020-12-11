//
//  VGSRequestBodyPayload.swift
//  VGSShowSDK
//

import Foundation

/// Request payload body.
internal enum VGSRequestPayloadBody {

	/**
	 JSON payload.

	 - Parameters:
		- payload: `VGSJSONData?` object. Should be valid JSON or nil.
	*/
	case json(_ payload: VGSJSONData?)

	/// Encode payload to `Data`.
	/// - Parameters:
	///   - success: `EncodingSuccess` completion block.
	///   - failure: `EncodingFailure` completion block.
	internal func encodeToRequestBodyData() -> Result<Data?, VGSShowError> {
		switch self {
		case .json(let payload):
			guard let json = payload else {
				// No JSON to encode.
				return .success(nil)
			}

			if !JSONSerialization.isValidJSONObject(json) {
				// Cannot send request if JSON is invalid.
				let error = VGSShowError(type: .invalidJSONPayload)
				return .failure(error)
			}

			guard let data = try? JSONSerialization.data(withJSONObject: json) else {
				// Cannot send request if JSON cannot be decoded to data.
				let error = VGSShowError(type: .invalidJSONPayload)
				return .failure(error)
			}

			return .success(data)
		}
	}

	/// Additional headers for payload.
	internal var additionalHeaders: [String: String] {
		var additionalRequestHeaders = [String: String]()

		switch self {
		case .json:
			additionalRequestHeaders["Content-Type"] = "application/json"
		}

		return additionalRequestHeaders
	}

	/// Raw payload.
	internal var rawPayload: Any? {
		switch self {
		case .json(let json):
			return json
		}
	}
}
