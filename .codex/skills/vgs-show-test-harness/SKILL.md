---
name: vgs-show-test-harness
description: Add or update VGSShowSDK unit tests; use when touching Tests/VGSShowSDKTests, JSON fixtures, or decoding and masking behavior.
---

# VGS Show Test Harness

## Overview
Add deterministic unit tests for SDK behavior without storing or logging raw revealed data.

## Workflow
1. Choose the unit test target under Tests/VGSShowSDKTests; use vgs-show-ui-tests for UI tests.
2. Locate the nearest suite for the behavior you are testing and follow existing patterns.
3. Load JSON fixtures from Tests/VGSShowSDKTests/Resources/JSONs using the bundle helper.
4. Use synthetic data only and assert on metadata such as lengths and flags.
5. Add new fixtures to the resources folder and update the bundle helper.
6. Keep tests deterministic and offline.

## References
- See references/tests-structure.md for the test suite map.
- See references/fixtures.md for JSON fixture rules.
- See references/helpers.md for bundle loader usage.
