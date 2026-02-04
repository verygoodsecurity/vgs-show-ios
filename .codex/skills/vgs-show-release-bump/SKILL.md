---
name: vgs-show-release-bump
description: Bump VGSShowSDK versions for release; use when updating podspec, README pins, or demo app pods.
---

# VGS Show Release Bump

## Overview
Update versioned files and verify release readiness without modifying generated artifacts manually.

## Workflow
1. Choose the new semantic version.
2. Update VGSShowSDK.podspec to the new version.
3. Update version pins in README.md for CocoaPods and Swift Package Manager.
4. Update the demo app Pods state by running CocoaPods in VGSShowDemoApp when needed.
5. Run unit tests and any required docs regeneration.
6. Tag and publish following the release process.

## References
- See references/version-files.md for versioned file locations.
- See references/demo-pods.md for demo app CocoaPods guidance.
