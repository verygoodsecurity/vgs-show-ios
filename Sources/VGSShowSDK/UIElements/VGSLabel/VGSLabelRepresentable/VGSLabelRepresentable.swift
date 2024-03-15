//
//  VGSLabelRepresentable.swift
//  VGSShowSDK
//

import SwiftUI

/// VGSLabelRepresentable Callback handler protocol.
protocol VGSLabelRepresentableCallbacksProtocol: VGSViewRepresentableCallbacksProtocol {
  /// Tells when text copy to pasteboard in specific format.
  var onCopyText: ((VGSLabel.CopyTextFormat) -> Void)? { get set }
}

@available(iOS 14.0, *)
/// A View that displays revealed text data.
public struct VGSLabelRepresentable: VGSViewRepresentableProtocol, VGSLabelRepresentableCallbacksProtocol {
    weak var vgsShow: VGSShow?
    /// Name that will be associated with `VGSLabelRepresentable` and used as a decoding `contentPath` on request response with revealed data from your organization vault.
    var contentPath: String
    /// Transformation regex to format raw revealed text.
    var transformationRegex: VGSTransformationRegex?
    /// Placeholder text.
    var placeholder: String?
    /// Placeholder text styles.
    var placeholderStyle: VGSPlaceholderLabelStyle = VGSPlaceholderLabelStyle()
    /// `Bool` flag. Apply secure mask if `true`. If secure range is not defined mask all text. Default is `false`.
    var isSecureText = false
    /// Text Symbol that will replace visible label text character when securing String. Should be one charcter only. Default is `*` symbol.
    var secureTextSymbol = "*"
    ///`Int` object. Defines range start, should be less or equal to `end` and string length. Default is `nil`.
    var secureTextStart: Int?
    ///`Int` object. Defines range end, should be greater or equal to `end` and string length. Default is `nil`.
    var secureTextEnd: Int?
    /// An array of `VGSTextRange` objects to be applied subsequently.
    var secureTextRanges = [VGSTextRange]()
  
    // MARK: - UI Attribute
    /// `UIEdgeInsets` for text. **IMPORTANT!** Paddings should be non-negative.
    var labelPaddings = UIEdgeInsets.zero
    /// `UIEdgeInsets` for placeholder. Default is `nil`. If placeholder paddings not set, `paddings` property will be used to control placeholder insets. **IMPORTANT!** Paddings should be non-negative.
    var placeholderLabelPaddings: UIEdgeInsets?
    /// Field border line color.
    var borderColor: UIColor?
    /// Field border line width.
    var bodrerWidth: CGFloat?
    // MARK: - Accessibility Attributes
    /// A succinct label in a localized string that
    /// identifies the accessibility element.
    var vgsAccessibilityLabel: String?
    /// A localized string that contains a brief description of the result of
    /// performing an action on the accessibility element.
    var vgsAccessibilityHint: String?
    /// `UIEdgeInsets` for text. **IMPORTANT!** Paddings should be non-negative.

    // MARK: - Font Attributes
    /// Indicates whether `VGSLabelRepresentable ` should automatically update its font
    /// when the device’s `UIContentSizeCategory` is changed. It only works
    /// automatically with dynamic fonts
    var vgsAdjustsFontForContentSizeCategory: Bool?
    /// `VGSLabelRepresentable` text font.
    var font: UIFont?
    /// Number of lines. Default is 1.
    var numberOfLines: Int = 1
    /// `VGSLabelRepresentable` text color.
    var textColor: UIColor?
    /// `VGSLabelRepresentable` text alignment.
    var textAlignment: NSTextAlignment = .natural
    /// `VGSLabelRepresentable` line break mode.
    var lineBreakMode: NSLineBreakMode = .byTruncatingTail
    /// `VGSLabelRepresentable` minimum text line height.
    var textMinLineHeight: CGFloat = 0
  
    // MARK: - VGSLabelRepresentable interaction callbacks
    /// Tells  when reveal data operation was failed for the label.
    /// - Parameter error: `VGSShowError` object.
    var onRevealError: ((VGSShowError) -> Void)?
    /// Tells when label input did changed.
    var onContentDidChange: (() -> Void)?
    /// Tells when raw text is copied in the specified label.
    ///   - action: `VGSLabel.CopyTextFormat` object, copied text format.
    var onCopyText: ((VGSLabel.CopyTextFormat) -> Void)?

