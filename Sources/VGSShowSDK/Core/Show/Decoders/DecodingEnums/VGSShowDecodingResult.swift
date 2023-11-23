//
//  VGSShowDecodingResult.swift
//  VGSShow

import Foundation

/// `VGSShowDecodingResult` represents result of decoding.
internal enum VGSShowDecodingResult {

    /// Success result.
    /// - Parameter content: `VGSShowResultData` object.
	case success(_ content: VGSShowDecodedContent)

    /// Failure result.
    /// - Parameter error: `VGSShowError` error.
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
