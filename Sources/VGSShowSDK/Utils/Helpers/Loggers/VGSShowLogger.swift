//
//  VGSShowLogger.swift
//  VGSShowSDK
//

import Foundation

internal class VGSShowLogger {

	internal static func logRequest(_ request: URLRequest, payload: VGSRequestPayloadBody) {
		print("⬆️ VGSShowSDK request url: \(stringFromURL(request.url))")
		if let headers = request.allHTTPHeaderFields {
			print("⬆️ VGSShowSDK request headers: \(headers)")
		}
		if let payloadValue = payload.rawPayload {
			print("⬆️ VGSShowSDK request payload: \(payloadValue)")
		}
	}

	internal static func logErrorResponse(_ response: URLResponse?, data: Data?, error: Error?, code: Int) {
		if let url = response?.url {
			print("❗Failed ⬇️ VGSShowSDK request url: \(stringFromURL(url))")
		}
		print("❗Failed ⬇️ VGSShowSDK response status code: \(code)")
		if let httpResponse = response as? HTTPURLResponse {
			print("❗Failed ⬇️ VGSShowSDK response headers:")
			for erorHeader in httpResponse.allHeaderFields {
				print("\(erorHeader.key) : \(erorHeader.value)")
			}
		}
		if let errorData = data {
			if let bodyErrorText = String(data: errorData, encoding: String.Encoding.utf8) {
				print("❗Failed ⬇️ VGSShowSDK response extra info:")
				print("\(bodyErrorText)")
			}
		}

		// Track error.
		let errorMessage = (error as NSError?)?.localizedDescription ?? ""

		print("❗Failed ⬇️ VGSShowSDK response error message: \(errorMessage)")
	}

	internal static func logSuccessResponse(_ response: URLResponse?, data: Data?, code: Int, responseFormat: VGSShowResponseDecodingFormat) {
		print("✅ Success ⬇️ VGSShowSDK request url: \(stringFromURL(response?.url))")
		print("✅ Success ⬇️ VGSShowSDK response code: \(code)")

		if let httpResponse = response as? HTTPURLResponse {
			print("✅ Success ⬇️ VGSShowSDK response headers:")
			for erorHeader in httpResponse.allHeaderFields {
				print("\(erorHeader.key) : \(erorHeader.value)")
			}
		}

		if let rawData = data {
			switch responseFormat {
			case .json:
				if case .success(let json) = VGSShowRawDataDecoder().decodeRawDataToJSON(rawData) {
					print("✅ Success ⬇️ VGSShowSDK response JSON:")
					print(json)
				}
			}
		}
	}

	private static func stringFromURL(_ url: URL?) -> String {
		guard let requestURL = url else {return ""}
		return requestURL.absoluteString
	}
}
