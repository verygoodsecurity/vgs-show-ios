//
//  VGSShow+Network.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

extension VGSShow {
	/**
	Send request to reveal data on specific path. `VGSShow` instance will use all subsribed elements keyPaths to reveal data.

	- Parameters:
	- path: Inbound rout path for your organization vault.
	- method: HTTPMethod, default is `.post`.
	- payload: `VGSJSONData` object, default is `nil`.
	- responseFormat: `VGSResponseDecodingFormat` object. Response data decoding format, default is `.json`.
	- completion: `VGSResponse` completion block. The completion handler to call when the load request is complete.

	- Note:
	Errors can be returned in the `NSURLErrorDomain` and `VGSShowSDKErrorDomain`.
	*/
	public func request(path: String, method: VGSHTTPMethod = .post, payload: VGSJSONData? = nil, responseFormat: VGSShowResponseDecodingFormat = .json, completion block: @escaping (VGSShowRequestResult) -> Void) {

		// Content analytics.
		var extraAnalyticsInfo = [String: Any]()
		extraAnalyticsInfo["content"] = contentForAnalytics(from: payload)

		// Log warning if no subscribed views.
		if !hasViewModels {
			print("⚠️ VGSShowSDK WARNING! NO SUBSCRIBED VIEWS TO REVEAL DATA!")
		}

		// Sends request.
		apiClient.sendRequest(path: path, method: method, value: payload ) {[weak self] (requestResult) in

			guard let strongSelf = self else {return}

			switch requestResult {
			case .success(let code, let data, let response):
				strongSelf.handleSuccessResponse(code, data: data, response: response, responseFormat: responseFormat, revealModels: strongSelf.subscribedViewModels, extraAnalyticsInfo: extraAnalyticsInfo, completion: block)
			case .failure(let code, let data, let response, let error):
				print("❗VGSShowSDK response error status code: \(code)")
				if let httpResponse = response as? HTTPURLResponse {
					print("❗VGSShowSDK response error headers:")
					for erorHeader in httpResponse.allHeaderFields {
						print("\(erorHeader.key) : \(erorHeader.value)")
					}
				}
				if let errorData = data {
					if let bodyErrorText = String(data: errorData, encoding: String.Encoding.utf8) {
						print("❗VGSShowSDK response error: info:")
						print("\(bodyErrorText)")
					}
				}

				// Track error.
				let errorMessage = (error as NSError?)?.localizedDescription ?? ""

				print("❗VGSShowSDK response error message: \(errorMessage)")

				strongSelf.trackErrorEvent(with: code, message: errorMessage, type: .submit, extraInfo: extraAnalyticsInfo)

				block(.failure(code, error))
			}
		}
	}

	// MARK: - Private

	// swiftlint:disable:next function_parameter_count line_length
	private func handleSuccessResponse(_ code: Int, data: Data?, response: URLResponse?, responseFormat: VGSShowResponseDecodingFormat, revealModels: [VGSViewModelProtocol], extraAnalyticsInfo: [String: Any] = [:], completion block: @escaping (VGSShowRequestResult) -> Void) {

		switch responseFormat {

		// Handle `.json` response format.
		case .json:
			// Try to decode raw data to JSON.
			let jsonDecodingResult = VGSShowRawDataDecoder().decodeRawDataToJSON(data)
			switch jsonDecodingResult {
			case .success(let json):
				// Reveal data.
				revealDecodedResponse(json, code: code, revealModels: revealModels, extraAnalyticsInfo: extraAnalyticsInfo, completion: block)

			case .failure(let error):
				// Mark reveal request as failed with error - cannot decode response.
				print("❗VGSShowSDK decoding error \(error)")
				trackErrorEvent(with: error.code, message: nil, type: .submit, extraInfo: extraAnalyticsInfo)
				block(.failure(error.code, error))
			}
		}
	}

	private func revealDecodedResponse(_ json: VGSJSONData, code: Int, revealModels: [VGSViewModelProtocol], extraAnalyticsInfo: [String: Any] = [:], completion block: @escaping (VGSShowRequestResult) -> Void) {

		var unrevealedKeyPaths = [String]()
		revealModels.forEach { model in
			// Reveal data.
			let decoder = VGSDataDecoderFactory.provideDecorder(for: model.decodingContentMode)
			let decodingResult = decoder.decodeJSONForKeyPath(model.decodingKeyPath, json: json)

			// Update models with decoding result.
			model.handleDecodingResult(decodingResult)

			// Collect unrevealed keyPaths.
			if decodingResult.error != nil {
				unrevealedKeyPaths.append(model.decodingKeyPath)
			}
		}
		// Handle unrevealed keys.
		handleUnrevealedKeypaths(unrevealedKeyPaths, code, completion: block)
	}

	private func handleUnrevealedKeypaths(_ unrevealedKeyPaths: [String], _ code: Int, extraAnalyticsInfo: [String: Any] = [:], completion block: @escaping (VGSShowRequestResult) -> Void) {

		if !unrevealedKeyPaths.isEmpty {
			print("⚠️ VGSShowSDK WARNING! Cannot reveal data for fields: \(unrevealedKeyPaths)")
		}

		// Track success.
		VGSAnalyticsClient.shared.trackFormEvent(self, type: .submit, status: .success, extraData: extraAnalyticsInfo)

		block(.success(code))
	}

	/// Track error event.
	/// - Parameters:
	///   - code: `Int` object, error code.
	///   - message: `String` object, error message. Defaule is `nil`.
	///   - type: `VGSAnalyticsEventType` object, event type.
	///   - extraInfo: `[String: Any]` object, extra info.
	private func trackErrorEvent(with code: Int, message: String? = nil, type: VGSAnalyticsEventType, extraInfo: [String: Any] = [:]) {

		var extraAnalyticsData = [String: Any]()
		extraAnalyticsData["statusCode"] = code
		if message != nil {
			extraAnalyticsData["error"] = message
		}
		let extraData = deepMerge(extraAnalyticsData, extraInfo)
		VGSAnalyticsClient.shared.trackFormEvent(self, type: .submit, status: .failed, extraData: extraData)
	}

	/// Custom content for analytics from headers and payload.
	/// - Parameter payload: `[String: Any]` payload object.
	/// - Returns: `[String]` object.
	private func contentForAnalytics(from payload: [String: Any]?) -> [String] {
		var content: [String] = []
		if !(payload?.isEmpty ?? true) {
			content.append("custom_data")
		}
		if !(customHeaders?.isEmpty ?? true) {
			content.append("custom_header")
		}

		return content
	}
}
