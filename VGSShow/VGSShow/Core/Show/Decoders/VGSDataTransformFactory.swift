//
//  VGSDataTransformFactory.swift
//  VGSShow
//
//  Created by Eugene on 28.10.2020.
//

import Foundation

enum VGSShowSerializerResult {
	case success(_ data: VGSShowResultData)
	case failure(_ error: VGSShowError)
}

/// Interface to implement by data decoders.
protocol VGSShowDecoderProtocol {
	func decodeDataPyPath(_ path: VGSJSONKeyPath, data: Data?) -> VGSShowSerializerResult
}

final class VGSDataDecoderFactory {
	static func provideDecorder( for decoder: VGSShowDataDecoder) -> VGSShowDecoderProtocol {
		switch decoder {
		case .text:
			return VGSShowTextDecoder()

		case .imageURL:
			#warning("imageURL decoding not implemented yet")
			fatalError("not implemented")
		}
	}
}
