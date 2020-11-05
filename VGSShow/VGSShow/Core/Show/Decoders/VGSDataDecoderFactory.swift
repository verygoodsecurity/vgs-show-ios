//
//  VGSDataDecoderFactory.swift
//  VGSShow
//
//  Created by Eugene on 28.10.2020.
//

import Foundation

/// `VGSShowDecodingResult` represents result of decoding.
enum VGSShowDecodingResult {
	/**
	 Success result.

	 - Parameters:
		- content: `VGSShowResultData` object.
	*/
	case success(_ content: VGSShowDecodedContent)

	/**
	 Failure result.

	 - Parameters:
		- error: `VGSShowError` error.
	*/
	case failure(_ error: VGSShowError)
}

/// Interface to implement by data decoders.
protocol VGSShowDecoderProtocol {
	func decodeDataPyPath(_ path: String, responseFormat: VGSShowResponseDecodingFormat, data: Data?) -> VGSShowDecodingResult
}

/// `VGSDataDecoderFactory` provides decoders for specific decoding.
final class VGSDataDecoderFactory {
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
