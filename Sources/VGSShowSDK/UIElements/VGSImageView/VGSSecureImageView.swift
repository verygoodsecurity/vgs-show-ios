//
//  VGSSecureImageView.swift
//  VGSShowSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// VGS ImageView subclass.
internal class VGSSecureImageView: UIImageView {
    
    /// Secure image
    internal var secureImage: UIImage? {
        set {
            super.image = newValue
        }

        get {
            return super.image
        }
    }
}
