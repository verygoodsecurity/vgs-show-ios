//
//  VGSShow+Utils.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

extension VGSShow {
	class func generateVaultURL(tenantId: String, environment: Environment) -> URL {

		let environmentString = environment.path

		assert(Self.tenantIDValid(tenantId), "ERROR: TENANT ID IS NOT VALID!!!")

		let strUrl = "https://" + tenantId + "." + environmentString + ".verygoodproxy.com"
		guard let url = URL(string: strUrl) else {
			fatalError("ERROR: NOT VALID ORGANIZATION PARAMETERS!!!")
		}
		return url
	  }

	/// Validate tenant id
	class func tenantIDValid(_ tenantId: String) -> Bool {
		return tenantId.isAlphaNumeric
	}

  /// Validate data region id
	class func regionValid(_ region: String) -> Bool {
	  return !region.isEmpty && region.range(of: ".*[^a-zA-Z0-9-].*", options: .regularExpression) == nil
	}
}
