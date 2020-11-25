//
//  VGSShowDecodingResult.swift
//  VGSShow
//
//  Created by Eugene on 25.11.2020.
//

import Foundation

/// `VGSShowDecodingResult` represents result of decoding.
internal enum VGSShowDecodingResult {
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

	/// Decoding error.
	var error: VGSShowError? {
		switch self {
		case .failure(let error):
			return error
		default:
			return nil
		}
	}
}
