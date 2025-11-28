//
//  VGSTextRange.swift
//  VGSShowSDK
//

import Foundation

/// An object representing text range with closed  boundaries.
public struct VGSTextRange {
    /// The inclusive starting index of the range (0-based).
    ///
    /// When `nil`, the range starts from the beginning of the string.
    public let start: Int?

    /// The exclusive ending index of the range.
    ///
    /// When `nil`, the range extends to the end of the string.
    public let end: Int?

    /// Creates a text range for masking operations.
    ///
    /// Defines a half-open interval `[start, end)` where characters will be replaced with the secure symbol.
    /// Use `nil` for unbounded edges.
    ///
    /// - Parameters:
    ///   - start: The inclusive starting index (0-based). `nil` means start from beginning. Default is `nil`.
    ///   - end: The exclusive ending index. `nil` means extend to end of string. Default is `nil`.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Mask characters 0-5 (positions 0,1,2,3,4)
    /// let range1 = VGSTextRange(start: 0, end: 5)
    ///
    /// // Mask from position 10 to end
    /// let range2 = VGSTextRange(start: 10, end: nil)
    ///
    /// // Mask from start to position 8
    /// let range3 = VGSTextRange(start: nil, end: 8)
    ///
    /// // Mask entire string
    /// let range4 = VGSTextRange()
    /// ```
    public init(start: Int? = nil, end: Int? = nil) {
        self.start = start
        self.end = end
    }

    /// Debug string for `.start`.
    internal var startText: String {
        guard let startValue = start else {
            return "nil"
        }

        return String(startValue)
    }

    /// Debug string for `.end`.
    internal var endText: String {
        guard let endValue = end else {
            return "nil"
        }

        return String(endValue)
    }

    /// Debug string for `range`.
    internal var debugText: String {
        return "[\(startText), \(endText)]"
    }
}

internal extension Array where Element == VGSTextRange {

    /// Debug string for formatted `[VGSTextRange]`.
    var debugText: String {
        return map({return $0.debugText}).joined(separator: ", ")
    }
}
