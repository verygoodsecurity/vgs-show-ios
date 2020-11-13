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
}
