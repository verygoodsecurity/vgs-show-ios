//
//  VGSShowAPIClientTests.swift
//  VGSShowSDKTests
//
import XCTest
@testable import VGSShowSDK

class APIClientTests: XCTestCase {

    var apiClient: APIClient!

    override func setUp() {
      apiClient = APIClient(tenantId: "vaultId", regionalEnvironment: "sandbox", hostname: nil, satellitePort: nil)
    }

    override func tearDown() {
      apiClient = nil
    }

    func testValidInitialization() {
        // Test that the APIClient is initialized with the correct vault URL and ID
        XCTAssertNotNil(apiClient.baseURL, "Base URL should not be nil for valid initialization.")
    }

  func testValidInitializationSetsCorrectHostURLPolicy() {
    switch apiClient.hostURLPolicy {
    case .vaultURL(let url):
      XCTAssertNotNil(url, "Host URL policy should be .vaultURL with a non-nil URL for valid initialization.")
    case .satelliteURL(let url):
      XCTAssertNil(url, "Host URL policy should be .satelliteURL with a nil URL for valid initialization with a satellite port.")
    case .invalidVaultURL:
      XCTFail("Host URL policy should not be .invalidVaultURL for valid initialization.")
    default:
      XCTFail("Host URL policy should be either .vaultURL or .satelliteURL for valid initialization.")
    }
  }
}
