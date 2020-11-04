//
//  VGSLabel.swift
//  VGSShow
//
//  Created by Dima on 26.10.2020.
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Protocol describing VGS View
public protocol VGSViewProtocol: UIView {
  var fieldName: String! { get set }
}

/// Protocol describing VGSLabel
internal protocol VGSLabelProtocol: VGSViewProtocol {
  var model: VGSLabelViewModelProtocol { get }
}

/// An object responsible for displaying revealed text data.
public final class VGSLabel: UIView, VGSLabelProtocol {
  
  internal var model: VGSLabelViewModelProtocol = VGSLabelModel()
  
  internal var label = VGSMaskedLabel(frame: .zero)
  internal let fieldType: VGSShowDataDecoding = .text
  internal var horizontalConstraints = [NSLayoutConstraint]()
  internal var verticalConstraint = [NSLayoutConstraint]()

	/// The object that acts as the delegate of the VGSLabel.
  public weak var delegate: VGSLabelDelegate?

  /// Show form that will be assiciated with `VGSLabel`.
  private(set) weak var vgsShow: VGSShow?
  
  /// Name that will be associated with `VGSLabel` and used as a decoding keyPath on request response with revealed data from your organozation vault.
  public var fieldName: String! {
    set {
      model.decodingKeyPath = newValue
    }
    get {
      return model.decodingKeyPath
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

internal extension VGSLabel {
  func mainInitialization() {
      // set main style for view
      setDefaultStyle()
      // add UI elements
      buildUI()
    
      model.onValueChanged = { [weak self](text) in
        if let strongSelf = self {
          strongSelf.label.text = text
          strongSelf.delegate?.labelTextDidChange?(strongSelf)
        }
      }
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
}
