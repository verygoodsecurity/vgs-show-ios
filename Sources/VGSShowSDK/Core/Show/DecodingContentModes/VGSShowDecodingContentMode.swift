//
//  VGSShowDecodingContentMode.swift
//  VGSShow

import Foundation

/// Specifies content mode to decode.
internal enum VGSShowDecodingContentMode {

	/// Decode as text.
	case text

    /// Decode as PDF
    /// - Parameter pdfFormat: `VGSShowPDFFormat` object, specifies pdf format.
	case pdf(_ pdfFormat: VGSShowPDFFormat)

    /// Decode as IMAGE
    /// Parameter imageFormat: `VGSShowImageFormat` object, specifies image format.
    case image(_ imageFormat: VGSShowImageFormat)
}
