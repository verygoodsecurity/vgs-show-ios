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
@objc
public protocol VGSLabelDelegate: class {
  
	/// Tells the delegate when text changes in the specified label.
	/// - Parameter label: `VGSLabel` view in which text was changed.
  @objc optional func labelTextDidChange(_ label: VGSLabel)

	/// Tells the delegate when raw text is copied in the specified label.
	/// - Parameters:
	///   - label: `VGSLabel` view in which raw text was copied.
	///   - isCopied: `Bool` flag, `true` if
	///   - format: `VGSLabelCopyTextFormat` object, copied text format.
	@objc optional func labelCopyTextDidFinish(_ label: VGSLabel, format: VGSLabel.VGSLabelCopyTextFormat)
}
