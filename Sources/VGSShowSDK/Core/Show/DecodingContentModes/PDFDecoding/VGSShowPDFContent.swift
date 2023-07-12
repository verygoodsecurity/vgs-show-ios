//
//  VGSShowPDFContent.swift
//  VGSShowSDK

import Foundation

/// PDF content type.
internal enum VGSShowPDFContent {

    /// Raw data to display
    /// Parameter data: `Data` object.
	case rawData(_ data: Data)
}
