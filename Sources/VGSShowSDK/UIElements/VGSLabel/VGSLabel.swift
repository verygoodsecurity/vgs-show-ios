//
//  VGSLabel.swift
//  VGSShow
//
//  Created by Dima on 26.10.2020.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// A view that displays revealed text data.
public final class VGSLabel: UIView, VGSLabelProtocol {

  // MARK: - Enums
  
	/// Text format to copy.
	@objc public enum CopyTextFormat: Int {

		/// Raw revealed text.
		case raw

		/// Formatted text.
		case transformed

		var analyticsKey: String {
			switch self {
			case .transformed:
				return "transformed"
			case .raw:
				return "raw"
			}
		}
	}

	/// Masked label.
  internal var label = VGSMaskedLabel(frame: .zero)

	/// Placeholder label.
	internal let placeholderLabel = VGSAttributedLabel(frame: .zero)

	/// Field content type (will be used for decoding).
	internal let fieldType: VGSShowDecodingContentMode = .text

  /// Horizontal constraints.
	internal var horizontalConstraints = [NSLayoutConstraint]()

	/// Vertical constraints.
  internal var verticalConstraint = [NSLayoutConstraint]()

	/// Horizontal placeholder constraints.
	internal var horizontalPlaceholderConstraints = [NSLayoutConstraint]()

	/// Vertical placeholder constraints.
	internal var verticalPlaceholderConstraint = [NSLayoutConstraint]()

  /// View model, hodls business logic.
	internal var labelModel: VGSLabelViewModelProtocol = VGSLabelModel()

  /// Wrapper to support internal `VGSBaseViewProtocol`.
	internal var model: VGSViewModelProtocol {
    return labelModel
  }

  // MARK: - Functional Attribute
  
  /// Show form that will be assiciated with `VGSLabel`.
	internal weak var vgsShow: VGSShow?

	/// Text formatters container, holds different formatters.
	internal var textFormattersContainer = VGSTextFormattersCoordinator() {
		didSet {
			updateTextAndMaskIfNeeded()
		}
	}

	/// Last revealed text.
	internal var revealedRawText: String? {
		didSet {
			updateTextAndMaskIfNeeded()
		}
	}

	// MARK: - Delegates

	/// The object that acts as the delegate of the VGSLabel.
	public weak var delegate: VGSLabelDelegate?

	// MARK: - Public interface

	/// Add transformation regex to format raw revealed text.
	/// - Parameters:
	///   - regex: `NSRegularExpression` object, transformation regex.
	///   - template: `String` object, template for replacement.
	public func addTransformationRegex(_ regex: NSRegularExpression, template: String) {
		let transformationRegex = VGSTransformationRegex(regex: regex, template: template)
		textFormattersContainer.addTransformationRegex(transformationRegex)
	}

  /// Name that will be associated with `VGSLabel` and used as a decoding contentPath on request response with revealed data from your organization vault.
  public var contentPath: String! {
    set {
      labelModel.decodingContentPath = newValue
			
			let eventText = "Set content path: \(newValue ?? "*nil*")"
			logInfoEventWithText(eventText)
    }
    get {
      return model.decodingContentPath
    }
  }

  /// A Boolean value indicating whether `VGSLabel` string is empty.
  public var isEmpty: Bool {
    return label.isEmpty
  }

  /// Revealed text length.
  public var revealedRawTextLength: Int {
		return revealedRawText?.count ?? 0
  }

	/// Placeholder text.
	public var placeholder: String? {
		didSet {
			let eventText = "Set placeholder: \(placeholder ?? "*nil*")"
			logInfoEventWithText(eventText)

			updateTextAndMaskIfNeeded()
		}
	}

	/// Placeholder text styles.
	public var placeholderStyle: VGSPlaceholderLabelStyle = VGSPlaceholderLabelStyle() {
		didSet {
			placeholderLabel.applyPlaceholderStyle(placeholderStyle)
		}
	}

	/// `Bool` flag. Apply secure mask if `true`. If secure range is not defined mask all text. Default is `false`.
  public var isSecureText: Bool = false {
    didSet {
			let eventText = "isSecureText did change: \(isSecureText). Update text."
			logInfoEventWithText(eventText)

      updateTextAndMaskIfNeeded()
    }
  }
  
  /// Text Symbol that will replace visible label text character when securing String. Should be one charcter only.
  public var secureTextSymbol = "*" {
    didSet {
			let eventText = "Set new secure sybmol: \(secureTextSymbol)"
			logInfoEventWithText(eventText)

			if secureTextSymbol.count > 1 {
				let eventText = "Secure sybmol: \(secureTextSymbol) should be one character only!"
				logWarningEventWithText(eventText)
			}

      if isSecureText { updateTextAndMaskIfNeeded() }
    }
  }

	/// Clear last revealed text and set it to `nil`.  **IMPORTANT!** New request is required to populate label with revealed data.
	public func clearText() {
		revealedRawText = nil

		let eventText = "Previous revealed text has been cleared! New request is required to populate label with revealed data."
		logWarningEventWithText(eventText)
	}

