//
//  VGSUITestElementType.swift
//  VGSShowDemoAppUITests
//

import Foundation

/// VGSUITestElementType holds different XCUIElements types.
enum VGSUITestElementType {
	/// Label.
	case label

	/// Button.
	case button

	/// Table view.
	case table

	/// Slider.
	case slider

	/// Other - usually simple `UIView`.
	case other

	/// Collection view.
	case collection

  /// Image view.
	case image

	/// Text field.
	case textField

	/// Tab bar.
	case tabBar
}
