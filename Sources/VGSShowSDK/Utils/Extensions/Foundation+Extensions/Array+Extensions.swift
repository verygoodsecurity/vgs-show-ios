//
//  Array+Extensions.swift
//  VGSShow
//
//  Created by Eugene on 29.10.2020.
//

import Foundation

internal extension Array where Element: Hashable {
	func difference(from other: [Element]) -> [Element] {
		let thisSet = Set(self)
		let otherSet = Set(other)
		return Array(thisSet.symmetricDifference(otherSet))
	}
}
