//
//  VGSPlaceholderLabelStyle.swift
//  VGSShowSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds placeholder styles.
public struct VGSPlaceholderLabelStyle {

	/// Color. Default is gray with 70% opacity.
	public var color: UIColor = UIColor.gray.withAlphaComponent(0.7)

	/// Font, by default use default dynamic font style `.body` to update its size
    /// automatically when the device’s `UIContentSizeCategory` changed.
    public var font: UIFont? = UIFont.preferredFont(forTextStyle: .body)
    
    /// Indicates whether placeholder should automatically update its font
    /// when the device’s `UIContentSizeCategory` is changed. It only works
    /// automatically with dynamic fonts
    public var adjustsFontForContentSizeCategory: Bool = true

	/// Number of lines, default is `1`.
	public var numberOfLines: Int = 1

	/// Text alignment.
	public var textAlignment: NSTextAlignment?

	/// Character spacing. Default is `0`.
	public var characterSpacing: CGFloat = 0

	/// Minimum text line height. Default is `0`.
	public var textMinLineHeight: CGFloat = 0

	/// Line break mode.
	public var lineBreakMode: NSLineBreakMode?
}
