//
//  VGSShowErrors.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Type of `VGSError` and it status code.
public enum VGSErrorType: Int {

	/// When response type is not supported.
	case unexpectedResponseType = 1400

	/// When reponse data format is not supported.
	case unexpectedResponseDataFormat = 1401

	/// When response cannot be decoded to json.
	case responseIsInvalidJSON = 1402

	/// When field cannot be found in specified path.
	case fieldNotFound = 1403

	/// When payload is invalid JSON.
	case invalidJSONPayload = 1404

	/// When VGS config URL is not valid.
	case invalidConfigurationURL = 1480

	var message: String {

		switch self {
		case .unexpectedResponseType:
			return "Unexpected response type"
		case .unexpectedResponseDataFormat:
			return "Unexpected Response Data Format"
		case .responseIsInvalidJSON:
			return "URL error: not valid organization parameters"
		case .fieldNotFound:
			return "Field not found in specified path"
		case .invalidJSONPayload:
			return "Payload is not valid JSON"
		case .invalidConfigurationURL:
			return "VGS configuration URL is not valid"
		}
	}

	var errorKey: String {
		switch self {
		case .unexpectedResponseType:
			return "VGSSDKErrorUnexpectedResponseType"
		case .unexpectedResponseDataFormat:
			return "VGSSDKErrorUnexpectedResponseDataFormat"
		case .responseIsInvalidJSON:
			return "VGSSDKErrorResponseIsInvalidJSON"
		case .fieldNotFound:
			return "VGSSDKErrorFieldNotFound"
		case .invalidJSONPayload:
			return "VGSSDKErrorInvalidJSONPayload"
		case .invalidConfigurationURL:
			return "VGSSDKErrorInvalidConfigurationURL"
		}
	}
}

/// An error produced by `VGSShowSDK`. Works similar to default `NSError` in iOS.
public class VGSShowError: NSError {

	/// `VGSErrorType `-  required for each `VGSError` instance.
	public let type: VGSErrorType!

	/// Code assiciated with `VGSErrorType`.
	override public var code: Int {
		return type.rawValue
	}

	///:nodoc:
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	internal required init(type: VGSErrorType, userInfo info: VGSErrorInfo? = nil) {
		self.type = type

		var userInfo = info
		if userInfo == nil {
			// Add default error info.
			userInfo = VGSErrorInfo(key: type.errorKey, description: type.message)
		}
		super.init(domain: VGSShowSDKErrorDomain, code: type.rawValue, userInfo: userInfo?.asDictionary)
	}
}
