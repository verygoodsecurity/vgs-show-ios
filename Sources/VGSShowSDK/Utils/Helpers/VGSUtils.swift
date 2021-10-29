//
//  VGSUtils.swift
//  VGSShow
//

import Foundation

/// Merge two  <key:value> objects and their nested values. Returns [String: Any]. Values in d2 will override values in d1 if keys are same!!!!
func deepMerge(_ d1: [String: Any], _ d2: [String: Any]) -> [String: Any] {
    var result = d1
    for (k2, v2) in d2 {
        if let v2 = v2 as? [String: Any], let v1 = result[k2] as? [String: Any] {
            result[k2] = deepMerge(v1, v2)
        } else {
            result[k2] = v2
        }
    }
    return result
}

internal class Utils {

  /// VGS Show SDK Version.
	/// Necessary since SPM doesn't track info plist correctly: https://forums.swift.org/t/add-info-plist-on-spm-bundle/40274/5
	static let vgsShowVersion = "1.1.2"
}
