//
//  VGSViewRepresentableProtocol.swift
//  VGSShowSDK
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
/// VGS View Representable protocol.
protocol VGSViewRepresentableProtocol: UIViewRepresentable {
  /// `String` path in reveal request response with revealed data that  should be displayed in VGS View Representable .
  var contentPath: String { get }
  
  var vgsShow: VGSShow? { get }
}
