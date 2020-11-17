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

	/// Basic initialization & view setup.
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

	/// Default styles setup.
  func setDefaultStyle() {
      clipsToBounds = true
      layer.borderColor = UIColor.lightGray.cgColor
      layer.borderWidth = 1
      layer.cornerRadius = 4
  }

	/// Setup subviews.
  func buildUI() {
      label.translatesAutoresizingMaskIntoConstraints = false
      addSubview(label)
      setPaddings()
  }

	/// Set paddings.
  func setPaddings() {
    NSLayoutConstraint.deactivate(verticalConstraint)
    NSLayoutConstraint.deactivate(horizontalConstraints)

		if paddings.hasNegativeValue {
			assertionFailure("cannot set paddings \(paddings) with negative values")
			return
		}
    
    let views = ["view": self, "label": label]
      
    horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(paddings.left)-[label]-\(paddings.right)-|",
                                                                 options: .alignAllCenterY,
                                                                 metrics: nil,
                                                                 views: views)
    NSLayoutConstraint.activate(horizontalConstraints)
      
    verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(paddings.top)-[label]-\(paddings.bottom)-|",
                                                              options: .alignAllCenterX,
                                                              metrics: nil,
                                                              views: views)
    NSLayoutConstraint.activate(verticalConstraint)
    self.layoutIfNeeded()
  }

	/// `Bool` flag indicating if copy option is available.
	var canCopyText: Bool {
		return !revealedRawText.isNilOrEmpty
	}

	/// Copy raw revealed text with format.
	/// - Parameter format: `VGSLabelCopyTextFormat` object,  format to copy text.
	func copyRawRevealedTextWithFormat(format: VGSLabelCopyTextFormat) {
		guard canCopyText, let rawText = revealedRawText else {
			delegate?.labelCopyTextDidFinish?(self, format: format)
			return
		}

		let pasteBoard = UIPasteboard.general
		pasteBoard.string = rawText
		delegate?.labelCopyTextDidFinish?(self, format: format)
	}

	/// Copy formatted with transformation mask text.
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

	/// Update text and apply transformation regex if available.
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

	/// Set text to internal label, notify delegate about changing text.
	/// - Parameter text: `String` object, raw text to set.
  func updateMaskedLabel(with text: String) {
    label.secureText = text
    delegate?.labelTextDidChange?(self)
  }
}
