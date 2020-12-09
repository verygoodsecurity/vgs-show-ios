//
//  VGSShowDecodedContent.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Decoded content type.
internal enum VGSShowDecodedContent {

	/**
	 Text content.

	 - Parameters:
		- text: `String` object.
	*/
	case text(_ text: String)
}

/// `VGSShowDecodingConfiguration` represents model for configurating decoding options.
internal struct VGSShowDecodingConfiguration {

	/// Determines path to reveal.
	internal let keyPath: String

	/// Decoding mode.
	internal let decoding: VGSShowDecodingContentMode

	/// Init.
	/// - Parameters:
	///   - keyPath: `String` object. Key to reveal.
	///   - decoding: `VGSShowDecodingContentMode` object. Data decoding type.
	internal init(keyPath: String, decoding: VGSShowDecodingContentMode) {
		self.keyPath = keyPath
		self.decoding = decoding
	}
}
