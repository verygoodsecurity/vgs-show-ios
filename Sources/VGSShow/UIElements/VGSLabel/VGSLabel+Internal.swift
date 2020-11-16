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

	var canCopyText: Bool {
		return !revealedRawText.isNilOrEmpty
	}

	func copyRawRevealedTextWithFormat(format: VGSLabelCopyTextFormat) {
		guard canCopyText, let rawText = revealedRawText else {
			delegate?.labelCopyTextDidFinish?(self, format: format)
			return
		}

		let pasteBoard = UIPasteboard.general
		pasteBoard.string = rawText
		delegate?.labelCopyTextDidFinish?(self, format: format)
	}

	func copyFormattedRevealedText() {
		guard canCopyText, let rawText = revealedRawText else {
			delegate?.labelCopyTextDidFinish?(self, format: .formatted)
			return
		}

		// Copy raw displayed text if no transformation regex, mark delegate action as `.formatted`.
		guard let labelTransformationRegex = transformationRegex else {
			copyRawRevealedTextWithFormat(format: .formatted)
			return
		}

		let pasteBoard = UIPasteboard.general
    let formattedText = rawText.transformWithRegexMask(labelTransformationRegex)
		pasteBoard.string = formattedText

		delegate?.labelCopyTextDidFinish?(self, format: .formatted)
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
