//
//  VGSViewProtocol.swift
//  VGSShow
//
//  Created by Eugene on 10.11.2020.
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Protocol describing VGS View.
public protocol VGSViewProtocol: UIView {
	/// Decoding keyPath name.
  var fieldName: String! { get set }
}

internal protocol VGSBaseViewProtocol: UIView {
	var model: VGSViewModelProtocol { get }
}
