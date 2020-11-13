//
//  VGSLabel+Internal.swift
//  VGSShow
//
//  Created by Dima on 10.11.2020.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal extension VGSLabel {
  func mainInitialization() {
      // set main style for view
      setDefaultStyle()
      // add UI elements
      buildUI()

      labelModel.onValueChanged = { [weak self](text) in
          self?.revealedText = text
      }
      labelModel.view = self
  }

  func setDefaultStyle() {
      clipsToBounds = true
      layer.borderColor = UIColor.lightGray.cgColor
      layer.borderWidth = 1
      layer.cornerRadius = 4
  }
  
  func buildUI() {
      label.translatesAutoresizingMaskIntoConstraints = false
      addSubview(label)
      setPaddings()
  }
  
  func setPaddings() {
    NSLayoutConstraint.deactivate(verticalConstraint)
    NSLayoutConstraint.deactivate(horizontalConstraints)
    
    let views = ["view": self, "label": label]
      
    horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(padding.left)-[label]-\(padding.right)-|",
                                                                 options: .alignAllCenterY,
                                                                 metrics: nil,
                                                                 views: views)
    NSLayoutConstraint.activate(horizontalConstraints)
      
    verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(padding.top)-[label]-\(padding.bottom)-|",
                                                              options: .alignAllCenterX,
                                                              metrics: nil,
                                                              views: views)
    NSLayoutConstraint.activate(verticalConstraint)
    self.layoutIfNeeded()
  }

  func updateTextAndMaskIfNeeded() {
    guard let text = revealedText else {return}

    // No mask: set revealed text.
    guard let mask = regexMask else {
      updateMaskedLabel(with: text)
      return
    }

    // Set masked text to label.
    let maskedText = text.transformWithRegexMask(mask)
    updateMaskedLabel(with: maskedText)
  }

  func updateMaskedLabel(with text: String) {
    label.secureText = text
    delegate?.labelTextDidChange?(self)
  }
}
