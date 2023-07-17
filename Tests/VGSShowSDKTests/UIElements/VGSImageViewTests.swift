//
//  VGSImageViewTests.swift
//  VGSShowSDK

import Foundation
import XCTest
@testable import VGSShowSDK

class VGSImageViewTests: XCTestCase {

    func testImage() {
        let imageView = VGSImageView()

        // Default properties
        XCTAssertEqual(imageView.imageContentMode, UIView.ContentMode.scaleToFill)
        
        // Content path
        imageView.contentPath = "test.image"
        XCTAssertEqual(imageView.contentPath, "test.image")
        
        // Secure image
        XCTAssertFalse(imageView.hasImage)
        imageView.baseImageView.secureImage = UIImage()
        XCTAssertTrue(imageView.hasImage)
        imageView.baseImageView.secureImage = nil
        XCTAssertFalse(imageView.hasImage)
        
        // No has image
        XCTAssertFalse(imageView.hasImage)
        XCTAssertNil(imageView.baseImageView.secureImage)
        
        // Has image
        imageView.baseImageView.secureImage = UIImage()
        XCTAssertTrue(imageView.hasImage)
        XCTAssertNotNil(imageView.baseImageView.secureImage)
        
        // Clear
        imageView.clear()
        XCTAssertFalse(imageView.hasImage)
        XCTAssertNil(imageView.baseImageView.secureImage)
        
        // Image access from child sub views
        imageView.baseImageView.secureImage = UIImage()
        let imageViewChild = imageView.subviews.filter { child in
            child is UIImageView
        }.first as? UIImageView
        XCTAssertNotNil(imageViewChild)
        XCTAssertNil(imageViewChild?.image)
        XCTAssertNotNil(imageView.baseImageView.secureImage)
    }
}
