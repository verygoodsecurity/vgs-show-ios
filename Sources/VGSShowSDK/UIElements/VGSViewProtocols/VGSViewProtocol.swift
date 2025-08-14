//
//  VGSViewProtocol.swift
//  VGSShow
//
//  Created by Eugene on 10.11.2020.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Protocol describing VGS View.
@MainActor
public protocol VGSViewProtocol: UIView {
	/// Decoding content path.
  var contentPath: String! { get set }
}

/// Internal VGSView protocol.
internal protocol VGSBaseViewProtocol: UIView {
	var model: VGSViewModelProtocol { get }
	var vgsShow: VGSShow? {get set}
}

/// Defines view type.
@MainActor
internal enum VGSShowViewType {

	/// Text content (VGSLabel)
	case text

	/// Pdf (VGSPdfView)
	case pdf

    /// Image (VGSImageView)
    case image

    /// Name for analytics.
	internal var analyticsName: String {
		switch self {
		case .text:
			return "text"
		case .pdf:
			return "pdf"
        case .image:
            return "image"
		}
	}
}
