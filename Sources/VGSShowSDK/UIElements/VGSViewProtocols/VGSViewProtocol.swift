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
public protocol VGSViewProtocol: UIView {
	/// Decoding content path.
  var contentPath: String! { get set }
}

internal protocol VGSBaseViewProtocol: UIView {
	var model: VGSViewModelProtocol { get }
	var vgsShow: VGSShow? {get set}
}
