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
	- completion: response completion block, returns `VGSResponse`.

	- Note:
	Errors can be returned in the `NSURLErrorDomain` and `VGSCollectSDKErrorDomain`.
	*/
	public func request(path: String, method: HTTPMethod = .post, payload: [String: Any]? = nil, completion block: @escaping (VGSRequestResult) -> Void) {

		/// content analytics
		var content: [String] = []
		if !(payload?.isEmpty ?? true) {
			content.append("custom_data")
		}
		if !(customHeaders?.isEmpty ?? true) {
			content.append("custom_header")
		}

		let body = [String: AnyObject]()

		// send request
		apiClient.sendRequest(path: path, method: method, value: body) {(response ) in
			block(response)
		}
	}
}
