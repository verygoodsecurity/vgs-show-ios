//
//  VGSLabelDelegate.swift
//  VGSShow
//
//  Created by Dima on 03.11.2020.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Delegate methods produced by `VGSLabel`.
@objc @MainActor
public protocol VGSLabelDelegate {

    /// Notifies the delegate that the label's text has been updated with revealed data.
    ///
    /// This method is called immediately after the label successfully receives and renders revealed text
    /// from a reveal request. Use this callback to update UI state, enable dependent controls, or log
    /// metadata events.
    ///
    /// - Parameter label: The `VGSLabel` instance that received the text update.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func labelTextDidChange(_ label: VGSLabel) {
    ///     if label == emailLabel && !label.isEmpty {
    ///         sendButton.isEnabled = true
    ///         print("Email revealed, length: \(label.revealedRawTextLength)")
    ///     }
    /// }
    /// ```
    ///
    /// - Important: Never log or persist the actual revealed text. Only use metadata like `isEmpty` or `revealedRawTextLength`.
    ///
    /// - SeeAlso: `labelRevealDataDidFail(_:error:)`
  @objc optional func labelTextDidChange(_ label: VGSLabel)

    /// Notifies the delegate that a clipboard copy operation has completed.
    ///
    /// This method is called after the user (or your code) successfully copies text to the clipboard
    /// via `copyTextToClipboard(format:)`. Use this callback for analytics, confirmation UI, or
    /// security logging.
    ///
    /// - Parameters:
    ///   - label: The `VGSLabel` instance from which text was copied.
    ///   - format: The format of the copied text (`.raw` or `.transformed`).
    ///
    /// ## Example
    ///
    /// ```swift
    /// func labelCopyTextDidFinish(_ label: VGSLabel, format: VGSLabel.CopyTextFormat) {
    ///     let formatName = format == .raw ? "raw" : "formatted"
    ///     showToast("Text copied (\(formatName))")
    ///     analytics.track("clipboard_copy", properties: ["format": formatName])
    /// }
    /// ```
    ///
    /// - Note: This callback is informational only. The text is already on the clipboard when this is called.
    ///
    /// - SeeAlso: `VGSLabel.copyTextToClipboard(format:)`, `VGSLabel.CopyTextFormat`
    @objc optional func labelCopyTextDidFinish(_ label: VGSLabel, format: VGSLabel.CopyTextFormat)

    /// Notifies the delegate that the reveal operation failed for this specific label.
    ///
    /// This method is called when the SDK cannot populate this label with data, even if the overall
    /// reveal request succeeded. Common causes include mismatched `contentPath`, corrupted data,
    /// or missing fields in the response JSON.
    ///
    /// - Parameters:
    ///   - label: The `VGSLabel` instance that failed to reveal data.
    ///   - error: A `VGSShowError` object describing the failure.
    ///
    /// ## Common Error Types
    ///
    /// - `.fieldNotFound`: The `contentPath` doesn't exist in the response JSON
    /// - `.invalidBase64Data`: Data is corrupted or not valid base64
    /// - `.responseIsInvalidJSON`: The entire response is malformed
    ///
    /// ## Example
    ///
    /// ```swift
    /// func labelRevealDataDidFail(_ label: VGSLabel, error: VGSShowError) {
    ///     switch error.type {
    ///     case .fieldNotFound:
    ///         label.text = "N/A"
    ///         print("Field '\(label.contentPath ?? "unknown")' not found")
    ///     case .invalidBase64Data:
    ///         label.text = "Error"
    ///         print("Corrupted data for field '\(label.contentPath ?? "unknown")'")
    ///     default:
    ///         label.text = "—"
    ///         print("Reveal failed: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    ///
    /// - Important: This is a per-label error. Other subscribed views may have succeeded. Check the overall
    ///              `VGSShowRequestResult` completion handler to determine request-level success.
    ///
    /// - SeeAlso: `VGSShowError`, `VGSErrorType`
    @objc optional func labelRevealDataDidFail(_ label: VGSLabel, error: VGSShowError)
}
