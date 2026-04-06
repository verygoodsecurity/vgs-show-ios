# vgs-show-ios-private Dependency Map

## Project Structure

This is an iOS SDK (VGSShowSDK) distributed via Swift Package Manager and CocoaPods. It provides UI components for securely revealing VGS-tokenized data (text, images, PDFs).

- **Sources/VGSShowSDK/** — Core SDK library (iOS 13+, Swift 5.9). Zero external SwiftPM dependencies.
- **Tests/VGSShowSDKTests/** — Unit tests for the SDK (decoders, parsing, masks, UI elements, API client).
- **VGSShowDemoApp/** — Demo app using CocoaPods. Depends on `VGSCollectSDK` and local `VGSShowSDK`. Has UI tests.
- **VGSShowSDK.xcodeproj** — Xcode project for building/testing the SDK.
- **VGSShowSDK.podspec** — CocoaPods distribution spec (v1.3.0).

## Dependency Categories

### Always Low Risk (Auto-merge Candidates)

| Pattern | Example | Reason |
|---------|---------|--------|
| GitHub Actions pin bumps (digest-only) | `actions/checkout`, `actions/upload-artifact` | CI-only, no runtime impact; pinned by SHA |
| CI tooling actions | `maxim-lobanov/setup-xcode` | Build environment setup only |
| Test/build tool gems | `xcov`, `xcpretty` | Test reporting only, not shipped |
| CocoaPods spec repo updates | CocoaPods CDN / trunk | Package index, no code change |

### Needs Quick Review

| Pattern | Example | Reason | Expected Test Coverage |
|---------|---------|--------|----------------------|
| GitHub Actions minor version bumps | `actions/checkout` v6 → v7 | Usually backwards-compatible | CI pipeline validates |
| Demo app pod minor bumps | `VGSCollectSDK` patch/minor | Demo app only, not shipped SDK | UI tests cover demo app flows |

### Needs Deep Review

| Pattern | Example | Reason | Expected Test Coverage |
|---------|---------|--------|----------------------|
| Xcode / iOS simulator version bumps | `xcode: ['16.2']`, `ios: ['26.2']` in CI matrix | May change build behavior, compiler warnings, deprecations | Full unit + UI test suite |
| Swift tools version bump | `swift-tools-version:5.9` in Package.swift | Affects minimum toolchain, could break consumers | Unit tests + downstream integration |
| VGSCollectSDK major bumps | `VGSCollectSDK` major version | Demo app integration dependency; API changes possible | UI tests in VGSShowDemoAppUITests |
| CocoaPods version bump | `pod` CLI version | Could affect pod install / spec validation | CI pod install step |

## Renovate Configuration

Minimal configuration — only the default schema is specified (`renovate.json` contains just `$schema`). No custom extends, labels, grouping, automerge rules, or package rules are configured. Renovate will use its default preset behavior.
