//
//  VGSDataDecoderFactory.swift
//  VGSShow
//
//  Created by Eugene on 28.10.2020.
//

import Foundation

/// Interface to implement by data decoders.
internal protocol VGSShowJSONDecoderProtocol {
	func decodeJSONForContentPath(_ contentPath: String, json: VGSJSONData) -> VGSShowDecodingResult
}

/// `VGSDataDecoderFactory` provides decoders for specific decoding.
internal final class VGSDataDecoderFactory {
	/// Provides decoder for specific decoding.
	/// - Parameter decoder: `VGSShowDataDecoding` object. Decoding type.
	/// - Returns: Decoder object implementing `provideJSONDecorder` interface.
	internal static func provideJSONDecorder(for contentMode: VGSShowDecodingContentMode) -> VGSShowJSONDecoderProtocol? {
		switch contentMode {
		case .text:
			return VGSShowTextDecoder()
		case .pdf(let pdfFormat):
			switch pdfFormat {
			case .rawData(let rawDataFormat):
				switch rawDataFormat {
				case .base64:
					return VGSShowBase64Decoder()
				}
			}
		}
	}
}
