//
//  VGSAnalyticsClient.swift
//  VGSShow
//

import Foundation
import VGSClientSDKAnalytics
#if canImport(UIKit)
import UIKit
#endif

/// Client responsably for managing and sending VGS Show SDK analytics events.
/// Note: we track only VGSShowSDK usage and features statistics.
/// :nodoc:
public class VGSAnalyticsClient {

	internal enum Constants {
		enum Metadata {
			static let source = "show-iosSDK"
			static let medium = "vgs-show"
		}
	}

	/// Shared `VGSAnalyticsClient` instance.
	public static let shared = VGSAnalyticsClient()
  
	/// Enable or disable VGS analytics tracking.
  public var shouldCollectAnalytics: Bool = true {
    didSet {
      sharedAnalyticsManager.setIsEnabled(isEnabled: shouldCollectAnalytics)
    }
  }
  
  private let sharedAnalyticsManager = VGSSharedAnalyticsManager(
    source: Constants.Metadata.source,
    sourceVersion: osVersion,
    dependencyManager: sdkIntegration)

	private init() {}
  
  public func capture(_ form: VGSShow?, event: VGSAnalyticsEvent) {
    if let unwrappedForm = form {
      sharedAnalyticsManager.capture(vault: unwrappedForm.tenantId, environment: unwrappedForm.regionalEnvironment, formId: unwrappedForm.formId, event: event)
    }
  }

  private static var osVersion: String {
    let version = ProcessInfo.processInfo.operatingSystemVersion
    return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
  }

	private static var sdkIntegration: String {
		#if COCOAPODS
		  return "COCOAPODS"
		#elseif SWIFT_PACKAGE
      return "SPM"
		#else
      return "OTHER"
    #endif
	}
}
