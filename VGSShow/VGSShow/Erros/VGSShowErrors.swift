//
//  VGSShowErrors.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Type of `VGSError`  and it status code.
public enum VGSErrorType: Int {
	// MARK: - Other errors

	/// When response type is not supported.
	case unexpectedResponseType = 1400

	/// When reponse data format is not supported.
	case unexpectedResponseDataFormat = 1401

	/// When response has no raw data.
	case noRawData = 1402

	/// When response cannot be decoded to json.
	case invalidJSON = 1403

	/// When response has no raw data.
	case jsonNotFound = 1404

	/// When no object found on specified path.
	case valueNotFoundInJSON = 1405

	/// When cannot decode all data.
	case dataPartiallyDecoded = 1406
}

/// An error produced by `VGSShowSDK`. Works similar to default `NSError` in iOS.
public class VGSShowError: NSError {

	/// `VGSErrorType `-  required for each `VGSError` instance.
	public let type: VGSErrorType!

	/// Code assiciated with `VGSErrorType`.
	override public var code: Int {
		return type.rawValue
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	internal required init(type: VGSErrorType, userInfo info: VGSErrorInfo? = nil) {
		self.type = type
		super.init(domain: VGSCollectSDKErrorDomain, code: type.rawValue, userInfo: info?.asDictionary)
	}
}
