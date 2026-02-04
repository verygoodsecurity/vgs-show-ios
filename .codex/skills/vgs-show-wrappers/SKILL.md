---
name: vgs-show-wrappers
description: Build SwiftUI and Combine wrappers for VGSShowSDK; use when integrating VGSShow in SwiftUI views or reactive flows.
---

# VGS Show Wrappers

## Overview
Use the built-in SwiftUI representables and safe Combine wrappers to integrate VGSShowSDK without exposing raw data.

## Workflow
1. Prefer the built-in SwiftUI representables for VGSLabel, VGSImageView, and VGSPDFView.
2. If creating custom wrappers, set contentPath before requests and unsubscribe on teardown.
3. For Combine, publish only metadata such as status codes and error types, not raw values.
4. Ensure masking is applied before any user-visible refresh.
5. Keep subscriptions tied to view lifecycle to avoid stale views.

## References
- See references/swiftui.md for existing representables and usage.
- See references/combine.md for safe Combine publisher patterns.
