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
}
