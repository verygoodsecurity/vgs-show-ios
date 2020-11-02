//
//  Environment.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

/// Organization vault environment.
public enum Environment {

	/// Should be used for development and testing purpose.
	case sandbox

	/// Should be used for production.
	case live(region: String? = nil)

	var path: String {
		switch self {
		case .sandbox:
			return "sandbox"
		case .live(let region):
			if region == nil {
				return "live"
			}
			
			guard let regionName = region, !regionName.isEmpty, VGSShow.regionValid(regionName) else {
				fatalError("ERROR! REGION IS NOT VALID!!!")
			}

			return "live-\(regionName)"
		}
	}

	var region: String? {
		switch self {
		case .sandbox:
			return nil
		case .live(let region):
			return region
		}
	}
}
