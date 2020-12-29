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

	/// Font.
	public var font: UIFont?

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
