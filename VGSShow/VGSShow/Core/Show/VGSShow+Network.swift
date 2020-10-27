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
	public func request(path: String, method: HTTPMethod = .post, payload: [String: Any]? = nil, vgsShowType: VGSShowDataType, jsonSelector: String, completion block: @escaping (VGSRequestResult) -> Void) {

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
				switch vgsShowType {
				case .text:
					let result = VGSShowJSONSerializer.serializeDataByPath(jsonSelector, data: data, showDataType: vgsShowType)
					switch result {
					case .success(let showData):
						block(.success(code, showData))

					case .failure(let error):
						block(.failure(code, error))
					}
				case .imageURL:
					fatalError("not implemented")
				}
			case .failure(let code, let data, let response, let error):
				block(.failure(code, error))
			}
		}
	}
}
