//
//  VGSShowDecodingContentMode.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Specifies content mode to decode.
internal enum VGSShowDecodingContentMode {

	/// Decode as text.
	case text

	/**
	 Decode as PDF.

	 - Parameters:
		- pdfFormat: `VGSShowPDFFormat` object, specifies pdf format.
	*/
	case pdf(_ pdfFormat: VGSShowPDFFormat)
}
