//
//  VGSShowDataDecoder.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// `VGSShow` data decoder.
public enum VGSShowDataDecoder {

	/// Fetch text content.
	case text

	/// Fetch image URL content.
	case imageURL
}

/// `VGSShowResult` data type
public enum VGSShowResultData {

	/**
	 Text result data.

	 - Parameters:
		- text: `String` object.
	*/
	case text(_ text: String)

	/**
	 Image result data.

	 - Parameters:
		- url: `URL` object.
	*/
	case imageURL(_ url: URL)
}

public struct VGSShowRevealModel {
	public let jsonKeyPath: VGSJSONKeyPath
	public let decoder: VGSShowDataDecoder

	/// Init.
	/// - Parameters:
	///   - jsonKeyPath: `VGSJSONKeyPath` object. Key to reveal.
	///   - trasformPolicy: `VGSShowDataTransformPolicy` object. Data transform policy.
	public init(jsonKeyPath: VGSJSONKeyPath, decoder: VGSShowDataDecoder) {
		self.jsonKeyPath = jsonKeyPath
		self.decoder = decoder
	}
}
