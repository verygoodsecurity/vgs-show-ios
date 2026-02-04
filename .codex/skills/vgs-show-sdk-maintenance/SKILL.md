---
name: vgs-show-sdk-maintenance
description: Maintain VGSShowSDK core code and public API; use when editing Sources/VGSShowSDK, changing public types, or touching logging and analytics.
---

# VGS Show SDK Maintenance

## Overview
Maintain the core VGSShowSDK codebase with the AGENTS.md guardrails and deterministic test coverage.

## Workflow
1. Identify the module you are changing and confirm the public surface impact.
2. Review public API boundaries and deprecations before adding or renaming symbols.
3. Apply the security guardrails: no raw revealed data in logs, contentPath required before requests, and safe error mapping.
4. Update unit tests in Tests/VGSShowSDKTests and add fixtures as needed.
5. If public API or behavior changes, update demo app flows and regenerate docs.
6. Run the unit test suite and scan for new deprecations.

## References
- See references/modules.md for the SDK module map.
- See references/public-api.md for public surface rules and deprecation checks.
