//
//  VGSMaskedLabel.swift
//  VGSShow
//
//  Created by Dima on 26.10.2020.
//

import Foundation
#if os(iOS)
import UIKit
#endif

internal class VGSMaskedLabel: UILabel {
  
  override var text: String? {
      set {
          secureText = newValue
      }
      get { return nil }
  }
      
  /// set/get text just for internal using
  internal var secureText: String? {
      set {
          super.text = newValue
      }
      get {
          return super.text
      }
  }
}
