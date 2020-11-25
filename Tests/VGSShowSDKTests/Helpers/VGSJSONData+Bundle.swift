//
//  VGSJSONData+Extensions.swift
//  VGSShowTests
//
//  Created by Eugene on 29.10.2020.
//

import XCTest
import Foundation
@testable import VGSShowSDK

extension VGSJSONData {

	init?(jsonFileName: String, bundle: Bundle) {
		let notFoundCompletion = {
			print("JSON file \(jsonFileName).json not found or is invalid")
		}

		if let path = bundle.path(forResource: jsonFileName, ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
				guard let json = jsonResult as? VGSJSONData else {
					notFoundCompletion()
					return nil
				}

				self = json
			} catch {
				notFoundCompletion()
				return nil
			}
		} else {
			notFoundCompletion()
			return nil
		}
	}
}
