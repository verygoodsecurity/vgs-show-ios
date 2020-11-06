//
//  VGSShowRequestConfiguration.swift
//  VGSShow
//
//  Created by Eugene on 06.11.2020.
//

import Foundation

/// Request payloads.
public enum VGSShowRequestPayload {

	/**
	 JSON payload format.

	 - Parameters:
		- value: `JsonData` object payload.
	*/
	case json(_ value: JsonData)
}

/// Configuration for request. Can be used for complex requests configurations.
public struct VGSShowRequestConfiguration {
	/// Request path. Default is `""`.
	var path: String = ""

	/// Request method. Default is `.post`.
	var method: HTTPMethod = .post

	/// Request payload. Default is `nil`.
	var payload: VGSShowRequestPayload?

  /// Response decoding format. Default is `.json`.
	var responseFormat: VGSShowResponseDecodingFormat = .json
}
