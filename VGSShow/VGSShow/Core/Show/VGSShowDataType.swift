//
//  VGSShowDataType.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// `VGSShow` content mode.
public enum VGSShowDataType {

	/// Fetch text content.
	case text

	/// Fetch image URL content.
	case imageURL
}

/// `VGSShowResult` data type
public enum VGSShowResultData {

	/**
	 Text result data.

	 - Parameters:
		- text: `String` object.
	*/
	case text(_ text: String)

	/**
	 Image result data.

	 - Parameters:
		- url: `URL` object.
	*/
	case imageURL(_ url: URL)
}
