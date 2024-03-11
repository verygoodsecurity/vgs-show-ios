//
//  VGSLabelRepresentable.swift
//  VGSShowSDK
//

import SwiftUI

@available(iOS 14.0, *)
public struct VGSLabelRepresentable: UIViewRepresentable {
    
    var transformationRegex: VGSTransformationRegex?
  
    var contentPath: String
  
    var placeholder: String?
  
    var placeholderStyle: VGSPlaceholderLabelStyle = VGSPlaceholderLabelStyle()
  
    var isSecureText = false
  
    var secureTextSymbol = "*"
  
    var shouldClearText = false
  
    var shouldCopyTextToClipboard = false
  
    var secureTextStart: Int?
  
    var secureTextEnd: Int?
  
    var secureTextRanges = [VGSTextRange]()
  
    var vgsAccessibilityLabel: String?
  
    var vgsAccessibilityHint: String?
  
    var paddings = UIEdgeInsets.zero
  
    var placeholderPaddings: UIEdgeInsets?
  
    var borderColor: UIColor?
    /// Field border line width.
    var bodrerWidth: CGFloat?
  
    var vgsAdjustsFontForContentSizeCategory: Bool?
  
    var font: UIFont?
  
    var numberOfLines: Int = 1
  
    var textColor: UIColor?
  
    var textAlignment: NSTextAlignment = .natural
  
    var lineBreakMode: NSLineBreakMode = .byTruncatingTail
  
    var textMinLineHeight: CGFloat = 0
  
    // MARK: - VGSLabel interaction callbacks
    /// Tells when label text did changed.
    var onTextChange: (() -> Void)?
    /// Tells when raw text is copied in the specified label.
    ///   - format: `VGSLabel.CopyTextFormat` object, copied text format.
    var onCopyText: ((VGSLabel.CopyTextFormat) -> Void)?
    /// Tells  when reveal data operation was failed for the label.
    /// - Parameter error: `VGSShowError` object.
    var onRevealDataDidFail: ((VGSShowError) -> Void)?

    public init(contentPath: String) {
      self.contentPath = contentPath
    }
  
    public func makeUIView(context: Context) -> VGSLabel {
        let vgsLabel = VGSLabel()
        vgsLabel.delegate = context.coordinator
        vgsLabel.font = font
        vgsLabel.contentPath = contentPath
        vgsLabel.placeholder = placeholder
        vgsLabel.placeholderStyle = placeholderStyle
        vgsLabel.isSecureText = isSecureText
        vgsLabel.secureTextSymbol = secureTextSymbol
        vgsLabel.paddings = paddings
        vgsLabel.vgsAccessibilityLabel = vgsAccessibilityLabel
        vgsLabel.vgsAccessibilityHint = vgsAccessibilityHint
        vgsLabel.numberOfLines = numberOfLines
        vgsLabel.textAlignment = textAlignment
        vgsLabel.lineBreakMode = lineBreakMode
        vgsLabel.textMinLineHeight = textMinLineHeight
      
        if let color = borderColor {vgsLabel.borderColor = color}
        if let lineWidth = bodrerWidth {vgsLabel.borderWidth = lineWidth}
      
        if placeholderPaddings != nil {
          vgsLabel.placeholderPaddings = placeholderPaddings
        }
        if secureTextStart != nil || secureTextEnd != nil {
          vgsLabel.setSecureText(start: secureTextStart, end: secureTextEnd)
        }
        if !secureTextRanges.isEmpty {
          vgsLabel.setSecureText(ranges: secureTextRanges)
        }
        if let adjustsFont = vgsAdjustsFontForContentSizeCategory {
          vgsLabel.vgsAdjustsFontForContentSizeCategory = adjustsFont
        }
        if let txtColor = textColor {
          vgsLabel.textColor = txtColor
        }
      
//        if shouldClearText {
//          vgsLabel.clearText()
//          shouldClearText = false
//        }
      
        if let regex = transformationRegex {
          vgsLabel.textFormattersContainer.addTransformationRegex(regex)
        }
        return vgsLabel
    }

