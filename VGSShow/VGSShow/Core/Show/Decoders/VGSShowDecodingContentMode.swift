//
//  VGSShowDataDecoding.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Specifies content mode to decode.
public enum VGSShowDecodingContentMode {

	/// Decode as text.
	case text

	/// Decode as image URL.
	case imageURL
}

/// Decoded content type.
internal enum VGSShowDecodedContent {

	/**
	 Text content.

	 - Parameters:
		- text: `String` object.
	*/
	case text(_ text: String)

	/**
	 Image URL content.

	 - Parameters:
		- url: `URL` object.
	*/
	case imageURL(_ url: URL)
}

/// `VGSShowDecodingConfiguration` represents model for configurating decoding options.
public struct VGSShowDecodingConfiguration {

	/// Determines path to reveal.
	public let keyPath: String

	/// Decoding mode.
	public let decoding: VGSShowDecodingContentMode

	/// Init.
	/// - Parameters:
	///   - keyPath: `String` object. Key to reveal.
	///   - decoding: `VGSShowDecodingContentMode` object. Data decoding type.
	public init(keyPath: String, decoding: VGSShowDecodingContentMode) {
		self.keyPath = keyPath
		self.decoding = decoding
	}
}
