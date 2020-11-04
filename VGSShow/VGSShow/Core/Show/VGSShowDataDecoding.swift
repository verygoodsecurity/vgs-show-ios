//
//  VGSShowDataDecoding.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// `VGSShow` data decoding.
public enum VGSShowDataDecoding {

	/// Fetch text content.
	case text

	/// Fetch image URL content.
	case imageURL
}

/// `VGSShowDecodedData` data type.
public enum VGSShowDecodedData {

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

/// `VGSShowDecodingConfiguration` represents model for configurating decoding options.
public struct VGSShowDecodingConfiguration {

	/// Determines path to reveal.
	public let keyPath: VGSDecodingKeyPath

	/// Decoding type.
	public let decoding: VGSShowDataDecoding

	/// Init.
	/// - Parameters:
	///   - keyPath: `VGSJSONKeyPath` object. Key to reveal.
	///   - decoding: `VGSShowDataDecoding` object. Data decoding type.
	public init(keyPath: VGSDecodingKeyPath, decoding: VGSShowDataDecoding) {
		self.keyPath = keyPath
		self.decoding = decoding
	}
}
