//
//  VGSPlaceholderLabelStyle.swift
//  VGSShowSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// A configuration object that defines the visual appearance of placeholder text in `VGSLabel`.
///
/// `VGSPlaceholderLabelStyle` provides fine-grained control over how placeholder text is displayed
/// while waiting for revealed data. Customize fonts, colors, alignment, line breaking, and spacing
/// to match your app's design system.
///
/// - SeeAlso: `VGSLabel.placeholder`, `VGSLabel.placeholderStyle`
public struct VGSPlaceholderLabelStyle {

    /// The color of the placeholder text. Default is gray with 70% opacity.
    public var color: UIColor = UIColor.gray.withAlphaComponent(0.7)

    /// The font used for placeholder text. When `nil`, the label's main font is used.
  public var font: UIFont?

  /// A Boolean value indicating whether the font automatically scales with Dynamic Type.
    /// Only works with fonts from the `UIFont.preferredFont(...)` family. Default is `false`.
  public var adjustsFontForContentSizeCategory: Bool = false

    /// The maximum number of lines for placeholder text. Default is `1`.
    public var numberOfLines: Int = 1

    /// The horizontal text alignment. When `nil`, the label's text alignment is used.
    public var textAlignment: NSTextAlignment?

    /// The character (letter) spacing in points. Default is `0`.
    public var characterSpacing: CGFloat = 0

    /// The minimum line height in points. Default is `0` (automatic).
    public var textMinLineHeight: CGFloat = 0

    /// The line break mode. When `nil`, the label's line break mode is used.
    public var lineBreakMode: NSLineBreakMode?
  
  /// Creates a placeholder style with default values.
  public init(){}
}
