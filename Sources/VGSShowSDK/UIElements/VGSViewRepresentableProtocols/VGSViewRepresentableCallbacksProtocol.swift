//
//  VGSViewRepresentableCallbacksProtocol.swift
//  VGSShowSDK
//

import Foundation

/// VGSViewRepresentable Callback handler protocol.
protocol VGSViewRepresentableCallbacksProtocol {
  /// Tells when VGSViewRepresentable  content did changed.
  var onContentDidChange: (() -> Void)? { get set }
  /// Tells  when reveal data operation was failed for the VGSViewRepresentable.
  var onRevealError: ((VGSShowError) -> Void)? { get set }
}
