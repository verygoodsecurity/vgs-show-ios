//
//  VGSShow+Analytics.swift
//  VGSShow
//

import Foundation

internal extension VGSShow {
	/// Track subscribe event for view.
	/// - Parameter view: `VGSViewProtocol` view to track.
	func trackSubscribeEvent(for view: VGSViewProtocol) {
		let extraData = analyticsExtraData(for: view)
		VGSAnalyticsClient.shared.trackFormEvent(self, type: .fieldInit, extraData: extraData)
	}

	/// Track unsubscribe event for view.
	/// - Parameter view: `VGSViewProtocol` view to track.
	func trackUnsubscribeEvent(for view: VGSViewProtocol) {
		let extraData = analyticsExtraData(for: view)
		VGSAnalyticsClient.shared.trackFormEvent(self, type: .fieldUnsubscibe, extraData: extraData)
	}

  /// Track subscribed view configuration settings.
  /// - Parameter view: `VGSViewProtocol` view to track.
  func trackSubscribedViewConfigurationEvent(for view: VGSViewProtocol) {
    if let label = view as? VGSLabel {
      trackSubscribedLabelConfigurationEvent(for: label)
		}
  }

  /// Track subscribed label configuration settings.
  /// - Parameter label: `VGSLabel` label to track.
  func trackSubscribedLabelConfigurationEvent(for label: VGSLabel) {
    if let ranges = label.secureTextRanges, ranges.count > 0 {
      let extraData: [String: Any] = ["contentPath": label.contentPath as String]
      VGSAnalyticsClient.shared.trackFormEvent(self, type: .setSecureTextRange, extraData: extraData)
    }
  }

	/// View analytics extra data.
	/// - Parameter view: `VGSViewProtocol` object.
	/// - Returns: `[String: Any]` object, view extra data analytics.
	func analyticsExtraData(for view: VGSViewProtocol) -> [String: Any] {
		var extraData: [String: Any] = ["contentPath": view.contentPath as Any]
		if let viewTypeName = viewTypeName(for: view) {
			extraData["field"] = viewTypeName
		}

		return extraData
	}

	/// View type name for analytics.
	/// - Parameter view: `VGSViewProtocol` object, view to get type name.
	/// - Returns: `String?`, view type name.
	func viewTypeName(for view: VGSViewProtocol) -> String? {
		guard let baseView = view as? VGSBaseViewProtocol else {
			return nil
		}

		return baseView.model.viewType.analyticsName
	}
}
