//
//  VGSShow+Network.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

extension VGSShow {
  
  // MARK: - API Request
  
	/**
	Send request to reveal data on specific path. `VGSShow` instance will use all subsribed elements contentPaths to reveal data.

	- Parameters:
	- path: Inbound rout path for your organization vault.
	- method: HTTPMethod, default is `.post`.
	- payload: `VGSJSONData?` object, default is `nil`. Should be valid JSON.
	- completion: `VGSResponse` completion block. The completion handler to call when the load request is complete.

	- Note:
	Errors can be returned in the `NSURLErrorDomain` and `VGSShowSDKErrorDomain`.
	*/
	public func request(path: String, method: VGSHTTPMethod = .post, payload: VGSJSONData? = nil, completion block: @escaping (VGSShowRequestResult) -> Void) {

		// Content analytics.
		var extraAnalyticsInfo = [String: Any]()
		extraAnalyticsInfo["content"] = contentForAnalytics(from: payload)

		// Log warning if no subscribed views.
		if !hasViewModels {
			let event = VGSLogEvent(level: .warning, text: "No subscribed views to reveal data.", severityLevel: .warning)
			logEvent(event)
		}

		VGSAnalyticsClient.shared.trackFormEvent(self, type: .beforeSubmit, status: .success, extraData: extraAnalyticsInfo)

		// Sends request.

		let event = VGSLogEvent(level: .info, text: "Start json request")
		logEvent(event)

		apiClient.sendRequestWithJSON(path: path, method: method, value: payload ) {[weak self] (requestResult) in

			guard let strongSelf = self else {return}

			switch requestResult {
			case .success(let code, let data, let response):
				// Log success response.

				let responseFormat = VGSShowResponseDecodingFormat.json

				VGSShowRequestLogger.logSuccessResponse(response, data: data, code: code, responseFormat: responseFormat)

				strongSelf.handleSuccessResponse(code, data: data, response: response, responseFormat: responseFormat, revealModels: strongSelf.subscribedViewModels, extraAnalyticsInfo: extraAnalyticsInfo, completion: block)
			case .failure(let code, let data, let response, let error):
				VGSShowRequestLogger.logErrorResponse(response, data: data, error: error, code: code)

				// Track error.
				let errorMessage = (error as NSError?)?.localizedDescription ?? ""
				strongSelf.trackErrorEvent(with: code, message: errorMessage, type: .submit, extraInfo: extraAnalyticsInfo)

				block(.failure(code, error))
			}
		}
	}

	// MARK: - Private

	// swiftlint:disable:next function_parameter_count line_length
	private func handleSuccessResponse(_ code: Int, data: Data?, response: URLResponse?, responseFormat: VGSShowResponseDecodingFormat, revealModels: [VGSViewModelProtocol], extraAnalyticsInfo: [String: Any] = [:], completion block: @escaping (VGSShowRequestResult) -> Void) {

		if !revealModels.isEmpty {
			let contentPaths = revealModels.map({return $0.decodingContentPath})
			let infoMessage = "Start decoding revealed data for contentPaths:\n\(VGSShow.formatDecodingContentPaths(contentPaths))\n"
			let event = VGSLogEvent(level: .info, text: infoMessage)
			logEvent(event)
		}

		logRevealModelsWithoutContentPath(revealModels)

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

				let event = VGSLogEvent(level: .warning, text: "Cannot decode request response: \(error)", severityLevel: .error)
				logEvent(event)

				trackErrorEvent(with: error.code, message: nil, type: .submit, extraInfo: extraAnalyticsInfo)
				block(.failure(error.code, error))
			}
		}
	}

	private func revealDecodedResponse(_ json: VGSJSONData, code: Int, revealModels: [VGSViewModelProtocol], extraAnalyticsInfo: [String: Any] = [:], completion block: @escaping (VGSShowRequestResult) -> Void) {

		var unrevealedContentPaths = [String]()
		revealModels.forEach { model in
			// Reveal data.
			let decoder = VGSDataDecoderFactory.provideDecorder(for: model.decodingContentMode)
			let decodingResult = decoder.decodeJSONForContentPath(model.decodingContentPath, json: json)

			// Update models with decoding result.
			model.handleDecodingResult(decodingResult)

			// Collect unrevealed contentPaths.
			if decodingResult.error != nil {
				unrevealedContentPaths.append(model.decodingContentPath)
			}
		}

		if unrevealedContentPaths.isEmpty && !revealModels.isEmpty {
			let contentPaths = revealModels.map({return $0.decodingContentPath})
			let infoMessage = "All content paths have been successfully decoded:\n\(VGSShow.formatDecodingContentPaths(contentPaths))\n"
			let event = VGSLogEvent(level: .info, text: infoMessage)
			logEvent(event)
		}

		// Handle unrevealed keys.
		handleUnrevealedContentPaths(unrevealedContentPaths, code, completion: block)
	}

	private func handleUnrevealedContentPaths(_ unrevealedContentPaths: [String], _ code: Int, extraAnalyticsInfo: [String: Any] = [:], completion block: @escaping (VGSShowRequestResult) -> Void) {

		if !unrevealedContentPaths.isEmpty {
			let warningMessage = "Cannot reveal data for contentPaths:\n\(VGSShow.formatDecodingContentPaths(unrevealedContentPaths))\n"
			let event = VGSLogEvent(level: .warning, text: warningMessage, severityLevel: .warning)
			logEvent(event)
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
