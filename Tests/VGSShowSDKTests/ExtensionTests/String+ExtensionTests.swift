//
//  String+ExtensionTests.swift
//  VGSShowSDKTests
//
import XCTest
@testable import VGSShowSDK

class StringExtensionTests: XCTestCase {

    // MARK: - String attributes Tests

    func testAttributed_withForegroundColor() {
        let testString = "Test String"
        let color = UIColor.red
        let attribute: StringStyleAttribute = .color(color)

        let attributedString = testString.attributed(attribute)
        let appliedAttributes = attributedString.attributes(at: 0, effectiveRange: .none)
        XCTAssertEqual(appliedAttributes[.foregroundColor] as? UIColor, color, "Foreground color should be applied")
    }

    func testAttributed_withFont() {
        let testString = "Test String"
        let font = UIFont.systemFont(ofSize: 12)
        let attribute: StringStyleAttribute = .font(font)

        let attributedString = testString.attributed(attribute)
        let appliedAttributes = attributedString.attributes(at: 0, effectiveRange: .none)
        XCTAssertEqual(appliedAttributes[.font] as? UIFont, font, "Font should be applied")
    }

    func testAttributed_withMultipleAttributes() {
        let testString = "Test String"
        let color = UIColor.red
        let font = UIFont.systemFont(ofSize: 12)
        let attributes: [StringStyleAttribute] = [.color(color), .font(font)]

      let attributedString = testString.attributed(with: attributes)
        let appliedAttributes = attributedString.attributes(at: 0, effectiveRange: .none)
        XCTAssertEqual(appliedAttributes[.foregroundColor] as? UIColor, color, "Color should be applied")
        XCTAssertEqual(appliedAttributes[.font] as? UIFont, font, "Font should be applied")
    }

    func testAttributed_withParagraphStyleAttributes() {
        let testString = "Test String"
        let lineBreakMode = NSLineBreakMode.byTruncatingTail
        let alignment = NSTextAlignment.center
        let attributes: [StringStyleAttribute] = [.lineBreakMode(lineBreakMode), .alignment(alignment)]

        let attributedString = testString.attributed(with: attributes)
        let appliedAttributes = attributedString.attributes(at: 0, effectiveRange: .none)
        let paragraphStyle = appliedAttributes[.paragraphStyle] as? NSParagraphStyle
        XCTAssertEqual(paragraphStyle?.alignment, alignment, "Text alignment should be applied")
        XCTAssertEqual(paragraphStyle?.lineBreakMode, lineBreakMode, "Line break mode should be applied")
    }

    func testAttributed_withCharacterSpacing() {
         let testString = "Test String"
         let characterSpacing: CGFloat = 1.5
         let attribute: StringStyleAttribute = .characterSpacing(characterSpacing)

         let attributedString = testString.attributed(attribute)
        let appliedAttributes = attributedString.attributes(at: 0, effectiveRange: .none)
        XCTAssertEqual(appliedAttributes[.kern] as? CGFloat, characterSpacing, "Character spacing should be applied")
     }

     func testAttributed_withMinimumLineHeight() {
         let testString = "Test String"
         let minimumLineHeight: CGFloat = 20.0
         let attribute: StringStyleAttribute = .minimumLineHeight(minimumLineHeight)

         let attributedString = testString.attributed(attribute)
        let paragraphStyle = (attributedString.attributes(at: 0, effectiveRange: .none)[.paragraphStyle] as? NSParagraphStyle)
         XCTAssertEqual(paragraphStyle?.minimumLineHeight, minimumLineHeight, "Minimum line height should be applied")
     }

     func testAttributed_withAlignment() {
         let testString = "Test String"
         let alignment: NSTextAlignment = .justified
         let attribute: StringStyleAttribute = .alignment(alignment)

         let attributedString = testString.attributed(attribute)
         let paragraphStyle = (attributedString.attributes(at: 0, effectiveRange: .none)[.paragraphStyle] as? NSParagraphStyle)
         XCTAssertEqual(paragraphStyle?.alignment, alignment, "Text alignment should be applied")
     }

     func testAttributed_withLineBreakMode() {
         let testString = "Test String"
         let lineBreakMode: NSLineBreakMode = .byCharWrapping
         let attribute: StringStyleAttribute = .lineBreakMode(lineBreakMode)

         let attributedString = testString.attributed(attribute)
         let paragraphStyle = (attributedString.attributes(at: 0, effectiveRange: .none)[.paragraphStyle] as? NSParagraphStyle)
         XCTAssertEqual(paragraphStyle?.lineBreakMode, lineBreakMode, "Line break mode should be applied")
     }

     func testAttributed_withUnderline() {
         let testString = "Test String"
         let underlineStyle: NSUnderlineStyle = .single
         let attribute: StringStyleAttribute = .isUnderlined(underlineStyle)

         let attributedString = testString.attributed(attribute)
         let attributes = attributedString.attributes(at: 0, effectiveRange: .none)
         XCTAssertEqual(attributes[.underlineStyle] as? NSUnderlineStyle, underlineStyle, "Underline style should be applied")
     }

    // MARK: - NilOREmpty Tests

    func testIsNilOrEmpty_whenStringIsNil() {
        let optionalString: String? = nil
        let result = optionalString.isNilOrEmpty
        XCTAssertTrue(result, "The result should be true when the optional string is nil")
      }

      func testIsNilOrEmpty_whenStringIsEmpty() {
        let optionalString: String? = ""
        let result = optionalString.isNilOrEmpty
        XCTAssertTrue(result, "The result should be true when the optional string is empty")
      }

      func testIsNilOrEmpty_whenStringIsNotEmpty() {
        let optionalString: String? = "Not empty"
        let result = optionalString.isNilOrEmpty
        XCTAssertFalse(result, "The result should be false when the optional string is not empty")
      }
}
