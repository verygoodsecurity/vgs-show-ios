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
          self?.revealedRawText = text
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

	func copyRawRevealedText() {
		let pasteBoard = UIPasteboard.general
		if let rawText = revealedRawText {
			pasteBoard.string = rawText
			delegate?.labelDidCopyText?(self, hasText: true, isFormatted: false)
		} else {
			delegate?.labelDidCopyText?(self, hasText: false, isFormatted: false)
		}
	}

	func copyFormattedRevealedText() {
		let pasteBoard = UIPasteboard.general
		if let displayedText = label.secureText {
			pasteBoard.string = displayedText
			delegate?.labelDidCopyText?(self, hasText: true, isFormatted: true)
		} else {
			delegate?.labelDidCopyText?(self, hasText: false, isFormatted: true)
		}

	}

  func updateTextAndMaskIfNeeded() {
    guard let text = revealedRawText else {return}

    // No mask: set revealed text.
    guard let mask = transformationRegex else {
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
