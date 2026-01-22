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

    /// When base64 data is invalid.
    case invalidBase64Data = 1405

    /// When PDF data is invalid.
    case invalidPDFData = 1406

    /// When Image data is invalid.
    case invalidImageData = 1407

    /// When VGS config URL is not valid.
    case invalidConfigurationURL = 1480

    /// Error messsage.
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
        case .invalidBase64Data:
            return "Payload is not valid base64 data"
        case .invalidPDFData:
            return "Cannot render PDF with invalid data"
        case .invalidImageData:
            return "Cannot render Image with invalid data"
        case .invalidConfigurationURL:
            return "VGS configuration URL is not valid"
        }
    }

    /// Error key.
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
        case .invalidBase64Data:
            return "VGSSDKErrorInvalidBase64Data"
        case .invalidPDFData:
            return "VGSSDKErrorInvalidPDFData"
        case .invalidImageData:
            return "VGSSDKErrorInvalidImageData"
        case .invalidConfigurationURL:
            return "VGSSDKErrorInvalidConfigurationURL"
        }
    }
}

/// An error object representing failures in VGSShow SDK operations.
///
/// `VGSShowError` extends `NSError` to provide typed error information specific to reveal operations.
/// Each error includes a `VGSErrorType` that categorizes the failure and can be used for conditional
/// error handling, logging, and user messaging.
///
/// ## Overview
///
/// Use `VGSShowError` to:
/// - Identify specific failure modes via the `type` property
/// - Access the underlying error code for logging
/// - Handle errors conditionally based on type
/// - Extract safe error descriptions for debugging
///
/// ## Properties
///
/// - `type`: The `VGSErrorType` categorizing this error
/// - `code`: The integer error code (matches `type.rawValue`)
/// - `domain`: Always `"VGSShowSDKErrorDomain"`
/// - `localizedDescription`: A human-readable error message
///
/// ## Important Notes
///
/// - Never log or display raw revealed data in error contexts
/// - Map error types to safe, user-friendly messages before showing to end users
/// - Error codes are stable across SDK versions for reliable analytics
/// - The `type` property is never `nil` in production (force-unwrap safe for error handling)
///
/// - SeeAlso: `VGSErrorType`, `VGSShowRequestResult`
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
