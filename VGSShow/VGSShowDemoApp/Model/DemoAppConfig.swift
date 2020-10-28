//
//  DemoAppConfig.swift
//  VGSShowDemoApp
//
//  Created by Eugene on 27.10.2020.
//

import Foundation
import VGSShow

final class DemoAppConfig {
  
  let vaultId = "VGS_TEST_VAULT_ID"
  let path = "VGS_TEST_PATH"
  let payloadKey = "VGS_TEST_PAYLOAD_KEY"
  let payloadValue = "VGS_TEST_PAYLOAD_VALUE"
  
  var payload: [String: Any] {
    return [payloadKey: payloadValue]
  }
  /// Shared instance
  static let shared = DemoAppConfig()
  
  private init(){ }
}
