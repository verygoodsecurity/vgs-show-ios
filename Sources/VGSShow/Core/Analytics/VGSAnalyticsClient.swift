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
}

/// Client responsably for managing and sending VGS Show SDK analytics events.
/// Note: we track only VGSShowSDK usage and features statistics.
/// :nodoc:
public class VGSAnalyticsClient {

	public enum AnalyticEventStatus: String {
		case success = "Ok"
		case failed = "Failed"
		case cancel = "Cancel"
	}

	/// Shared `VGSAnalyticsClient` instance
	public static let shared = VGSAnalyticsClient()

	/// Enable or disable VGS analytics tracking
	public var shouldCollectAnalytics = true

	/// Uniq id that should stay the same during application rintime
	public let vgsShowSessionId = UUID().uuidString

	private init() {}

	internal let urlSession = URLSession(configuration: .ephemeral)

	internal let baseURL = "https://vgs-collect-keeper.apps.verygood.systems/"

	internal let defaultHttpHeaders: HTTPHeaders = {
		return ["Content-Type": "application/x-www-form-urlencoded" ]
	}()

	internal static let userAgentData: [String: Any] = {
		let version = ProcessInfo.processInfo.operatingSystemVersion
		let osVersion = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
		return [
			"platform": UIDevice.current.systemName,
			"device" : UIDevice.current.model,
			"osVersion": osVersion ]
	}()

	/// :nodoc: Track events related to specific VGSShow instance
	public func trackFormEvent(_ form: VGSShow, type: VGSAnalyticsEventType, status: AnalyticEventStatus = .success, extraData: [String: Any]? = nil) {
		let env = form.regionalEnvironment
		let formDetails = ["formId": form.formId,
											 "tnt": form.tenantId,
											 "env": env
		]
		let data: [String: Any]
		if let extraData = extraData {
			data = deepMerge(formDetails, extraData)
		} else {
			data = formDetails
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
		data["source"] = "iosSDK"
		data["localTimestamp"] = Int(Date().timeIntervalSince1970 * 1000)

		#warning("Verify this field")
		// data["vgsCollectSessionId"] = vgsShowSessionId
		sendAnalyticsRequest(data: data)
	}
}

internal extension VGSAnalyticsClient {

	/// Sends analytics event.
	/// - Parameters:
	///   - method: `VGSHTTPMethod` value, default is `.post`.
	///   - path: `Path` for URL, default is `vgs`.
	///   - data: `[String: Any]` object. Request parameters.
	func sendAnalyticsRequest(method: VGSHTTPMethod = .post, path: String = "vgs", data: [String: Any] ) {

		// Check if tracking events enabled
		guard shouldCollectAnalytics else {
			return
		}

		// Setup URLRequest
		guard let url = URL(string: baseURL)?.appendingPathComponent(path) else {
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.allHTTPHeaderFields = defaultHttpHeaders

		let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
		let encodedJSON = jsonData?.base64EncodedData()
		request.httpBody = encodedJSON

		// Send data
		urlSession.dataTask(with: request).resume()
	}
}