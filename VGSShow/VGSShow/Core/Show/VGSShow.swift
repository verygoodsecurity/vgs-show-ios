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

	/// Environment string with region param.
  internal let regionalEnvironment: String

	/// Current tenant id.
	internal let tenantId: String

	/// Unique form identifier.
	internal let formId = UUID().uuidString

  /// Array of subsribed view models
  internal var subscribedViewModels = [VGSShowViewModelProtocol]()

	/// `true` if has subscribed viewModels to reveal.
	internal var hasViewModels: Bool {
		return !subscribedViewModels.isEmpty
	}
  
  /// Registers `VGSLabel` view for specific `VGSShow` instance.
  /// - Parameter label: `VGSLabel` view to register.
  public func subscribe(_ label: VGSLabel) {
    subscribedViewModels.append(label.model)
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
  ///   - id: your organization vault id.
  ///   - environment: your organization vault environment with data region.(e.g. "live", "live-eu1", "sanbox").
  public init(id: String, environment: String) {
    let url = Self.generateVaultURL(tenantId: id, regionalEnvironment: environment)
    apiClient = APIClient(baseURL: url)
    self.tenantId = id
    self.regionalEnvironment = environment
  }
  
  /// Initialzation
  ///
  /// - Parameters:
  ///   - id: your organization vault id.
  ///   - environment: your organization vault environment. By default `Environment.sandbox`.
  ///   - dataRegion: id of data storage region (e.g. "eu-123").
  public convenience init(id: String, environment: Environment = .sandbox, dataRegion: String? = nil) {
    let env = Self.generateRegionalEnvironmentString(environment, region: dataRegion)
    self.init(id: id, environment: env)
  }
}
