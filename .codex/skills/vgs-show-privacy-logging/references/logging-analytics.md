# Logging and Analytics

Logging:
- Use VGSLogger.shared.configuration.level = .warning or .none in production.
- Keep isNetworkDebugEnabled and isExtensiveDebugEnabled set to false.
- Never log raw revealed values, base64 data, or header values.

Analytics:
- Use VGSAnalyticsClient.shared.shouldCollectAnalytics to opt out.
- Do not alter analytics payloads.
