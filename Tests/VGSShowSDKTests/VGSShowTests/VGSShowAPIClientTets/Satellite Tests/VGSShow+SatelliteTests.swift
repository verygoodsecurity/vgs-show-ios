//
//  VGSShow+SatelliteTests.swift
//  FrameworkTests
//
//  Created on 22.02.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation
import XCTest
@testable import VGSShowSDK

/// Test show configuration for satellite.
class VGSShowSatelliteTests: VGSShowBaseTestCase {

	/// Valid tenant ID.
	fileprivate	let tenantID: String = "testID"

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

	/// Test show init with valid satellite configuration.
	func testShowInitWithValidSatelliteConfiguration() {
		let testData = [
			APISatelliteTestData(environment: "sandbox", hostname: "localhost", port: 9908, url: URL(string: "http://localhost:9908")!),

			APISatelliteTestData(environment: "sandbox", hostname: "192.168.0", port: 9908, url: URL(string: "http://192.168.0:9908")!),

			APISatelliteTestData(environment: "sandbox", hostname: "192.168.1.5", port: 9908, url: URL(string: "http://192.168.1.5:9908")!),

			APISatelliteTestData(environment: "sandbox", hostname: "http://192.168.1.5", port: 9908, url: URL(string: "http://192.168.1.5:9908")!)
		]

		for index in 0..<testData.count {
			let config = testData[index]

			let outputText = "index: \(index) show satellite configuration with environment: \(config.environment) hostname: \(config.hostname ?? "*nil*") port: \(config.port!) should produce satellite show: \(config.url)"

			// Test init with enum.
			let show1 = VGSShow(id: tenantID, environment: .sandbox, hostname: config.hostname, satellitePort: config.port)

			let url1 = show1.apiClient.baseURL?.absoluteString ?? ""
			XCTAssertTrue(url1 == config.url.absoluteString, "\(outputText) - enum init produced: \(url1) should match \(config.url.absoluteString)")

			// Test init with String environment.
			let show2 = VGSShow(id: tenantID, environment: config.environment, hostname: config.hostname, satellitePort: config.port)

			let url2 = show2.apiClient.baseURL?.absoluteString ?? ""
			XCTAssertTrue(url2 == config.url.absoluteString, "\(outputText) - string init produced: \(url2) should match \(config.url.absoluteString)")
		}
	}

	/// Test show init with invalid satellite configuration.
	func testShowInitWithInvalidSatelliteConfiguration() {
		let testData = [
			APISatelliteTestData(environment: "live", hostname: "localhost", port: 9908, url: URL(string: "https://testID.live.verygoodproxy.com")!),

			APISatelliteTestData(environment: "live", hostname: "192.168.0", port: 9908, url: URL(string: "https://testID.live.verygoodproxy.com")!),

			APISatelliteTestData(environment: "live", hostname: nil, port: 9908, url: URL(string: "https://testID.live.verygoodproxy.com")!),

			APISatelliteTestData(environment: "live", hostname: nil, port: nil, url: URL(string: "https://testID.live.verygoodproxy.com")!),

			APISatelliteTestData(environment: "live", hostname: "http://192.168.1.5", port: 9908, url: URL(string: "https://testID.live.verygoodproxy.com")!)
		]

		for index in 0..<testData.count {
			let config = testData[index]
			var portText = "nil"
			if let port = config.port {
				portText = "\(port)"
			}

			let outputText = "index: \(index) show satellite INVALID configuration with environment: \(config.environment) hostname: \(config.hostname ?? "*nil*") port: \(portText) should produce normal vault show URL: \(config.url)"

			// Test init with enum.
			let show1 = VGSShow(id: tenantID, environment: .live, hostname: config.hostname, satellitePort: config.port)

			let url1 = show1.apiClient.baseURL?.absoluteString ?? ""
			XCTAssertTrue(url1 == config.url.absoluteString, "\(outputText) - produced: \(url1) should match normal vault URL \(config.url.absoluteString)")

			// Test init with String environment.
			let show2 = VGSShow(id: tenantID, environment: config.environment, hostname: config.hostname, satellitePort: config.port)

			let url2 = show2.apiClient.baseURL?.absoluteString ?? ""
			XCTAssertTrue(url2 == config.url.absoluteString, "\(outputText) - produced: \(url2) should match normal vault URL \(config.url.absoluteString)")
		}
	}
}
