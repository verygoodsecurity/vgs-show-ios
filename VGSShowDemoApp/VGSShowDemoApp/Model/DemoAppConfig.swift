//
//  DemoAppConfig.swift
//  VGSShowDemoApp
//
//  Created by Eugene on 27.10.2020.
//

import Foundation
import UIKit

final class DemoAppConfig {
  
  var vaultId = "VGS_TEST_VAULT_ID"
  var path = "VGS_TEST_PATH"
  let payloadKey = "VGS_TEST_PAYLOAD_KEY"
  let payloadValue = "VGS_TEST_PAYLOAD_VALUE"
  
  var payload: [String: Any] {
    return [payloadKey: payloadValue]
  }

	var pdfFilePayload: [String: Any] = [:]

  /// Shared instance
  static let shared = DemoAppConfig()

	var collectPayload: [String: Any] = [:]
  
  private init() {
		// Setup test data for UITests only!
		setupMockedTestDataIfNeeded()
	}

	private func setupMockedTestDataIfNeeded() {
		if UIApplication.isRunningUITest {
			guard let path = Bundle.main.path(forResource: "UITestsMockedData", ofType: "plist") else {
					print("Path not found")
					return
			}

			guard let dictionary = NSDictionary(contentsOfFile: path) else {
					print("Unable to get dictionary from path")
					return
			}

			self.vaultId = dictionary["vaultID"] as? String ?? ""
			self.path =  dictionary["path"] as? String ?? ""
			self.pdfFilePayload["pdf_file"] = dictionary["pdftoken"] as? String
		}
	}
}
