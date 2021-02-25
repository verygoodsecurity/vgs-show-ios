//
//  VGSAnalyticsClient.swift
//  VGSShow
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// :nodoc: VGS Analytics event type
public enum VGSAnalyticsEventType: String {
	case fieldInit = "Init"
  case beforeSubmit = "BeforeSubmit"
  case submit = "Submit"
  case copy = "Copy to clipboard click"
	case fieldUnsubscibe = "UnsubscribeField"
  case setSecureTextRange = "SetSecureTextRange"
}

/// Client responsably for managing and sending VGS Show SDK analytics events.
/// Note: we track only VGSShowSDK usage and features statistics.
/// :nodoc:
public class VGSAnalyticsClient {

	public enum AnalyticEventStatus: String {
		case success = "Ok"
		case failed = "Failed"
		case cancel = "Cancel"
		case clicked = "Clicked"
	}

	internal enum Constants {
		enum Metadata {
			static let source = "show-iosSDK"
			static let medium = "vgs-show"
		}
	}

	/// Shared `VGSAnalyticsClient` instance.
	public static let shared = VGSAnalyticsClient()

	/// Enable or disable VGS analytics tracking.
	public var shouldCollectAnalytics = true

	private init() {}

	internal let urlSession = URLSession(configuration: .ephemeral)

	internal let baseURL = "https://vgs-collect-keeper.apps.verygood.systems/"

	internal let defaultHttpHeaders: VGSHTTPHeaders = {
		return ["Content-Type": "application/x-www-form-urlencoded",
						"vgsShowSessionId": VGSShowAnalyticsSession.shared.vgsShowSessionId]
	}()

	internal static let userAgentData: [String: Any] = {
		let version = ProcessInfo.processInfo.operatingSystemVersion
		let osVersion = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
		var defaultUserAgentData = [
			"platform": UIDevice.current.systemName,
			"device": UIDevice.current.model,
			"deviceModel": UIDevice.current.modelIdentifier,
			"osVersion": osVersion,
		  "dependencyManager": sdkIntegration]

			if let locale = Locale.preferredLanguages.first {
				defaultUserAgentData["deviceLocale"] = locale
			}

			return defaultUserAgentData
	}()

	/// :nodoc: Track events related to specific VGSShow instance
	public func trackFormEvent(_ form: VGSShow, type: VGSAnalyticsEventType, status: AnalyticEventStatus = .success, extraData: [String: Any]? = nil) {
		let env = form.regionalEnvironment
		let formDetails = ["formId": form.formId,
											 "tnt": form.tenantId,
											 "env": env
		]

		var data: [String: Any]
		if let extraData = extraData {
			data = deepMerge(formDetails, extraData)
		} else {
			data = formDetails
		}

		if case .satelliteURL = form.apiClient.hostURLPolicy {
			data["vgsSatellite"] = true
		}

		trackEvent(type, status: status, extraData: data)
	}

	/// :nodoc: Base function to Track analytics event
	public func trackEvent(_ type: VGSAnalyticsEventType, status: AnalyticEventStatus = .success, extraData: [String: Any]? = nil) {
		var data = [String: Any]()
		if let extraData = extraData {
			data = extraData
		}
		data["type"] = type.rawValue
		data["status"] = status.rawValue
		data["ua"] = VGSAnalyticsClient.userAgentData
		data["version"] = Utils.vgsShowVersion
		data["source"] = Constants.Metadata.source
		data["localTimestamp"] = Int(Date().timeIntervalSince1970 * 1000)

		sendAnalyticsRequest(data: data)
	}

	private static var sdkIntegration: String {
		#if COCOAPODS
		  return "COCOAPODS"
		#endif

		#if SWIFT_PACKAGE
			return "SPM"
		#endif

		return "OTHER"
	}
}

internal extension VGSAnalyticsClient {

	/// Sends analytics event.
	/// - Parameters:
	///   - method: `VGSHTTPMethod` value, default is `.post`.
	///   - path: `Path` for URL, default is `vgs`.
	///   - data: `[String: Any]` object. Request parameters.
	func sendAnalyticsRequest(method: VGSHTTPMethod = .post, path: String = "vgs", data: [String: Any] ) {

		// Check if tracking events enabled.
		guard shouldCollectAnalytics else {
			return
		}

		// Setup URLRequest.
		guard let url = URL(string: baseURL)?.appendingPathComponent(path) else {
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.allHTTPHeaderFields = defaultHttpHeaders

		// Add session id.
		var analyticsParams = data
		analyticsParams["vgsShowSessionId"] = VGSShowAnalyticsSession.shared.vgsShowSessionId

		let jsonData = try? JSONSerialization.data(withJSONObject: analyticsParams, options: .prettyPrinted)
		let encodedJSON = jsonData?.base64EncodedData()
		request.httpBody = encodedJSON

		// Send data.
		urlSession.dataTask(with: request).resume()
	}
}
