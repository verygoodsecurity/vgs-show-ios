//
//  VGSDataDecoderFactory.swift
//  VGSShow
//
//  Created by Eugene on 28.10.2020.
//

import Foundation

/// Interface to implement by data decoders.
internal protocol VGSShowDecoderProtocol {
	func decodeDataForKeyPath(_ path: String, responseFormat: VGSShowResponseDecodingFormat, data: Data?) -> VGSShowDecodingResult
}

/// `VGSDataDecoderFactory` provides decoders for specific decoding.
internal final class VGSDataDecoderFactory {
	/// Provides decoder for specific decoding.
	/// - Parameter decoder: `VGSShowDataDecoding` object. Decoding type.
	/// - Returns: Decoder object implementing `VGSShowDecoderProtocol` interface.
	static func provideDecorder( for decoder: VGSShowDecodingContentMode) -> VGSShowDecoderProtocol {
		switch decoder {
		case .text:
			return VGSShowTextDecoder()

		case .imageURL:
			#warning("imageURL decoding not implemented yet")
			fatalError("not implemented")
		}
	}
}
