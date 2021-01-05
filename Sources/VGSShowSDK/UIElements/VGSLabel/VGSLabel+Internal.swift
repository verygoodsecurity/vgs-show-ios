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

internal protocol VGSLabelProtocol: VGSViewProtocol, VGSBaseViewProtocol {
  var labelModel: VGSLabelViewModelProtocol { get }
}

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
      setTextPaddings()

			placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
			addSubview(placeholderLabel)
			setPlaceholderPaddings()

			placeholderLabel.isHidden = true
  }

	/// Set paddings.
  func setTextPaddings() {
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

	func setPlaceholderPaddings() {
		var placeholderPaddings = paddings
		
		// Use custom placehoder paddings if needed.
		if let customPlaceholderPaddings = self.placeholderPaddings {
			placeholderPaddings = customPlaceholderPaddings
		}

		NSLayoutConstraint.deactivate(verticalPlaceholderConstraint)
		NSLayoutConstraint.deactivate(horizontalPlaceholderConstraints)

		if placeholderPaddings.hasNegativeValue {
			print("⚠️ VGSShowSDK WARNING! Cannot set placeholder paddings \(placeholderPaddings) with negative values")
			return
		}

		let views = ["view": self, "label": placeholderLabel]

		horizontalPlaceholderConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(placeholderPaddings.left)-[label]-\(placeholderPaddings.right)-|",
																																 options: .alignAllCenterY,
																																 metrics: nil,
																																 views: views)
		NSLayoutConstraint.activate(horizontalPlaceholderConstraints)

		verticalPlaceholderConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(placeholderPaddings.top)-[label]-\(placeholderPaddings.bottom)-|",
																															options: .alignAllCenterX,
																															metrics: nil,
																															views: views)
		NSLayoutConstraint.activate(verticalPlaceholderConstraint)
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
		// Mask only normal text.
		guard let text = revealedRawText else {
			label.secureText = nil
			// No revealed text - show placeholder, hide main text label.
			label.isHidden = true
			updatePlaceholder()
			return
		}

		// Hide placeholder.
		placeholderLabel.isHidden = true

		// Unhide main label.
		label.isHidden = false

    // No mask: set revealed text.
		guard textFormattersContainer.hasFormatting else {
      /// Check if text should be secured
      if isSecureText {
        let securedText = secureTextInRanges(text, ranges: secureTextRanges)
        updateMaskedLabel(with: securedText)
        return
      }
      updateMaskedLabel(with: text)
      return
    }
    
    // Set masked text to label.
    let maskedText = textFormattersContainer.formatText(text)
    if isSecureText {
      let securedText = secureTextInRanges(maskedText, ranges: secureTextRanges)
      updateMaskedLabel(with: securedText)
      return
    }
    updateMaskedLabel(with: maskedText)
  }
  
  func secureTextInRanges(_ text: String, ranges: [VGSTextRange]?) -> String {
    var securedText = text
    
    let secureTextRanges: [VGSTextRange]
    if let ranges = ranges {
      secureTextRanges = ranges
    } else {
      secureTextRanges = [VGSTextRange(start: 0, end: text.count - 1)]
    }
    
    secureTextRanges.forEach { (range) in
      securedText = securedText.secure(in: range, secureSymbol: secureTextSymbol)
    }
    return securedText
  }

	/// Set text to internal label, notify delegate about changing text.
	/// - Parameter text: `String` object, raw text to set.
  func updateMaskedLabel(with text: String) {
    label.secureText = text
    delegate?.labelTextDidChange?(self)
  }

	/// Reset all masks. For internal use now.
	func resetAllMasks() {
		textFormattersContainer.resetAllFormatters()
	}

	/// Update placeholder.
	func updatePlaceholder() {
			placeholderLabel.text = placeholder
			placeholderLabel.isHidden = false
	}
}
