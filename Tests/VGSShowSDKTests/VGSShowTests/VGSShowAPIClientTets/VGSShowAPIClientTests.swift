//
//  VGSShowAPIClientTests.swift
//  VGSShowSDKTests
//
import XCTest
@testable import VGSShowSDK

class APIClientTests: XCTestCase {

    var apiClient: APIClient!

    override func setUp() {
        super.setUp()
        let client: APIClient = MainActor.assumeIsolated {
                    APIClient(tenantId: "vaultId", regionalEnvironment: "sandbox", hostname: nil)
                }
                apiClient = client
        }

    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    @MainActor
    func testValidInitialization() {
        // Test that the APIClient is initialized with the correct vault URL and ID
        XCTAssertNotNil(apiClient.baseURL, "Base URL should not be nil for valid initialization.")
    }
    
    @MainActor
  func testValidInitializationSetsCorrectHostURLPolicy() {
    switch apiClient.hostURLPolicy {
    case .vaultURL(let url):
      XCTAssertNotNil(url, "Host URL policy should be .vaultURL with a non-nil URL for valid initialization.")
    case .invalidVaultURL:
      XCTFail("Host URL policy should not be .invalidVaultURL for valid initialization.")
    default:
      XCTFail("Host URL policy should be either .vaultURL or .satelliteURL for valid initialization.")
    }
  }
}