    public func updateUIView(_ uiView: VGSLabel, context: Context) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
  
    public func addTransformationRegex(_ regex: NSRegularExpression, template: String) -> VGSLabelRepresentable {
      var newRepresentable = self
      newRepresentable.transformationRegex = VGSTransformationRegex(regex: regex, template: template)
      return newRepresentable
    }
  
    public func contentPath(_ path: String) -> VGSLabelRepresentable {
      var newRepresentable = self
      newRepresentable.contentPath = path
      return newRepresentable
    }

//  /// A Boolean value indicating whether `VGSLabel` string is empty.
//  public var isEmpty: Bool {
//    return label.isEmpty
//  }

//  /// Revealed text length.
//  public var revealedRawTextLength: Int {
//    return revealedRawText?.count ?? 0
//  }

  /// Placeholder text.
  public func placeholder(_ text: String) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.placeholder = text
    return newRepresentable
  }

  /// Placeholder text styles.
  public func placeholderStyle(_ style: VGSPlaceholderLabelStyle) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.placeholderStyle = style
    return newRepresentable
  }

  /// `Bool` flag. Apply secure mask if `true`. If secure range is not defined mask all text. Default is `false`.
  public func isSecureText(_ isSecure: Bool) ->  VGSLabelRepresentable{
    var newRepresentable = self
    newRepresentable.isSecureText = isSecure
    return newRepresentable
  }

  /// Text Symbol that will replace visible label text character when securing String. Should be one charcter only.
  public func secureTextSymbol(_ symbol: String) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.secureTextSymbol = secureTextSymbol
    return newRepresentable
  }

  /// Clear last revealed text and set it to `nil`.  **IMPORTANT!** New request is required to populate label with revealed data.
//  public func clearText() {
//    if let coordinator = context.coordinator {
//        coordinator.clearText()
//    }
//  }
//
//  /// Copy text to pasteboard with format.
//  /// - Parameter format: `VGSLabel.CopyTextFormat` object, text format to copy. Default is `.raw`.
//  public func copyTextToClipboard(format: CopyTextFormat = .raw) {
//    copyText(format: format)
//  }


  /// Set text range to be replaced with `VGSLabel.secureTextSymbol`.
  /// - Parameters:
  ///   - start: `Int` object. Defines range start, should be less or equal to `end` and string length. Default is `nil`.
  ///   - end: `Int` object. Defines range end, should be greater or equal to `end` and string length. Default is `nil`.
  public func setSecureText(start: Int? = nil, end: Int? = nil) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.secureTextStart = start
    newRepresentable.secureTextEnd = end
    
    return newRepresentable
  }

  /// Set array of text ranges to be replaced with `VGSLabel.secureTextSymbol`.
  /// - Parameter ranges: `[VGSTextRange]` object, an array of `VGSTextRange` objects to be applied subsequently.
  public func setSecureText(ranges: [VGSTextRange]) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.secureTextRanges = ranges
    return newRepresentable
  }

  // MARK: - UI Attribute

  /// `UIEdgeInsets` for text. **IMPORTANT!** Paddings should be non-negative.
  public func paddings(_ paddings: UIEdgeInsets) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.paddings = paddings
    return newRepresentable
  }

  /// `UIEdgeInsets` for placeholder. Default is `nil`. If placeholder paddings not set, `paddings` property will be used to control placeholder insets. **IMPORTANT!** Paddings should be non-negative.
  public func placeholderPaddings(_ paddings: UIEdgeInsets) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.placeholderPaddings = paddings
    return newRepresentable
  }

    // MARK: - Accessibility Attributes
  /// A succinct label in a localized string that
  /// identifies the accessibility element.
  public func vgsAccessibilityLabel(_ label: String) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.vgsAccessibilityLabel = label
    return newRepresentable
  }
  
  /// A localized string that contains a brief description of the result of
  /// performing an action on the accessibility element.
  public func vgsAccessibilityHint(_ hint: String?) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.vgsAccessibilityHint = hint
    return newRepresentable
  }

  /// Boolean value that determinates if the text field should be exposed as
  /// an accesibility element.