    // MARK: - Initialization
    /// Initialization
    ///
    /// - Parameters:
    ///   - contentPath: `String` path in reveal request response with revealed data that should be displayed in VGSLabelRepresentable .
    public init(vgsShow: VGSShow, contentPath: String) {
      self.contentPath = contentPath
      self.vgsShow = vgsShow
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
        vgsLabel.paddings = labelPaddings
        vgsLabel.vgsAccessibilityLabel = vgsAccessibilityLabel
        vgsLabel.vgsAccessibilityHint = vgsAccessibilityHint
        vgsLabel.numberOfLines = numberOfLines
        vgsLabel.textAlignment = textAlignment
        vgsLabel.lineBreakMode = lineBreakMode
        vgsLabel.textMinLineHeight = textMinLineHeight
      
        if let color = borderColor {vgsLabel.borderColor = color}
        if let lineWidth = bodrerWidth {vgsLabel.borderWidth = lineWidth}
      
        if placeholderLabelPaddings != nil {
          vgsLabel.placeholderPaddings = placeholderLabelPaddings
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
      
        if let regex = transformationRegex {
          vgsLabel.textFormattersContainer.addTransformationRegex(regex)
        }
        vgsShow?.subscribe(vgsLabel)
        return vgsLabel
    }

    public func updateUIView(_ uiView: VGSLabel, context: Context) {
      uiView.font = font
      uiView.placeholder = placeholder
      uiView.placeholderStyle = placeholderStyle
      uiView.isSecureText = isSecureText
      uiView.secureTextSymbol = secureTextSymbol
      uiView.paddings = labelPaddings
      uiView.vgsAccessibilityLabel = vgsAccessibilityLabel
      uiView.vgsAccessibilityHint = vgsAccessibilityHint
      uiView.numberOfLines = numberOfLines
      uiView.textAlignment = textAlignment
      uiView.lineBreakMode = lineBreakMode
      uiView.textMinLineHeight = textMinLineHeight
    
      if let color = borderColor {uiView.borderColor = color}
      if let lineWidth = bodrerWidth {uiView.borderWidth = lineWidth}
    
      if placeholderLabelPaddings != nil {
        uiView.placeholderPaddings = placeholderLabelPaddings
      }
      if secureTextStart != nil || secureTextEnd != nil {
        uiView.setSecureText(start: secureTextStart, end: secureTextEnd)
      }
      if !secureTextRanges.isEmpty {
        uiView.setSecureText(ranges: secureTextRanges)
      }
      if let adjustsFont = vgsAdjustsFontForContentSizeCategory {
        uiView.vgsAdjustsFontForContentSizeCategory = adjustsFont
      }
      if let txtColor = textColor {
        uiView.textColor = txtColor
      }
    
      if let regex = transformationRegex {
        uiView.textFormattersContainer.addTransformationRegex(regex)
      }
    }
  
    /// Add transformation regex to format raw revealed text.
    /// - Parameters:
    ///   - regex: `NSRegularExpression` object, transformation regex.
    ///   - template: `String` object, template for replacement.
    public func addTransformationRegex(_ regex: NSRegularExpression, template: String) -> VGSLabelRepresentable {
      var newRepresentable = self
      newRepresentable.transformationRegex = VGSTransformationRegex(regex: regex, template: template)
      return newRepresentable
    }
  
    /// Name that will be associated with `VGSLabelRepresentable` and used as a decoding `contentPath` on request response with revealed data from your organization vault.
    public func contentPath(_ path: String) -> VGSLabelRepresentable {
      var newRepresentable = self
      newRepresentable.contentPath = path
      return newRepresentable
    }

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
    public func labelPaddings(_ paddings: UIEdgeInsets) -> VGSLabelRepresentable {
      var newRepresentable = self
      newRepresentable.labelPaddings = paddings
      return newRepresentable
    }
    
    /// `UIEdgeInsets` for placeholder. Default is `nil`. If placeholder paddings not set, `paddings` property will be used to control placeholder insets. **IMPORTANT!** Paddings should be non-negative.
    public func placeholderLabelPaddings(_ paddings: UIEdgeInsets) -> VGSLabelRepresentable {
      var newRepresentable = self
      newRepresentable.placeholderLabelPaddings = paddings
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

    /// Label text font. By default use default dynamic font style `.body` to update its size
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

    /// Label text color.
    public func textColor(_ color: UIColor?) -> VGSLabelRepresentable {
        var newRepresentable = self
        newRepresentable.textColor = color
        return newRepresentable
    }

    /// Label text alignment.
    public func textAlignment(_ alignment: NSTextAlignment) -> VGSLabelRepresentable {
        var newRepresentable = self
        newRepresentable.textAlignment = alignment
        return newRepresentable
    }

    /// Label line break mode.
    public func lineBreakMode(_ mode: NSLineBreakMode) -> VGSLabelRepresentable {
        var newRepresentable = self
        newRepresentable.lineBreakMode = mode
        return newRepresentable
    }

    // MARK: - Custom text styles
    /// Label minimum text line height.
    public func textMinLineHeight(_ height: CGFloat) -> VGSLabelRepresentable {
        var newRepresentable = self
        newRepresentable.textMinLineHeight = height
        return newRepresentable
    }
    
    // MARK: - Handle Label events
    /// Tells when label text did changed.
    public func onContentDidChange(_ action: (() -> Void)?) -> VGSLabelRepresentable {
      var newRepresentable = self
      newRepresentable.onContentDidChange = action
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
    public func onRevealError(_ action: ((VGSShowError) -> Void)?) -> VGSLabelRepresentable {
      var newRepresentable = self
      newRepresentable.onRevealError = action
      return newRepresentable
    }
  
    // MARK: - Coordinator
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
  
    public class Coordinator: NSObject, VGSLabelDelegate {
      var parent: VGSLabelRepresentable
          
      init(_ parent: VGSLabelRepresentable) {
        self.parent = parent
      }
      
      public func labelTextDidChange(_ label: VGSLabel) {
        parent.onContentDidChange?()
      }

      public func labelCopyTextDidFinish(_ label: VGSLabel, format: VGSLabel.CopyTextFormat) {
        parent.onCopyText?(format)
      }

      public func labelRevealDataDidFail(_ label: VGSLabel, error: VGSShowError) {
        parent.onRevealError?(error)
      }
  }
}
