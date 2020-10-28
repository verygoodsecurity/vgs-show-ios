//
//  String+Exntesions.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

internal extension String {
	var isAlphaNumeric: Bool {
		return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
	}

	var isValidJSONKeyPath: Bool {
		return !isEmpty && range(of: "[^a-zA-Z.0-9-_]", options: .regularExpression) == nil
	}
}

internal extension Optional where Wrapped == String {
	var isNilOrEmpty: Bool {
		return self?.isEmpty ?? true
	}
}
