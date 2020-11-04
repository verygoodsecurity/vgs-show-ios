//
//  VGSShow.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// VGSShow class provides facilities for fetching and displaying required info.
public final class VGSShow {

	/// API client.
	internal let apiClient: APIClient

	// Environment object.
	internal let environment: Environment

    /// Current data region.
	internal let dataRegion: String?

	/// Current tenant id.
	internal let tenantId: String

	/// Unique form identifier.
	internal let formId = UUID().uuidString

  internal var registeredShowElementsModels = [VGSShowElementModel]()

	/// Registers `VGSLabel` view for specific `VGSShow` instance.
	/// - Parameter label: `VGSLabel` view to register.
  public func register(_ label: VGSLabel) {
    registeredShowElementsModels.append(label.model)
  }
  
	// MARK: Custom HTTP Headers

	/// Set your custom HTTP headers.
	public var customHeaders: [String: String]? {
		didSet {
			if customHeaders != oldValue {
				apiClient.customHeader = customHeaders
			}
		}
	}

	// MARK: - Initialzation

	/// Initialzation
	///
	/// - Parameters:
	///   - vaultId: your organization vault id.
	///   - environment: your organization vault environment. By default `Environment.sandbox`.
	///   - dataRegion: id of data storage region (e.g. "eu-123"). Effects ONLY `Environment.live` vaults.
	public init(vaultId: String, environment: Environment = .sandbox, dataRegion: String? = nil) {
	  let url = Self.generateVaultURL(tenantId: vaultId, environment: environment, region: dataRegion)
	  apiClient = APIClient(baseURL: url)
	  self.tenantId = vaultId
	  self.environment = environment
	  self.dataRegion = dataRegion
	}
}
