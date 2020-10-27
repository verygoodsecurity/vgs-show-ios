//
//  DemoAppConfig.swift
//  VGSShowDemoApp
//
//  Created by Eugene on 27.10.2020.
//

import Foundation
import VGSShow

final class DemoAppConfig {

	// MARK: - Constants

	// Use current *.env approach for demo not to commit secrets.
	// 1. Select `Schemes`.
	// 2. Tap on "New scheme".
	// 3. Select target "VGSShowDemoApp".
	// 4. Add custom scheme name - smth like `VGSShowDemoAppConfigured`.
	// 5. **Important!**  Select `VGSShowDemoAppConfigured` scheme and uncheck `shared` to gitignore your custom scheme.
	// 6. Select `VGSShowDemoAppConfigured`.
	// 7. Select arguments.
	// 8. Setup environment varialbes.
	private enum Constants {
		static let vaultId = "VGS_TEST_VAULT_ID"
		static let path = "VGS_TEST_PATH"
		static let payloadKey = "VGS_TEST_PAYLOAD_KEY"
		static let payloadValue = "VGS_TEST_PAYLOAD_VALUE"
	}

	/// Shared instance
	static let shared = DemoAppConfig()

	/// Vault id.
	let vaultId: String

	/// Payload to reveal.
	let payload: JsonData

	/// Test path:
	let path: String

	// MARK: - Initialization

	private init() {
		/// Make sure configuration is ready.
		guard let testVault = environmentStringVar(Constants.vaultId),
			let testPath = environmentStringVar(Constants.path),
			let testPayloadKey = environmentStringVar(Constants.payloadKey),
			let testPayloadValue = environmentStringVar(Constants.payloadValue) else {
				fatalError("VGS Test env is not configured")
		}

		vaultId = testVault
		path = testPath
		payload = [testPayloadKey: testPayloadValue]
	}
}
