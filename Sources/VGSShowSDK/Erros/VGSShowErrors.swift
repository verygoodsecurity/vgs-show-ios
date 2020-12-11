//
//  VGSShowErrors.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Type of `VGSError` and it status code.
public enum VGSErrorType: Int {
	// MARK: - Other errors

	/// When response type is not supported.
	case unexpectedResponseType = 1400

	/// When reponse data format is not supported.
	case unexpectedResponseDataFormat = 1401

	/// When response cannot be decoded to json.
	case invalidJSON = 1402

	/// When field cannot be found in specified path.
	case fieldNotFound = 1403

	/// When payload is invalid JSON.
	case invalidJSONPayload = 1404

	/// When VGS config URL is not valid.
	case invalidConfigurationURL = 1480

	var message: String {

		let text: String

		switch self {
		case .unexpectedResponseType:
			text = "Unexpected response type"
		case .unexpectedResponseDataFormat:
			text = "Unexpected Response Data Format"
		case .invalidJSON:
			text = "Response cannot be decoded to JSON"
		case .fieldNotFound:
			text = "Field not found in specified path"
		case .invalidJSONPayload:
			text = "Payload is not valid JSON"
		case .invalidConfigurationURL:
			text = "VGS configuration URL is not valid"
		}

		return text
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
		super.init(domain: VGSShowSDKErrorDomain, code: type.rawValue, userInfo: info?.asDictionary)
	}
}
