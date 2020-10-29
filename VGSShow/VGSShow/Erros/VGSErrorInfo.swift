//
//  VGSErrorInfo.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Represent default structure of VGSError user info
internal struct VGSErrorInfo {
	let key: VGSErrorInfoKey
	let description: String
	var extraInfo = [String: Any]()

	var asDictionary: [String: Any]? {
		return ["key": key,
				NSLocalizedDescriptionKey: description,
				"extraInfo": extraInfo]
	}
}

public typealias VGSErrorInfoKey = String

/// Error key, used for errors when input data is required to be not empty but is empty or nil.
public let VGSSDKErrorDataPartiallyDecoded: VGSErrorInfoKey = "VGSSDKErrorDataPartiallyDecoded"

/// An error domain string used to produce `VGSError` from `VGSCollectSDK` -  **"vgscollect.sdk"**
public let VGSCollectSDKErrorDomain = "vgsshow.sdk"
