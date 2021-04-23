//
//  VGSShowPDFContent.swift
//  VGSShowSDK
//

import Foundation

/// PDF content type.
internal enum VGSShowPDFContent {

	/**
	 Raw data to display.

	 - Parameters:
		- data: `Data` object.
	*/
	case rawData(_ data: Data)

	/**
	 URL referring to pdf content.

	 - Parameters:
		- url: `URL` object.
	*/
	case url(_ url: URL)
}
