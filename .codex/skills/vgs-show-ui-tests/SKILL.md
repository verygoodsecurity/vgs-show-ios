---
name: vgs-show-ui-tests
description: Run or update VGSShowDemoApp UI tests; use for XCUITest changes, accessibility identifiers, or simulator runs.
---

# VGS Show UI Tests

## Overview
Maintain and run XCUITests for the demo app without leaking sensitive data.

## Workflow
1. Work in VGSShowDemoApp/VGSShowDemoAppUITests and reuse the base test case.
2. Use VGSUITestElement helpers and stable accessibility identifiers.
3. Run UI tests from Xcode or xcodebuild with a simulator destination.
4. Keep test data synthetic and deterministic.

## References
- See references/ui-test-structure.md for UI test helpers and locations.
- See references/ui-test-commands.md for example xcodebuild commands.