	/// Copy text to pasteboard with format.
	/// - Parameter format: `VGSLabel.CopyTextFormat` object, text format to copy. Default is `.raw`.
	public func copyTextToClipboard(format: CopyTextFormat = .raw) {
		copyText(format: format)
	}

  /// An array of `VGSTextRanges`, where `VGSLabel.secureTextSymbol` should replace text character.
  internal var secureTextRanges: [VGSTextRange]?

	/// Set text range to be replaced with `VGSLabel.secureTextSymbol`.
	/// - Parameters:
	///   - start: `Int` object. Defines range start, should be less or equal to `end` and string length. Default is `nil`.
	///   - end: `Int` object. Defines range end, should be greater or equal to `end` and string length. Default is `nil`.
	public func setSecureText(start: Int? = nil, end: Int? = nil) {
    let ranges = [VGSTextRange(start: start, end: end)]
    setSecureText(ranges: ranges)
  }

	/// Set array of text ranges to be replaced with `VGSLabel.secureTextSymbol`.
	/// - Parameter ranges: `[VGSTextRange]` object, an array of `VGSTextRange` objects to be applied subsequently.
  public func setSecureText(ranges: [VGSTextRange]) {
		let eventText = "Set secure ranges: \(ranges.debugText)"
		logInfoEventWithText(eventText)

		self.secureTextRanges = ranges
    vgsShow?.trackSubscribedViewConfigurationEvent(for: self)
    
    /// Apply secure range if needed
    if isSecureText {
      updateTextAndMaskIfNeeded()
    }
  }
  
  // MARK: - UI Attribute

  /// `UIEdgeInsets` for text. **IMPORTANT!** Paddings should be non-negative.
  public var paddings = UIEdgeInsets.zero {
    didSet {
			setTextPaddings()
			setPlaceholderPaddings()
		}
  }

	/// `UIEdgeInsets` for placeholder. Default is `nil`. If placeholder paddings not set, `paddings` property will be used to control placeholder insets. **IMPORTANT!** Paddings should be non-negative.
	public var placeholderPaddings: UIEdgeInsets? = nil {
		didSet { setPlaceholderPaddings() }
	}

  /// `VGSLabel` text font.
	public var font: UIFont? {
    get {
        return label.font
    }
    set {
      label.font = newValue
    }
  }

	/// Number of lines.
	public var numberOfLines: Int {
		get {
				return label.numberOfLines
		}
		set {
			label.numberOfLines = newValue
		}
	}

  /// `VGSLabel` text color.
  public var textColor: UIColor? {
    get {
        return label.textColor
    }
    set {
      label.textColor = newValue
    }
  }

	/// `VGSLabel` text alignment.
	public var textAlignment: NSTextAlignment {
		get {
				return label.textAlignment
		}
		set {
			label.textAlignment = newValue
		}
	}

	/// `VGSLabel` line break mode.
	public var lineBreakMode: NSLineBreakMode {
		get {
			return label.lineBreakMode
		}
		set {
			label.lineBreakMode = newValue
		}
	}

  /// `VGSLabel` layer corner radius.
  public var cornerRadius: CGFloat {
    get {
        return layer.cornerRadius
    }
    set {
        layer.cornerRadius = newValue
        layer.masksToBounds = newValue > 0
    }
  }

  /// `VGSLabel` layer borderWidth.
  public var borderWidth: CGFloat {
    get {
        return layer.borderWidth
    }
    set {
        layer.borderWidth = newValue
    }
  }

  /// `VGSLabel` layer borderColor.
  public var borderColor: UIColor? {
    get {
        guard let cgcolor = layer.borderColor else {
            return nil
        }
        return UIColor(cgColor: cgcolor)
    }
    set {
        layer.borderColor = newValue?.cgColor
    }
  }

	// MARK: - Custom text styles

	/// `VGSLabel` minimum text line height. 
	public var textMinLineHeight: CGFloat {
		get {
			return label.textMinLineHeight
		}
		set {
			label.textMinLineHeight = newValue
		}
	}

	/// `VGSLabel` text character spacing.
	public var characterSpacing: CGFloat {
		get {
			return label.characterSpacing
		}
		set {
			label.characterSpacing = newValue
		}
	}
  
  /// `VGSLabel` adjustsFontSizeToFitWidth mode.
  internal var adjustsFontSizeToFitWidth: Bool {
    get {
        return label.adjustsFontSizeToFitWidth
    }
    set {
      label.adjustsFontSizeToFitWidth = newValue
    }
  }

  /// `VGSLabel` baselineAlignment mode.
  internal var baselineAlignment: UIBaselineAdjustment {
    get {
        return label.baselineAdjustment
    }
    set {
      label.baselineAdjustment = newValue
    }
  }
  
  // MARK: - Init
	
  override init(frame: CGRect) {
      super.init(frame: frame)
      mainInitialization()
  }
  
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      mainInitialization()
  }
}
