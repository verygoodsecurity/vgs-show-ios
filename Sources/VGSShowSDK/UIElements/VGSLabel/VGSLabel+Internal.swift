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
	  	labelModel.onError = {[weak self] (error) in
			    guard let strongSelf = self else {return}
				  strongSelf.delegate?.labelRevealDataDidFail?(strongSelf, error: error)
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
			print("⚠️ VGSShowSDK WARNING! Cannot set paddings \(paddings) with negative values")
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

	/// Copy to pasteboard text.
	/// - Parameter format: `VGSLabelCopyTextFormat` object, format to copy text.
	func copyText(format: VGSLabel.CopyTextFormat) {

		// Always notify delegate about copy action.
		defer {
			let data = ["copy_format": format.analyticsKey]
			VGSAnalyticsClient.shared.trackEvent(.copy, status: .clicked, extraData: data)
			delegate?.labelCopyTextDidFinish?(self, format: format)
		}

		// Copy only non-empty text.
		guard !isEmpty, let rawText = revealedRawText else {
			return
		}

		let pasteBoard = UIPasteboard.general

		switch format {
		case .raw:
			pasteBoard.string = rawText
		case .transformed:
			// Copy raw displayed text if no transformation regex, but mark delegate action as `.formatted`.
			guard textFormattersContainer.hasFormatting else {
				pasteBoard.string = rawText
				return
			}

			// Copy transformed text.
			let formattedText = textFormattersContainer.formatText(rawText)
			pasteBoard.string = formattedText
		}
	}

	/// Update text and apply transformation regex if available.
  func updateTextAndMaskIfNeeded() {
    guard let text = revealedRawText else {return}

    // No mask: set revealed text.
		guard textFormattersContainer.hasFormatting else {
      updateMaskedLabel(with: text)
      return
    }

    // Set masked text to label.
    let maskedText = textFormattersContainer.formatText(text)
    updateMaskedLabel(with: maskedText)
  }

	/// Set text to internal label, notify delegate about changing text.
	/// - Parameter text: `String` object, raw text to set.
  func updateMaskedLabel(with text: String) {
    label.secureText = text
    delegate?.labelTextDidChange?(self)
  }

	/// Reset all masks. For internal use now.
	func resetToRawText() {
		textFormattersContainer.resetAllFormatters()
	}
}
