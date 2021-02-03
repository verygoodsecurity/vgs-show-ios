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
			let eventText = "Cannot set paddings \(paddings) with negative values. Will ignore negative paddings."
			logWarningEventWithText(eventText)
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
			let eventText =  "Cannot set placeholder paddings \(placeholderPaddings) with negative values. Will ignore negative paddings."
			logWarningEventWithText(eventText)
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

			let eventText = "Raw text has been copied to clipboard!"
			logInfoEventWithText(eventText)
		case .transformed:
			// Copy raw displayed text if no transformation regex, but mark delegate action as `.formatted`.
			guard textFormattersContainer.hasFormatting else {
				pasteBoard.string = rawText

				let eventText = "Copy option is *formatted*, but no *formatted* is available. Raw text has been copied to clipboard!"
				logInfoEventWithText(eventText)
				return
			}

			// Copy transformed text.
			let formattedText = textFormattersContainer.formatText(rawText)
			pasteBoard.string = formattedText

			let eventText = "Formatted text has been copied to clipboard!"
			logInfoEventWithText(eventText)
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

			logPlaceholderEvent(isShown: true)
			return
		}

		// Hide placeholder.
		placeholderLabel.isHidden = true

		// Unhide main label.
		label.isHidden = false

		logPlaceholderEvent(isShown: false)

    // No mask: set revealed text.
		guard textFormattersContainer.hasFormatting else {
      // Check if text should be secured.
      if isSecureText {
        let securedText = secureTextInRanges(text, ranges: secureTextRanges)
        updateMaskedLabel(with: securedText)

				let eventText = "No custom formatting. Apply secure mask for revealed data."
				logInfoEventWithText(eventText)

        return
      }

			let eventText = "No custom formatting. No secure masks. Show raw revealed data."
			logInfoEventWithText(eventText)

      updateMaskedLabel(with: text)
      return
    }

    // Set masked text to label.
    let maskedText = textFormattersContainer.formatText(text)

		let formattingEvent = "Text before formatting: \"\(text)\", text after formatting: \"\(maskedText)\" ."
		logInfoEventWithText(formattingEvent)

    if isSecureText {
      let securedText = secureTextInRanges(maskedText, ranges: secureTextRanges)
      updateMaskedLabel(with: securedText)

			let eventText = "Apply custom formatting. Apply secure masks."
			logInfoEventWithText(eventText)
      return
    }

		let eventText = "Apply custom formatting. No secure masks."
		logInfoEventWithText(eventText)

    updateMaskedLabel(with: maskedText)
  }

	/// Apply secure mask with specified ranges. If range is not defined secure all text.
	/// - Parameters:
	///   - text: String `object`, text to secure.
	///   - ranges: `[VGSTextRange]` an array of `VGSTextRange` to apply. Should be valid ranges.
	/// - Returns: `String` object, secured string.
  func secureTextInRanges(_ text: String, ranges: [VGSTextRange]?) -> String {
    var securedText = text
    
    let secureTextRanges: [VGSTextRange]
    if let ranges = ranges {
      secureTextRanges = ranges
    } else {
			// Mask everything since range is not defined.
      secureTextRanges = [VGSTextRange(start: nil, end: nil)]
    }
    
    secureTextRanges.forEach { (range) in
      securedText = securedText.secure(in: range, secureSymbol: secureTextSymbol)
    }
    return securedText
  }

	/// Set text to internal label, notify delegate about changing text.
	/// - Parameter text: `String` object, raw text to set.
  func updateMaskedLabel(with text: String) {
		let finalFormttedText = "Set secure text to label: \"\(text)\""
		logInfoEventWithText(finalFormttedText)

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

	/// Log event for is placeholder displayed.
	/// - Parameter isShown: `Bool` flag, `true`if placeholder label is displayed.
	func logPlaceholderEvent(isShown: Bool) {
		var eventText = "Has revealed data to display. Hide placeholder"

		if isShown {
			eventText = "No revealed data to display. Show placeholder."
		}

		let event = VGSLogEvent(level: .info, text: eventText)
		logEvent(event)
	}

	/// Log info event. Should be used for `.info` level events only.
	/// - Parameter text: `String` object, event text.
	func logInfoEventWithText(_ text: String) {
		let event = VGSLogEvent(level: .info, text: text)
		logEvent(event)
	}

	/// Log info event. Should be used for `.warning` level and severityLevel `.warning` only.
	/// - Parameter text: `String` object, event text.
	func logWarningEventWithText(_ text: String) {
		let event = VGSLogEvent(level: .warning, text: text, severityLevel: .warning)
		logEvent(event)
	}

	/// Log event.
	/// - Parameter event: `VGSLogEvent` event object.
	func logEvent(_ event: VGSLogEvent, addSeparatorText: Bool = true) {
		VGSLogger.shared.forwardLogEvent(event)
	}
}
