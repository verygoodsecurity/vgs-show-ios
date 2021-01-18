//
//  VGSShow+Analytics.swift
//  VGSShow
//

import Foundation

internal extension VGSShow {
	/// Track subscribe event for view.
	/// - Parameter view: `VGSViewProtocol` view to track.
	func trackSubscribeEvent(for view: VGSViewProtocol) {
		let extraData: [String: Any] = ["contentPath": view.contentPath as Any]
		VGSAnalyticsClient.shared.trackFormEvent(self, type: .fieldInit, extraData: extraData)
	}

	/// Track unsubscribe event for view.
	/// - Parameter view: `VGSViewProtocol` view to track.
	func trackUnsubscribeEvent(for view: VGSViewProtocol) {
		let extraData: [String: Any] = ["contentPath": view.contentPath as Any]
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

}
