//
//  VGSShow+Analytics.swift
//  VGSShow
//

import Foundation
import VGSClientSDKAnalytics

internal extension VGSShow {
  
  /// Track subscribe event for view.
  /// - Parameter view: `VGSViewProtocol` view to track.
  func trackSubscribeEvent(for view: VGSViewProtocol) {
    if let fieldType = viewTypeName(for: view) {
      VGSAnalyticsClient.shared.capture(self, event: VGSAnalyticsEvent.FieldAttach(fieldType: fieldType, contentPath: view.contentPath, ui: nil))
    } else {
      print("Init analytic event not being send. Reason: view type is nil, for \(view)")
    }
  }
  
  /// Track unsubscribe event for view.
  /// - Parameter view: `VGSViewProtocol` view to track.
  func trackUnsubscribeEvent(for view: VGSViewProtocol) {
    if let fieldType = viewTypeName(for: view) {
      VGSAnalyticsClient.shared.capture(self, event: VGSAnalyticsEvent.FieldDetach(fieldType: fieldType))
    } else {
      print("UnsubscribeField event not being send. Reason: view type is nil, for \(view)")
    }
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
    let count = label.secureTextRanges?.count
    let fieldType = viewTypeName(for: label)
    guard let count = label.secureTextRanges?.count, let fieldType = viewTypeName(for: label) else {
      print("SetSecureTextRange event not being send. Reason: view type is nil or secure text range is 0, for \(label)")
      return
    }
    VGSAnalyticsClient.shared.capture(self, event: VGSAnalyticsEvent.SecureTextRange(fieldType: fieldType, contentPath: label.contentPath as String))
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
