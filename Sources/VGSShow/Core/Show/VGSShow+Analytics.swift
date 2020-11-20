//
//  VGSShow+Analytics.swift
//  VGSShow
//

import Foundation

extension VGSShow {
	func trackSubscribeEvent(for view: VGSViewProtocol) {
		let extraData: [String : Any] = ["field": view.fieldName]
		VGSAnalyticsClient.shared.trackFormEvent(self, type: .fieldInit, extraData: extraData)
	}

	func trackUnsubscribeEvent(for view: VGSViewProtocol) {
		let extraData: [String : Any] = ["field": view.fieldName]
		VGSAnalyticsClient.shared.trackFormEvent(self, type: .fieldUnsubscibe, extraData: extraData)
	}
}
