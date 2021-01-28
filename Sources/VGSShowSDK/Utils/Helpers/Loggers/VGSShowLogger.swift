//
//  VGSShowLogger.swift
//  VGSShowSDK
//

import Foundation

internal class VGSShowLogger {

	internal static func logRequest(_ request: URLRequest, payload: VGSRequestPayloadBody) {
		print("⬆️ Send VGSShowSDK request url: \(stringFromURL(request.url))")
		if let headers = request.allHTTPHeaderFields {
			print("⬆️ Send VGSShowSDK request headers:")
			print(normalizeRequestHeadersForLogs(headers))
		}
		if let payloadValue = payload.rawPayload {
			print("⬆️ Send VGSShowSDK request payload:")
			print(stringifyRawRequestPayloadForLogs(payloadValue))
		}
	}

	internal static func logErrorResponse(_ response: URLResponse?, data: Data?, error: Error?, code: Int) {
		if let url = response?.url {
			print("❗Failed ⬇️ VGSShowSDK request url: \(stringFromURL(url))")
		}
		print("❗Failed ⬇️ VGSShowSDK response status code: \(code)")
		if let httpResponse = response as? HTTPURLResponse {
			print("❗Failed ⬇️ VGSShowSDK response headers:")
			print(normalizeHeadersForLogs(httpResponse.allHeaderFields))
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
			print(normalizeHeadersForLogs(httpResponse.allHeaderFields))
		}

		if let rawData = data {
			switch responseFormat {
			case .json:
				if case .success(let json) = VGSShowRawDataDecoder().decodeRawDataToJSON(rawData) {
					print("✅ Success ⬇️ VGSShowSDK response JSON:")
					print(stringifyJSONForLogs(json))
				}
			}
		}
	}

	private static func stringFromURL(_ url: URL?) -> String {
		guard let requestURL = url else {return ""}
		return requestURL.absoluteString
	}

	private static func normalizeRequestHeadersForLogs(_ headers: [String : String]) -> String {
		let stringifiedHeaders = headers.map({return "  \($0.key) : \($0.value)"}).joined(separator:"\n  ")

		return "[\n  \(stringifiedHeaders) \n]"
	}

	private static func normalizeHeadersForLogs(_ headers: [AnyHashable : Any]) -> String {
		let stringifiedHeaders = headers.map({return "  \($0.key) : \($0.value)"}).joined(separator:"\n  ")

		return "[\n  \(stringifiedHeaders) \n]"
	}

	private static func stringifyJSONForLogs(_ vgsJSON: VGSJSONData) -> String {
		if let json = try? JSONSerialization.data(withJSONObject: vgsJSON, options: .prettyPrinted) {
			return String(decoding: json, as: UTF8.self)
		} else {
				return ""
		}
	}

	private static func stringifyRawRequestPayloadForLogs(_ payload: Any) -> String {
		if let json = payload as? VGSJSONData {
			return stringifyJSONForLogs(json)
		}

		return ""
	}
}
