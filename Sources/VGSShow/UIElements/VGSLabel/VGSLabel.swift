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

internal protocol VGSLabelProtocol: VGSViewProtocol, VGSBaseViewProtocol {
  var labelModel: VGSLabelViewModelProtocol { get }
}

/// An object that displays revealed text data.
public final class VGSLabel: UIView, VGSLabelProtocol {

  internal var label = VGSMaskedLabel(frame: .zero)
  internal let fieldType: VGSShowDecodingContentMode = .text
  internal var horizontalConstraints = [NSLayoutConstraint]()
  internal var verticalConstraint = [NSLayoutConstraint]()
  internal var labelModel: VGSLabelViewModelProtocol = VGSLabelModel()
  internal var model: VGSViewModelProtocol {
    return labelModel
  }
  
  // MARK: - Delegates

  /// The object that acts as the delegate of the VGSLabel.
  public weak var delegate: VGSLabelDelegate?

  // MARK: - Functional Attribute
  
  /// Show form that will be assiciated with `VGSLabel`.
  private(set) weak var vgsShow: VGSShow?

	/// Last revealed text.
	internal var revealedRawText: String? {
		didSet {
			updateTextAndMaskIfNeeded()
		}
	}
  
  /// Name that will be associated with `VGSLabel` and used as a decoding keyPath on request response with revealed data from your organization vault.
  public var fieldName: String! {
    set {
      labelModel.decodingKeyPath = newValue
    }
    get {
      return model.decodingKeyPath
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

	/// Copy raw revealed text to pasteboard.
	public func copyRawText() {
		copyRawRevealedText()
	}

	/**
	Transformation regex to format revealed raw text. Default is `nil`.

	 # Example #
	```
	let cardNumberLabel = VGSLabel();

	// Split card number to XXXX-XXXX-XXXX-XXXX format.
	if let transformationRegex = try? VGSTransformationRegex(pattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})", template: "$1-$2-$3-$4") {
	  cardNumberLabel.transformationRegex = transformationRegex
	}

	// Fetched data:  "4111111111111111"
	// Text in label: "4111-1111-1111-1111"

	// You can also set your own regex for formatting.
	do {
	 // Split card number to XXXX/XXXX/XXXX/XXXX format.
   let regex = try NSRegularExpression(pattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})", options: [])
	  let transformationRegex = VGSTransformationRegex(regex: regex, template: "$1/$2/$3/$4")
	  cardNumberLabel.transformationRegex = transformationRegex
	} catch {
	  print("wrong regex format: \(error)")
	}

	// Revealed raw text:  "4111111111111111"
	// Text in label: "4111/1111/1111/1111"
	```
	*/
	public var transformationRegex: VGSTransformationRegex? = nil {
		didSet {
			updateTextAndMaskIfNeeded()
		}
	}
  
  // MARK: - UI Attribute

  /// `UIEdgeInsets` for text and placeholder inside `VGSTextField`.
  public var padding = UIEdgeInsets.zero {
    didSet { setPaddings() }
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
