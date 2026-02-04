---
name: vgs-show-privacy-logging
description: Audit privacy manifest, logging, and analytics; use when touching VGSLogger, VGSAnalyticsClient, or PrivacyInfo.xcprivacy.
---

# VGS Show Privacy and Logging

## Overview
Keep logging, analytics, and privacy manifest changes compliant with the SDK security rules.

## Workflow
1. Confirm VGSLogger configuration stays at warning or none in production and debug flags remain off.
2. Ensure no raw revealed data or base64 blobs reach logs or analytics.
3. Validate analytics uses only the opt-out toggle and does not mutate payloads.
4. Review PrivacyInfo.xcprivacy when adding any new data access or API usage.
5. Add or update tests to enforce masking and safe error messaging.

## References
- See references/logging-analytics.md for allowed logging and analytics patterns.
- See references/privacy-manifest.md for the privacy manifest location and usage.
