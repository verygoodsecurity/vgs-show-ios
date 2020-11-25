//
//  UIDevice+Extensions.swift
//  VGSShow
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal extension UIDevice {

	/// Device model identifier.
	var modelIdentifier: String {
		if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
		var sysinfo = utsname()
		uname(&sysinfo) // ignore return value
		return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters) ?? "unknown"
	}
}
