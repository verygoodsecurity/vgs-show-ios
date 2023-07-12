//
//  VGSView+Internal.swift
//  VGSShowSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal extension UIView {
    
    /// Log info event. Should be used for `.info` level events only.
    /// - Parameter text: `String` object, event text.
    func logInfoEventWithText(_ text: String) {
        let event = VGSLogEvent(level: .info, text: text)
        logEvent(event)
    }
    
    /// Log info event. Should be used for `.warning` level.
    /// - Parameters:
    ///     - text: `String` object, event text.
    ///     - severityLevel: `VGSLogEvent.SeverityLevel` object, severity level, default is `.warning`.
    func logWarningEventWithText(_ text: String, severityLevel: VGSLogEvent.SeverityLevel = .warning) {
        let event = VGSLogEvent(level: .warning, text: text, severityLevel: severityLevel)
        logEvent(event)
    }
    
    /// Log event.
    /// - Parameter event: `VGSLogEvent` event object.
    func logEvent(_ event: VGSLogEvent) {
        VGSLogger.shared.forwardLogEvent(event)
    }
}
