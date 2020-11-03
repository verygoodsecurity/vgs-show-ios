//
//  VGSLabelDelegate.swift
//  VGSShow
//
//  Created by Dima on 03.11.2020.
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Delegate methods produced by `VGSLabel`
@objc
public protocol VGSLabelDelegate: class {
  
  /// `VGSLabel` input changed
  @objc optional func labelTextDidChanged(_ label: VGSLabel)
}
