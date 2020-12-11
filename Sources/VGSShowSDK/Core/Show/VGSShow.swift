//
//  VGSShow.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// An object you use for revealing and displaying data in corresponding subscribed VGS Show SDK views.
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
  internal var subscribedViews = [VGSBaseViewProtocol]()

	/// `true` if has subscribed viewModels to reveal.
	internal var hasViewModels: Bool {
		return !subscribedViews.isEmpty
	}
  
  ///  Returns an array of view models form subscribed vgs views.
  internal var subscribedViewModels: [VGSViewModelProtocol] {
    return subscribedViews.map({return $0.model})
  }
  
  // MARK: - Get Subscribed Views
  
  /// Returns an Array of `VGSLabel` objects subscribed to specific `VGSShow` instance.
	public var subscribedLabels: [VGSLabel] {
		return subscribedViews.compactMap({return $0.model.view as? VGSLabel})
	}
  
	// MARK: - Custom HTTP Headers

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
  ///   - id: `String` object, your organization vault id.
  ///   - environment: `String` object, your organization vault environment with data region.(e.g. "live", "live-eu1", "sanbox").
  public init(id: String, environment: String) {
    let url = Self.generateVaultURL(tenantId: id, regionalEnvironment: environment)
    apiClient = APIClient(baseURL: url)
    self.tenantId = id
    self.regionalEnvironment = environment
  }
  
  /// Initialzation
  ///
  /// - Parameters:
  ///   - id: `String` object, your organization vault id.
  ///   - environment: `VGSEnvironment` object, your organization vault environment. By default `.sandbox`.
  ///   - dataRegion: `String` object, id of data storage region (e.g. "eu-123").
  public convenience init(id: String, environment: VGSEnvironment = .sandbox, dataRegion: String? = nil) {
    let env = Self.generateRegionalEnvironmentString(environment, region: dataRegion)
    self.init(id: id, environment: env)
  }
  
  // MARK: - Manage Views
  
  /// Subscribes VGSShowSDK  view to specific `VGSShow` instance.
  /// - Parameter view: `VGSViewProtocol` view to register.
  public func subscribe(_ view: VGSViewProtocol) {
    guard let vgsView = view as? VGSBaseViewProtocol else {
      return
    }
    if !subscribedViews.contains(where: { return view == $0}) {
      trackSubscribeEvent(for: view)
      subscribedViews.append(vgsView)
    }
  }

  /// Unsubcribes `VGSViewProtocol` view from specific `VGSShow` instance.
  /// - Parameter view: `VGSViewProtocol` view to unregister.
  public func unsubscribe(_ view: VGSViewProtocol) {
    trackUnsubscribeEvent(for: view)
    subscribedViews.removeAll(where: {$0 == view})
  }
  
  /// Unsubcribes all `VGSViewProtocol` views from specific `VGSShow` instance.
  public func unsubscribeAllViews() {
    subscribedViews.forEach { (view) in
      if let vgsView = view as? VGSViewProtocol {
        trackUnsubscribeEvent(for: vgsView)
      }
    }
    subscribedViews = []
  }
}
