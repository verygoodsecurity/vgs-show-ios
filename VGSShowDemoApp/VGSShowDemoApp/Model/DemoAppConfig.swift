//
//  DemoAppConfig.swift
//  VGSShowDemoApp
//
//  Created by Eugene on 27.10.2020.
//

import Foundation
import UIKit

final class DemoAppConfig {
  
    var vaultId = "tnt7uybydmg"
    var path = "post"
  let payloadKey = "VGS_TEST_PAYLOAD_KEY"
  let payloadValue = "VGS_TEST_PAYLOAD_VALUE"
  
  var payload: [String: Any] {
    return [payloadKey: payloadValue]
  }

	var pdfFilePayload: [String: Any] = [:]

  /// Shared instance
  static let shared = DemoAppConfig()

	var collectPayload: [String: Any] = [:]
    
    var imageFilePayload: [String: Any] = [:]
  
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
            self.imageFilePayload["image_file"] = dictionary["imagetoken"] as? String
		}
	}
}
