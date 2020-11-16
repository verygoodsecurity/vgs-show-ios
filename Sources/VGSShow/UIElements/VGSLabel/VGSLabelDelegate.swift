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
	///   - hasText: `Bool` flag. `true` if has text in pasteboard.
	///   - isFormatted: `Bool` flag. `true` if copied text is formatted, `false` if text is raw revealed text.
	@objc optional func labelDidCopyText(_ label: VGSLabel, hasText: Bool, isFormatted: Bool)
}
