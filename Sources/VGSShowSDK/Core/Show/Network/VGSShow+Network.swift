//
//  VGSShow+Network.swift
//  VGSShow
//
//  Created by Eugene on 26.10.2020.
//

import Foundation

extension VGSShow {

  // MARK: - API Request

    /// Sends a reveal request to your VGS vault and distributes the response data to all subscribed views.
    ///
    /// This method executes a network request to the specified path on your vault, decodes the JSON response,
    /// and automatically routes values to subscribed views based on their `contentPath` properties. All subscribed
    /// views are updated in a single batched operation, making this the most efficient way to reveal multiple
    /// pieces of data simultaneously.
    ///
    /// - Parameters:
    ///   - path: The API endpoint path on your vault for reveal operations (e.g., `"/reveal"`, `"/tokens/reveal"`).
    ///           This path is appended to your vault's base URL.
    ///   - method: The HTTP method to use for the request. Default is `.post`. Supported values include `.post`,
    ///             `.get`, `.put`, `.patch`, and `.delete`.
    ///   - payload: Optional JSON payload to send with the request. Must be a valid JSON-serializable dictionary
    ///              (e.g., `["token_ids": ["tok_123", "tok_456"]]`). Default is `nil`.
    ///   - requestOptions: Optional configuration for request behavior, such as timeout intervals. Pass a
    ///                     configured `VGSShowRequestOptions` instance to customize request settings. Default is `nil`.
    ///   - block: A completion handler called when the request finishes. Receives a `VGSShowRequestResult` indicating
    ///            success or failure with associated data.
    ///
    /// ## Completion Handler
    ///
    /// The completion block receives a `VGSShowRequestResult` with two cases:
    ///
    /// - `.success(code)`: The request succeeded. `code` is the HTTP status code (typically 200). Subscribed views
    ///   have been automatically updated with their respective data.
    ///
    /// - `.failure(code, error)`: The request failed. `code` is the HTTP status code (or 0 for network errors).
    ///   `error` contains details about the failure (see `VGSShowError` for error types).
    ///
    /// ## Examples
    ///
    /// ### Basic Reveal Request
    ///
    /// ```swift
    /// let show = VGSShow(id: "vault_id", environment: .sandbox)
    ///
    /// let emailLabel = VGSLabel()
    /// emailLabel.contentPath = "user.email"
    /// show.subscribe(emailLabel)
    ///
    /// show.request(path: "/reveal") { result in
    ///     switch result {
    ///     case .success(let statusCode):
    ///         print("Data revealed successfully: \(statusCode)")
    ///     case .failure(let statusCode, let error):
    ///         print("Reveal failed: \(error?.localizedDescription ?? "Unknown error")")
    ///     }
    /// }
    ///
    ///
    /// ## Behavior and Best Practices
    ///
    /// - **Content Path Matching**: Each subscribed view's `contentPath` must match a key in the JSON response.
    ///   Mismatched paths trigger warnings and per-view delegate error callbacks, but the overall request may still succeed.
    ///
    /// - **No Subscribed Views**: If no views are subscribed when calling this method, a warning is logged. Ensure at least
    ///   one view is subscribed before making a request.
    ///
    /// - **Batch Updates**: All views are updated atomically after the response is decoded. There's no need to make
    ///   separate requests for each view.
    ///
    /// - **Error Handling**: Network errors, JSON decoding errors, and field-specific errors are all reported through
    ///   the completion handler. Individual view delegates may also receive error callbacks for view-specific issues.
    ///
    /// - **Thread Safety**: The completion block is always called on the main thread, making it safe to update UI directly.
    ///
    /// ## Error Domains and Types
    ///
    /// Errors returned in the completion handler may belong to:
    ///
    /// - `NSURLErrorDomain`: Standard network errors (timeout, no connection, etc.)
    /// - `VGSShowSDKErrorDomain`: SDK-specific errors via `VGSShowError` (see `VGSErrorType` for error codes)
    ///
    /// Common error types include:
    /// - `.fieldNotFound`: A view's `contentPath` doesn't exist in the response JSON
    /// - `.invalidBase64Data`: Image or PDF data is corrupted
    /// - `.responseIsInvalidJSON`: Response is not valid JSON
    ///
    /// - Important: Ensure all subscribed views have non-empty `contentPath` values before calling this method.
    ///              Empty paths will generate warnings and the views will not receive data.
    ///
    /// - Warning: Never log or persist the raw revealed data from views. The SDK manages sensitive data securely
    ///            within UI components. Only metadata (such as content lengths or boolean flags) should be logged.
    ///
    /// - Note: Custom headers set via the `customHeaders` property are automatically included in the request.
    ///
    /// - SeeAlso: `VGSShowRequestResult`, `VGSShowError`, `VGSShowRequestOptions`, `subscribe(_:)`
    public func request(path: String, method: VGSHTTPMethod = .post, payload: VGSJSONData? = nil, requestOptions: VGSShowRequestOptions? = nil, completion block: @escaping (VGSShowRequestResult) -> Void) {

        // Content analytics.
        var extraAnalyticsInfo = [String: Any]()

        var analyticsData = contentForAnalytics(from: payload)
        for viewTypeName in viewTypeAnalyticsNames {
            analyticsData.append(viewTypeName)
        }

        extraAnalyticsInfo["content"] = analyticsData

        // Log warning if no subscribed views.
        if !hasViewModels {
            let event = VGSLogEvent(level: .warning, text: "No subscribed views to reveal data.", severityLevel: .warning)
            logEvent(event)
        }

        VGSAnalyticsClient.shared.trackFormEvent(self, type: .beforeSubmit, status: .success, extraData: extraAnalyticsInfo)

        // Sends request.

        let event = VGSLogEvent(level: .info, text: "Start json request")
        logEvent(event)

        apiClient.sendRequestWithJSON(path: path, method: method, value: payload, requestOptions: requestOptions) {[weak self] (requestResult) in

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
            if let decoder = VGSDataDecoderFactory.provideJSONDecorder(for: model.decodingContentMode) {
                let decodingResult = decoder.decodeJSONForContentPath(model.decodingContentPath, json: json)

                // Update models with decoding result.
                model.handleDecodingResult(decodingResult)

                // Collect unrevealed contentPaths.
                if decodingResult.error != nil {
                    unrevealedContentPaths.append(model.decodingContentPath)
                }
            } else {
                // Log! Cannot provide JSON decoder for model!
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

        switch apiClient.hostURLPolicy {
        case .customHostURL(let status):
            switch status {
            case .resolved, .isResolving:
                content.append("custom_hostname")
            default:
                break
            }
        default:
            break
        }

        return content
    }
}
