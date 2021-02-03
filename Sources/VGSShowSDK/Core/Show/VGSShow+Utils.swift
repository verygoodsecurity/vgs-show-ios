//
//  VGSShow+Utils.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

internal extension VGSShow {
  /// Generates API String with environment and data region.
  class func generateRegionalEnvironmentString(_ environment: VGSEnvironment, region: String?) -> String {
    var environmentString = environment.rawValue
    if let region = region, !region.isEmpty {
        assert(Self.regionValid(region), "❗VGSShowSDK CONFIGURATION ERROR: REGION IS NOT VALID!!!")
				if !Self.regionValid(region) {
					let eventText = "CONFIGURATION ERROR: REGION STRING IS NOT VALID!!! region: \(region)"
					let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
					VGSLogger.shared.forwardLogEvent(event)
				}
        environmentString += "-" + region
    }
    return environmentString
  }
  
  /// Generates API URL with vault id, environment and data region.
  class func generateVaultURL(tenantId: String, regionalEnvironment: String) -> URL? {
		if !regionalEnironmentStringValid(regionalEnvironment) {
			assertionFailure("❗VGSShowSDK CONFIGURATION ERROR: ENVIRONMENT STRING IS NOT VALID!!!")
			let eventText = "CONFIGURATION ERROR: ENVIRONMENT STRING IS NOT VALID!!! region \(regionalEnvironment)"
			let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
			VGSLogger.shared.forwardLogEvent(event)
			return nil
		}

		if !tenantIDValid(tenantId) {
			assertionFailure("❗VGSShowSDK CONFIGURATION ERROR: TENANT ID IS NOT VALID!!!")

			let eventText = "CONFIGURATION ERROR: TENANT ID IS NOT VALID OR NOT SET!!! tenant: \(tenantId)"
			let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
			VGSLogger.shared.forwardLogEvent(event)

			return nil
		}

		let strUrl = "https://" + tenantId + "." + regionalEnvironment + ".verygoodproxy.com"

		guard let url = URL(string: strUrl) else {
			assertionFailure("❗VGSShowSDK CONFIGURATION ERROR: NOT VALID ORGANIZATION PARAMETERS!!!")

			let eventText = "CONFIGURATION ERROR: NOT VALID ORGANIZATION PARAMETERS!!! tenantID: \(tenantId), environment: \(regionalEnvironment)"
			let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
			VGSLogger.shared.forwardLogEvent(event)

			return nil
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
