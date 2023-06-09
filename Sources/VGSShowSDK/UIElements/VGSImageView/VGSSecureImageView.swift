//
//  VGSSecureImageView.swift
//  VGSShowSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// VGS ImageView subclass.
internal class VGSSecureImageView: UIImageView {
    
    /// Secure image, for internal use only
    internal var secureImage: UIImage? {
        set {
            super.image = newValue
        }

        get {
            return super.image
        }
    }
    
    @available(*, deprecated, message: "Deprecated attribute.")
    override var image: UIImage? {
        set {
            secureImage = newValue
        }
        get {
            if UIApplication.isRunningUITest {
                return super.image
            } else {
                return nil
            }
        }
    }
}
