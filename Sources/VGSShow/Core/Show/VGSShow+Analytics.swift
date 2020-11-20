//
//  VGSShow+Analytics.swift
//  VGSShow
//

import Foundation

extension VGSShow {
	/// Track subscribe event for view.
	/// - Parameter view: `VGSViewProtocol` view to track.
	func trackSubscribeEvent(for view: VGSViewProtocol) {
		let extraData: [String : Any] = ["field": view.fieldName]
		VGSAnalyticsClient.shared.trackFormEvent(self, type: .fieldInit, extraData: extraData)
	}

	/// Track unsubscribe event for view.
	/// - Parameter view: `VGSViewProtocol` view to track.
	func trackUnsubscribeEvent(for view: VGSViewProtocol) {
		let extraData: [String : Any] = ["field": view.fieldName]
		VGSAnalyticsClient.shared.trackFormEvent(self, type: .fieldUnsubscibe, extraData: extraData)
	}
}
