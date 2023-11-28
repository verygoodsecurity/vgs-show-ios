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
        get {
            return super.image
        }
        set {
            super.image = newValue
        }
    }

    @available(*, deprecated, message: "Deprecated attribute.")
    override var image: UIImage? {
        get {
            if UIApplication.isRunningUITest {
                return super.image
            } else {
                return nil
            }
        }
        set {
            secureImage = newValue
        }
    }
}
