//
//  APIHostnameValidator.swift
//  VGSShowSDK
//
//  Created by Dima on 03.12.2020.
//

import Foundation

internal class APIHostnameValidator {

	/// Base validation URL.
  private static let hostValidatorBaseURL = URL(string: "https://js.verygoodvault.com/collect-configs")!

  /// URLSession object.
	static private var session = URLSession(configuration: .ephemeral)

	/// Validate custom hostname.
	/// - Parameters:
	///   - hostname: `String` object, hostname to validate.
	///   - tenantId: `String` object, tenant id.
	///   - completion: `((URL?) -> Void)` completion block.
  internal static func validateCustomHostname(_ hostname: String, tenantId: String, completion: @escaping ((URL?) -> Void)) {

    guard !hostname.isEmpty else {
      completion(nil)
      return
    }

    guard let url = buildHostValidationURL(with: hostname, tenantId: tenantId), let normalizedHostName = hostname.normalizedHostname() else {
			print("❗VGSShowSDK Error! Cannot build validation URL with tenantId: \(tenantId), hostname: \(hostname)")
			completion(nil)
			return
		}

		performHostnameValidationRequest(with: hostname, normalizedHostName: normalizedHostName, validationURL: url, completion: completion)
  }

	/// Perform hostname validation request.
	/// - Parameters:
	///   - hostname: `String` object, hostname to validate.
	///   - normalizedHostName: `String` object, normalized hostname.
	///   - validationURL: `URL` object, validation URL.
	///   - completion:`((URL?) -> Void)` completion block.
	private static func performHostnameValidationRequest(with hostname: String, normalizedHostName: String, validationURL: URL, completion: @escaping ((URL?) -> Void)) {
		let task = URLRequest(url: validationURL)
		session.dataTask(with: task) { (responseData, response, error) in
			guard let httpResponse = response as? HTTPURLResponse, let data = responseData else {
				print("❗VGSShowSDK Error! Cannot resolve hostname \(hostname). Invalid response type!")
				completion(nil)
				return
			}

			if let error = error as NSError? {
				print("❗VGSShowSDK Error! Cannot resolve hostname \(hostname) Error: \(error)!")
				completion(nil)
				return
			}

			let statusCode = httpResponse.statusCode

			guard APIClient.Constants.validStatuses.contains(statusCode) else {
				logErrorForStatusCode(statusCode, hostname: hostname)
				completion(nil)
				return
			}

			let responseText = String(decoding: data, as: UTF8.self)
			print("response text: \(responseText)")

			if responseText.contains(normalizedHostName) {
				completion(URL(string: responseText))
				return
			} else {
				print("❗VGSShowSDK Error! sCannot find hostname: \(hostname) in list: \(responseText)")
				completion(nil)
				return
			}
		}.resume()
	}

	/// Log error for status code.
	/// - Parameters:
	///   - statusCode: `Int` object. Status code error.
	///   - hostname: `String` object, hostname.
	private static func logErrorForStatusCode(_ statusCode: Int, hostname: String) {
		switch statusCode {
		case 403:
			let warningText = "❗A specified host: \(hostname) was not correct. Looks like you don't activate cname for Collect SDK on the Dashboard"
			print(warningText)
		default:
			print("❗VGSShowSDK Error! Cannot resolve hostname \(hostname). Status code \(statusCode)")
		}
	}

	/// Build hostname validation URL.
	/// - Parameters:
	///   - hostname: `String` object, custom hostname.
	///   - tenantId: `String` object, tenant id.
	/// - Returns: `URL?` object.
  internal static func buildHostValidationURL(with hostname: String, tenantId: String) -> URL? {

    guard let normalizedHostname = hostname.normalizedHostname() else {return nil}

    let hostPath = "\(normalizedHostname)__\(tenantId).txt"

    let  url = hostValidatorBaseURL.appendingPathComponent(hostPath)
    print("final url: \(url)")
    return url
  }
}
