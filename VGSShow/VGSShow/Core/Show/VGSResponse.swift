//
//  VGSResponse.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

public typealias VGSJSONKeyPath = String

/// Response enum cases for SDK requests
@frozen public enum VGSRequestResult {
	/**
	 Success response case

	 - Parameters:
		- code: `Int` object. response status code.
		- result: `VGSShowResultData` object.
	*/
	case success( _ code: Int, _ vgsData: [VGSJSONKeyPath : VGSShowResultData] )

	/**
	 Failed response case

	 - Parameters:
		- code: response status code.
		- error: `Error` object.
	*/
	case failure(_ code: Int, _ error: Error?)
}