//  public var vgsIsAccessibilityElement: Bool {
//      get {
//          return label.isAccessibilityElement
//      }
//      set {
//          label.isAccessibilityElement = newValue
//          placeholderLabel.isAccessibilityElement = label.isAccessibilityElement
     
  
    /// Set `borderColor` and `lineWidth`.
    public func border(color: UIColor, lineWidth: CGFloat) -> VGSLabelRepresentable {
        var newRepresentable = self
        newRepresentable.borderColor = color
        newRepresentable.bodrerWidth = lineWidth
        return newRepresentable
    }

    // MARK: - Font Attributes
    /// Indicates whether `VGSLabel ` should automatically update its font
    /// when the device’s `UIContentSizeCategory` is changed. It only works
    /// automatically with dynamic fonts
    public func vgsAdjustsFontForContentSizeCategory(_ adjusts: Bool) -> VGSLabelRepresentable {
      var newRepresentable = self
      newRepresentable.vgsAdjustsFontForContentSizeCategory = adjusts
      return newRepresentable
    }

    /// `VGSLabel` text font. By default use default dynamic font style `.body` to update its size
    /// automatically when the device’s `UIContentSizeCategory` changed.
    public func font(_ font: UIFont) -> VGSLabelRepresentable {
        var newRepresentable = self
        newRepresentable.font = font
        return newRepresentable
    }

    /// Number of lines. Default is 1.
    public func numberOfLines(_ lines: Int) -> VGSLabelRepresentable {
        var newRepresentable = self
        newRepresentable.numberOfLines = lines
        return newRepresentable
    }

    /// `VGSLabel` text color.
    public func textColor(_ color: UIColor?) -> VGSLabelRepresentable {
        var newRepresentable = self
        newRepresentable.textColor = color
        return newRepresentable
    }
  
    /// `VGSLabel` text alignment.
    public func textAlignment(_ alignment: NSTextAlignment) -> VGSLabelRepresentable {
        var newRepresentable = self
        newRepresentable.textAlignment = alignment
        return newRepresentable
    }

    /// `VGSLabel` line break mode.
    public func lineBreakMode(_ mode: NSLineBreakMode) -> VGSLabelRepresentable {
        var newRepresentable = self
        newRepresentable.lineBreakMode = mode
        return newRepresentable
    }

  // MARK: - Custom text styles

  /// `VGSLabel` minimum text line height.
  public func textMinLineHeight(_ height: CGFloat) -> VGSLabelRepresentable {
      var newRepresentable = self
      newRepresentable.textMinLineHeight = height
      return newRepresentable
  }
  
  // MARK: - Handle label events
  /// Tells when label text did changed.
  public func onTextChange(_ action: (() -> Void)?) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.onTextChange = action
    return newRepresentable
  }
  /// Tells when raw text is copied in the specified label.
  ///   - action: `VGSLabel.CopyTextFormat` object, copied text format.
  public func onCopyText(_ action: ((VGSLabel.CopyTextFormat) -> Void)?) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.onCopyText = action
    return newRepresentable
  }
  /// Tells  when reveal data operation was failed for the label.
  ///   - action: `VGSShowError` object.
  public func onRevealDataDidFail(_ action: ((VGSShowError) -> Void)?) -> VGSLabelRepresentable {
    var newRepresentable = self
    newRepresentable.onRevealDataDidFail = action
    return newRepresentable
  }
    
  public class Coordinator: NSObject, VGSLabelDelegate {
    var parent: VGSLabelRepresentable
        
    init(_ parent: VGSLabelRepresentable) {
      self.parent = parent
    }
    
    public func labelTextDidChange(_ label: VGSLabel) {
      parent.onTextChange?()
    }

    public func labelCopyTextDidFinish(_ label: VGSLabel, format: VGSLabel.CopyTextFormat){
      parent.onCopyText?(format)
    }

    public func labelRevealDataDidFail(_ label: VGSLabel, error: VGSShowError) {
      parent.onRevealDataDidFail?(error)
    }
  }
}
