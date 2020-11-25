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

		// Don't send request if no subscibed views.
		guard hasViewModels else {
			let error = VGSShowError(type: .noSubscribedViewsInShow)

			// Track error.
			trackErrorEvent(with: error.code, type: .beforeSubmit, extraInfo: extraAnalyticsInfo)

			block(.failure(error.code, error))
			return
		}

		// Sends request.
		apiClient.sendRequest(path: path, method: method, value: payload ) {[weak self] (requestResult) in

			guard let strongSelf = self else {return}

			switch requestResult {
			case .success(let code, let data, let response):
				strongSelf.handleSuccessResponse(code, data: data, response: response, responseFormat: responseFormat, revealModels: strongSelf.subscribedViewModels, extraAnalyticsInfo: extraAnalyticsInfo, completion: block)
			case .failure(let code, _, _, let error):

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
		var unrevealedKeyPaths = [String]()
		revealModels.forEach { model in

			// Decode data.
			let decoder = VGSDataDecoderFactory.provideDecorder(for: model.decodingContentMode)
			let decodingResult = decoder.decodeDataForKeyPath(model.decodingKeyPath, responseFormat: responseFormat, data: data)

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
		// If not all data revealed send error to user.
		if !unrevealedKeyPaths.isEmpty {
			print(unrevealedKeyPaths)
			let userInfo = VGSErrorInfo(key: VGSSDKErrorDataPartiallyDecoded, description: "Not all data decoded.", extraInfo: ["not_decoded_fields": unrevealedKeyPaths])
			let error = VGSShowError.init(type: .dataPartiallyDecoded, userInfo: userInfo)

			trackErrorEvent(with: error.code, message: nil, type: .submit, extraInfo: extraAnalyticsInfo)

			block(.failure(code, error))
		} else {

			// Track success.
			VGSAnalyticsClient.shared.trackFormEvent(self, type: .submit, status: .success, extraData: extraAnalyticsInfo)

			block(.success(code))
		}
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
