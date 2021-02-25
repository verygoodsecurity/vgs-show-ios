//
//  APICustomHostStatus.swift
//  VGSShowSDK
//

import Foundation

/// Determinates hostname status states.
internal enum APICustomHostStatus {
	/**
	 Resolving host name is in progress.

	 - Parameters:
			- hostnameToResolve: `String` object, hostname to resolve.
	*/
	case isResolving(_ hostnameToResolve: String)

	/**
	 Hostname is resolved and can be used for requests.

	 - Parameters:
			- resolvedURL: `URL` object, resolved host name URL.
	*/
	case resolved(_ resolvedURL: URL)

	/**
	 Hostname cannot be resolved, default vault URL will be used.

	 - Parameters:
			- vaultURL: `URL` object, should be default vault URL.
	*/
	case useDefaultVault(_ vaultURL: URL)

	/// `URL` inferred from custom hostname status flow.
	internal var url: URL? {
		switch self {
		case .isResolving:
			return nil
		case .useDefaultVault(let defaultVaultURL):
			return defaultVaultURL
		case .resolved(let resolvedURL):
			return resolvedURL
		}
	}
}

// MARK: - CustomStringConvertible

extension APICustomHostStatus: CustomStringConvertible {

	  /// Custom description.
		var description: String {
			switch self {
			case .useDefaultVault(let url):
				return ".useDefaultVault, default Vault url: \(url.absoluteString)"
			case .resolved(let url):
			  return ".resolved, custom host url: \(url.absoluteString)"
			case .isResolving(let hostnameToResolve):
				return ".isResolving hostname in progress for \(hostnameToResolve)"
			}
		}
}
