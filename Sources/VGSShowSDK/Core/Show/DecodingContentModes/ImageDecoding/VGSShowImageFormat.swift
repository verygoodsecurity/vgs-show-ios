//
//  VGSImageFormat.swift
//  VGSShowSDK

import Foundation

/// Specifies decoding mode for image.
internal enum VGSShowImageFormat {
    
    /// Decode as raw Data (content path is ingnored).
    /// - Parameter format: `VGSShowRawDataFormat`, specified raw data format.
    case rawData(_ format: VGSShowRawDataFormat)
}
