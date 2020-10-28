//
//  Dictionary+Extensions.swift
//  VGSShow
//
//  Created by Eugene on 28.10.2020.
//

import Foundation

extension JsonData {
	/// Geneeric function. Returns value of specified type by keyPath.
	/// - Parameter keyPath: `String` keyPath.
	/// - Returns: Object of type `T` if found or nil.
	public func valueForKeyPath<T>(keyPath: String) -> T? {
		return (self as NSDictionary).value(forKeyPath: keyPath) as? T
	}
}
