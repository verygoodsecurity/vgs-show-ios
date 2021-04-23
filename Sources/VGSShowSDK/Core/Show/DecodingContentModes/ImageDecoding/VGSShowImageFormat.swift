//
//  VGSShowImageFormat.swift
//  VGSShowSDK
//

import Foundation

/// Specifies decoding mode for image.
internal enum VGSShowImageFormat {

	/**
	Decode image data as String URL using content path.
	*/
	case url

	/**
	Decode as raw Data.

	- Parameters:
	 - format: `VGSShowRawDataFormat`, specified raw data format.
	*/
	case rawData(_ format: VGSShowRawDataFormat)
}
