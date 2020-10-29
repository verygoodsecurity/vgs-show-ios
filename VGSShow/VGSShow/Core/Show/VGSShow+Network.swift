//
//  VGSShow+Network.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

extension VGSShow {
	/**
	Fetch text content.

	- Parameters:
	- path: Inbound rout path for your organization vault.
	- method: HTTPMethod, default is `.post`.
	- payload: Request payload , default is `nil`.
	- jsonSelector: `String` object. Keypath to desired value.
	- completion: response completion block, returns `VGSResponse`.

	- Note:
	Errors can be returned in the `NSURLErrorDomain` and `VGSCollectSDKErrorDomain`.
	*/
	public func request(path: String, method: HTTPMethod = .post, payload: JsonData? = nil, revealModels: [VGSShowRevealModel], completion block: @escaping (VGSRequestResult) -> Void) {

		/// content analytics
		//		var content: [String] = []
		//		if !(payload?.isEmpty ?? true) {
		//			content.append("custom_data")
		//		}
		//		if !(customHeaders?.isEmpty ?? true) {
		//			content.append("custom_header")
		//		}

		// send request
		apiClient.sendRequest(path: path, method: method, value: payload) { (requestResult) in

			switch requestResult {
			case .success(let code, let data, let response):
				self.handleSuccessResponse(code, data: data, response: response, revealModels: revealModels, completion: block)
			case .failure(let code, let data, let response, let error):
				block(.failure(code, error))
			}
		}
	}

	// MARK: - Private

	private func handleSuccessResponse(_ code: Int, data: Data?, response: URLResponse?, revealModels: [VGSShowRevealModel], completion block: @escaping (VGSRequestResult) -> Void ) {

		var revealedData = [VGSJSONKeyPath: VGSShowResultData]()
		for model in revealModels {
			let jsonKeyPath = model.jsonKeyPath
			let decoder = VGSDataDecoderFactory.provideDecorder(for: model.decoder)
			let decodedResult = decoder.decodeDataPyPath(jsonKeyPath, data: data)
			switch decodedResult {
			case .success(let decodedData):
				revealedData[jsonKeyPath] = decodedData
			case .failure(let error):
				print("failed to decode data for path: \(jsonKeyPath) with error: \(error)")
			}
		}

		// Send error if smth not decoded.
		if revealedData.count != revealModels.count {
			let allJSONKeyPaths: [String] = revealModels.map({return $0.jsonKeyPath})
			let revealedJSONKeyPaths: [String] = revealedData.map({return $0.key})

			let unrevealedKeyPaths = allJSONKeyPaths.difference(from: revealedJSONKeyPaths)
			print("unrevealedKeyPaths: \(unrevealedKeyPaths)")

			let userInfo = VGSErrorInfo(key: VGSSDKErrorDataPartiallyDecoded, description: "Not all data decoded.", extraInfo: ["not decoded fields": unrevealedKeyPaths])
			let error = VGSShowError.init(type: .dataPartiallyDecoded, userInfo: userInfo)
			block(.failure(code, error))
		} else {
			block(.success(code, revealedData))
		}
	}
}
