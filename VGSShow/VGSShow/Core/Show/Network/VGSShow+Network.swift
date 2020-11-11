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
	- payload: `JsonData` object, default is `nil`.
	- responseFormat: `VGSResponseDecodingFormat` object. Response data decoding format, default is `.json`.
	- completion: `VGSResponse` completion block. The completion handler to call when the load request is complete.

	- Note:
	Errors can be returned in the `NSURLErrorDomain` and `VGSCollectSDKErrorDomain`.
	*/
	public func request(path: String, method: HTTPMethod = .post, payload: JsonData? = nil, responseFormat: VGSShowResponseDecodingFormat = .json, completion block: @escaping (VGSShowRequestResult) -> Void) {

		/// content analytics
		//		var content: [String] = []
		//		if !(payload?.isEmpty ?? true) {
		//			content.append("custom_data")
		//		}
		//		if !(customHeaders?.isEmpty ?? true) {
		//			content.append("custom_header")
		//		}

		// send request

		guard hasViewModels else {
			let error = VGSShowError(type: .noRegisteredElementsInShow)
			block(.failure(error.code, error))
			return
		}

		apiClient.sendRequest(path: path, method: method, value: payload ) { (requestResult) in

			switch requestResult {
			case .success(let code, let data, let response):
				self.handleSuccessResponse(code, data: data, response: response, responseFormat: responseFormat, revealModels: self.subscribedViewModels, completion: block)
			case .failure(let code, let data, let response, let error):
				block(.failure(code, error))
			}
		}
	}

	// MARK: - Private

	private func handleSuccessResponse(_ code: Int, data: Data?, response: URLResponse?, responseFormat: VGSShowResponseDecodingFormat, revealModels: [VGSViewModelProtocol], completion block: @escaping (VGSShowRequestResult) -> Void ) {
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

		// If not all data revealed send error to user.
		if !unrevealedKeyPaths.isEmpty {
			print(unrevealedKeyPaths)
			let userInfo = VGSErrorInfo(key: VGSSDKErrorDataPartiallyDecoded, description: "Not all data decoded.", extraInfo: ["not_decoded_fields": unrevealedKeyPaths])
			let error = VGSShowError.init(type: .dataPartiallyDecoded, userInfo: userInfo)
			block(.failure(code, error))
		} else {
			block(.success(code))
		}
	}
}
