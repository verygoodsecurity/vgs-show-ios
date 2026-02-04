---
name: vgs-show-demo-run
description: Build and run the VGSShow demo app on simulator; use when verifying demo flows or UI behavior.
---

# VGS Show Demo Run

## Overview
Run the demo app locally in the iOS simulator using the CocoaPods workspace.

## Workflow
1. Install CocoaPods dependencies in VGSShowDemoApp if needed.
2. Open VGSShowDemoApp/VGSShowDemoApp.xcworkspace and select the VGSShowDemoApp scheme.
3. Choose a simulator and build/run.
4. Set a sandbox vault id using the initial screen or DemoAppConfig and avoid committing real IDs.
5. Validate reveal flows without logging raw data.

## References
- See references/demo-config.md for vault id configuration and entry points.
