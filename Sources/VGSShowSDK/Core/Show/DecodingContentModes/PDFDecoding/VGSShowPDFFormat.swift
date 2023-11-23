//
//  VGSShowPDFFormat.swift
//  VGSShowSDK

import Foundation

/// Specifies decoding mode for pdf.
internal enum VGSShowPDFFormat {

    /// Decode as raw Data (content path is ingnored).
    /// Parameter format: `VGSShowRawDataFormat`, specified raw data format.
	case rawData(_ format: VGSShowRawDataFormat)
}
