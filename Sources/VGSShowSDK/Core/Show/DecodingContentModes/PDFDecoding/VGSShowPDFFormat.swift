//
//  VGSShowPDFFormat.swift
//  VGSShowSDK

import Foundation

/// Specifies decoding mode for pdf.
internal enum VGSShowPDFFormat {

//	/**
//	Decode pdf data as String URL using content path.
//	*/
//	case url

	/**
	Decode as raw Data (content path is ingnored).

	- Parameters:
	 - format: `VGSShowImageRawDataFormat`, specified raw data format.
	*/
	case rawData(_ format: VGSShowRawDataFormat)
}

/// Raw data format.
internal enum VGSShowRawDataFormat {

	/// Decode base64 data.
	case base64
}
