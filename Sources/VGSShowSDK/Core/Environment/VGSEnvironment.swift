//
//  VGSEnvironment.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Organization vault environment.
public enum VGSEnvironment: String {

	/// Should be used for development and testing purpose.
	case sandbox

	/// Should be used for production.
	case live
}
