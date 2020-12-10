//
//  VGSShowLogger.swift
//  VGSShowSDK
//

import Foundation

internal class VGSShowLogger {

	internal static func logRequest(_ request: URLRequest, payload: APIClient.PayloadType) {
		print("⬆️ VGSShowSDK request url: \(request.url?.absoluteString)")
		if let headers = request.allHTTPHeaderFields {
			print("⬆️ VGSShowSDK request headers: \(headers)")
		}
		if let payloadValue = payload.rawPayload {
			print("⬆️ VGSShowSDK request payload: \(payloadValue)")
		}
	}

	internal static func logErrorResponse(_ response: URLResponse?, data: Data?, error: Error?, code: Int) {
		print("⬇️❗VGSShowSDK request failed: url: \(response?.url?.absoluteString)")
		print("⬇️❗VGSShowSDK request failed: status code: \(code)")
		if let httpResponse = response as? HTTPURLResponse {
			print("⬇️❗VGSShowSDK request failed: headers:")
			for erorHeader in httpResponse.allHeaderFields {
				print("\(erorHeader.key) : \(erorHeader.value)")
			}
		}
		if let errorData = data {
			if let bodyErrorText = String(data: errorData, encoding: String.Encoding.utf8) {
				print("⬇️❗VGSShowSDK request failed, extra info:")
				print("\(bodyErrorText)")
			}
		}

		// Track error.
		let errorMessage = (error as NSError?)?.localizedDescription ?? ""

		print("⬇️❗VGSShowSDK response error message: \(errorMessage)")
	}

	internal static func logSuccessResponse(_ response: URLResponse?, data: Data?, code: Int, responseFormat: VGSShowResponseDecodingFormat) {
		print("⬇️ ✅  VGSShowSDK request success, url: \(response?.url?.absoluteString)")
		print("⬇️ ✅ VGSShowSDK request success, code: \(code)")

		if let httpResponse = response as? HTTPURLResponse {
			print("⬇️ ✅ VGSShowSDK request success: headers:")
			for erorHeader in httpResponse.allHeaderFields {
				print("\(erorHeader.key) : \(erorHeader.value)")
			}
		}

		if let rawData = data {
			switch responseFormat {
			case .json:
				if case .success(let json) = VGSShowRawDataDecoder().decodeRawDataToJSON(rawData) {
					print("⬇️ ✅ VGSShowSDK request success: response:")
					print(json)
				}
			}
		}
	}
}
