//
//  VGSShow+Utils.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

extension VGSShow {
  /// Generates API String with environment and data region.
  class func generateRegionalEnvironmentString(_ environment: Environment, region: String?) -> String {
    var environmentString = environment.rawValue
    if let region = region, !region.isEmpty {
        assert(Self.regionValid(region), "ERROR: REGION IS NOT VALID!!!")
        environmentString += "-" + region
    }
    return environmentString
  }
  
  /// Generates API URL with vault id, environment and data region.
  class func generateVaultURL(tenantId: String, regionalEnvironment: String) -> URL {
      assert(Self.regionalEnironmentStringValid(regionalEnvironment), "ENVIRONMENT STRIN IS NOT VALID!!!")
      assert(Self.tenantIDValid(tenantId), "ERROR: TENANT ID IS NOT VALID!!!")
    
      let strUrl = "https://" + tenantId + "." + regionalEnvironment + ".verygoodproxy.com"
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
  
  /// Validate string representing environment and data region
  class func regionalEnironmentStringValid(_ enironment: String) -> Bool {
    return !enironment.isEmpty && NSPredicate(format: "SELF MATCHES %@", "^(live|sandbox|LIVE|SANDBOX)+((-)+([a-zA-Z0-9]+)|)+\\d*$").evaluate(with: enironment)
  }
}
