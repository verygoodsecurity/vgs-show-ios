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

/// VGSShow class provided facilities for fetching and displaying required info.
public final class VGSShow {

	/// API client.
	internal let apiClient: APIClient

	// Environment object.
	internal let environment: Environment

	/// Current tenant id.
	internal let tenantId: String

	/// Unique form identifier
	internal let formId = UUID().uuidString

  internal var bindingModels = [VGSShowElementModel]()
  
  public func bind(_ label: VGSLabel) {
    bindingModels.append(label.model)
  }
  
	// MARK: Custom HTTP Headers

	/// Set your custom HTTP headers
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
	public init(vaultId: String, environment: Environment = .sandbox) {
	  let url = Self.generateVaultURL(tenantId: vaultId, environment: environment)
	  apiClient = APIClient(baseURL: url)
	  self.tenantId = vaultId
	  self.environment = environment
	}
}
