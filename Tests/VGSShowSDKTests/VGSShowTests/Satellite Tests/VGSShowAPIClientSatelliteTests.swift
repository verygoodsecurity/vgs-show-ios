//
//  VGSShowAPIClientSatelliteTests.swift
//  FrameworkTests
//
//  Created on 22.02.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation
import XCTest
@testable import VGSShowSDK

/// Tests for API cleint and satellite configuration: verify API URL policy setup.
class VGSShowAPIClientSatelliteTests: VGSShowBaseTestCase {

	/// Valid tenant ID.
	let tenantID: String = "testID"

	/// Holds satellite test data.
	struct APISatelliteTestData {
	 let environment: String
	 let hostname: String?
	 let port: Int?
	 let url: URL
	}

	/// Set up satellite tests.
	override func setUp() {
		super.setUp()

		// Disable satellite assetions for unit tests.
		VGSShowSatelliteUtils.isAssertionsEnabled = false
	}

	/// Tear down flow.
	override func tearDown() {
		super.tearDown()

		// Enable satellite assertions.
		VGSShowSatelliteUtils.isAssertionsEnabled = true
	}

	/// Test `API` valid satellite configurations to be resolved to `.satelliteURL` policy.
	func testAPIURLPolicyValidSatellite() {
		let testData = [
			APISatelliteTestData(environment: "sandbox", hostname: "localhost", port: 9908, url: URL(string: "http://localhost:9908")!),

			APISatelliteTestData(environment: "sandbox", hostname: "192.168.0", port: 9908, url: URL(string: "http://192.168.0:9908")!),

			APISatelliteTestData(environment: "sandbox", hostname: "192.168.1.5", port: 9908, url: URL(string: "http://192.168.1.5:9908")!),

			APISatelliteTestData(environment: "sandbox", hostname: "http://192.168.1.5", port: 9908, url: URL(string: "http://192.168.1.5:9908")!)
		]

		for index in 0..<testData.count {
			let config = testData[index]

			let outputText = "index: \(index) satellite configuration with environment: \(config.environment) hostname: \(config.hostname ?? "*nil*") port: \(config.port!) should produce: \(config.url)"
			let client = APIClient(tenantId: tenantID, regionalEnvironment: config.environment, hostname: config.hostname, satellitePort: config.port)

			switch client.hostURLPolicy {
			case .satelliteURL(let url):
				XCTAssertTrue(url == config.url, outputText)
			case .invalidVaultURL:
				XCTFail("\(outputText). API policy is *invalidURL*. Should be *satelliteURL* policy!!!")
			case .customHostURL:
				XCTFail("\(outputText). API policy is *customHostURL*. Should be *satelliteURL* policy URL mode!!!")
			case .vaultURL:
				XCTFail("\(outputText). API policy is *vaultURL*. Should be *satelliteURL* policy URL mode!!!")
			}
		}
	}

	/// Test `API` invalid satellite configurations to be resolved to `.vaultURL` policy.
	func testAPIURLPolicyInValidSatellite() {
		let testData = [
			APISatelliteTestData(environment: "live", hostname: "localhost", port: 9908, url: URL(string: "https://testID.live.verygoodproxy.com")!),

			APISatelliteTestData(environment: "live-eu", hostname: "192.168.0", port: 9908, url: URL(string: "https://testID.live-eu.verygoodproxy.com")!),

			APISatelliteTestData(environment: "sandbox", hostname: nil, port: 9908, url: URL(string: "https://testID.sandbox.verygoodproxy.com")!),

			APISatelliteTestData(environment: "sandbox", hostname: nil, port: nil, url: URL(string: "https://testID.sandbox.verygoodproxy.com")!),

			APISatelliteTestData(environment: "live", hostname: "http://192.168.1.5", port: 9908, url: URL(string: "https://testID.live.verygoodproxy.com")!)
		]

		for index in 0..<testData.count {
			let config = testData[index]
			var portText = "nil"
			if let port = config.port {
				portText = "\(port)"
			}

			let outputText = "index: \(index) satellite configuration with environment: \(config.environment) hostname: \(config.hostname ?? "*nil*") port: \(portText) should produce *nil*"
			let client = APIClient(tenantId: tenantID, regionalEnvironment: config.environment, hostname: config.hostname, satellitePort: config.port)

			switch client.hostURLPolicy {
			case .vaultURL(let url):
				XCTAssertTrue(url == config.url, "outputText \(url.absoluteString) should match normal vault URL: \(config.url.absoluteString))")
			case .satelliteURL:
				XCTFail("\(outputText). API policy is *satellite*. Should be *vaultURL* policy!!!")
			case .invalidVaultURL:
				XCTFail("\(outputText). API policy is *invalidURL*. Should be *vaultURL* policy!!!")
			case .customHostURL:
				XCTFail("\(outputText). API policy is *customHostURL*. Should be *vaultURL* policy URL mode!!!")
			}
		}
	}
}
