# .codex/AGENTS.md

Internal contributor guide for agents and maintainers working inside the `vgs-show-ios` repository.

This file complements the root `AGENTS.md`:
- Root `AGENTS.md` is for integrator agents and public API usage.
- This `.codex/AGENTS.md` is for contributors changing SDK internals, tests, demo flows, docs, and release artifacts.

If a task changes public API, observable integration behavior, supported versions, security guidance, or user-facing examples, update the root `AGENTS.md` and `README.md` in the same change when needed.

## Scope
- Maintain `VGSShowSDK` internals without leaking sensitive revealed data.
- Keep public docs accurate when contributor changes affect integrators.
- Prefer deterministic, auditable changes with matching tests.
- Use repo-local skills from `.codex/skills` when the task matches them.

## First Read
Before changing code or docs:
1. Read the root `AGENTS.md` to preserve the public integration contract.
2. Read `README.md` if the task may affect setup, usage examples, or supported features.
3. Inspect the touched module and its tests before editing.
4. Keep unrelated worktree changes untouched.

## Mental Model
`VGSShowSDK` is a UI-bound reveal pipeline.

1. `VGSShow` is the main-actor session/orchestrator.
   It owns the subscribed reveal views, request context, and fan-out lifecycle.
2. `APIClient` builds requests.
   It resolves vault/custom host URLs, applies headers, keeps `URLSession(configuration: .ephemeral)`, and honors `VGSShowRequestOptions`.
3. `VGSShow+Network` performs one request and decodes once.
   It routes decoded content to every subscribed view model by `contentPath`.
4. View models bridge decoding to rendering.
   `VGSViewModelProtocol` implementations (`VGSLabelModel`, `VGSImageViewModel`, `VGSShowPdfViewModel`) receive decoding results and update their views.
5. UI elements own rendering of sensitive content.
   `VGSLabel`, `VGSImageView`, and `VGSPDFView` render revealed values inside SDK-managed UI components.
6. Formatting and masking happen inside the SDK display pipeline.
   Text transforms and secure ranges must keep raw revealed values out of logs, fixtures, screenshots, and persisted state.
7. Logging and analytics are metadata-only surfaces.
   They must never become side channels for raw text, base64 blobs, PDFs, images, vault secrets, or header values.

Contributor rule: internal classes help implement the SDK, but they are not part of the public contract unless explicitly exposed and documented. Do not leak internal-only types into root docs or README examples.

## Repository Map
- `Sources/VGSShowSDK/Core/Show`
  `VGSShow`, request flow, masking, decoders, network fan-out.
- `Sources/VGSShowSDK/Core/APIClient`
  Request construction, hostname resolution, transport, request options.
- `Sources/VGSShowSDK/Core/Analytics`
  Analytics collection and transport.
- `Sources/VGSShowSDK/Core/Environment`
  Environment modeling.
- `Sources/VGSShowSDK/Core/Session`
  Session identifiers and request metadata.
- `Sources/VGSShowSDK/UIElements/VGSLabel`
  Text reveal, masking, copy behavior, transformations.
- `Sources/VGSShowSDK/UIElements/VGSImageView`
  Image reveal and rendering.
- `Sources/VGSShowSDK/UIElements/VGSPDFView`
  PDF reveal and rendering.
- `Sources/VGSShowSDK/UIElements/VGSViewProtocols`
  Public/internal view contracts and view typing.
- `Sources/VGSShowSDK/Erros`
  `VGSShowError`, `VGSErrorType`, error info.
- `Sources/VGSShowSDK/Utils/Helpers/Loggers`
  Logging configuration and network logging.
- `Sources/VGSShowSDK/PrivacyInfo.xcprivacy`
  Privacy manifest. Keep this aligned with actual collection behavior.
- `Tests/VGSShowSDKTests`
  Unit coverage for request flow, decoding, masking, parsing, UI elements, and copy behavior.
- `VGSShowDemoApp`
  Demo integration used to validate real reveal flows and UI behavior.
- `docs/` and `docs/docsets/`
  Generated API docs. Regenerate when public API docs need refresh.

## Key Classes And Files
- `Sources/VGSShowSDK/Core/Show/VGSShow.swift`
  Session object, subscription lifecycle, main public entry point.
- `Sources/VGSShowSDK/Core/Show/Network/VGSShow+Network.swift`
  Reveal request execution, decode-once fan-out, request result handling.
- `Sources/VGSShowSDK/Core/APIClient/APIClient.swift`
  HTTP request building, timeout handling, hostname policy, ephemeral transport.
- `Sources/VGSShowSDK/Core/Show/Decoders/VGSDataDecoderFactory.swift`
  Decoder selection by content mode.
- `Sources/VGSShowSDK/UIElements/VGSLabel/VGSLabel.swift`
  Text rendering, masking, placeholders, clipboard behavior, transformations.
- `Sources/VGSShowSDK/UIElements/VGSImageView/VGSImageView.swift`
  Image rendering lifecycle and delegate failure mapping.
- `Sources/VGSShowSDK/UIElements/VGSPDFView/VGSPDFView.swift`
  PDF rendering lifecycle and delegate failure mapping.
- `Sources/VGSShowSDK/UIElements/VGSLabel/VGSLabelModel.swift`
- `Sources/VGSShowSDK/UIElements/VGSImageView/VGSImageViewModel.swift`
- `Sources/VGSShowSDK/UIElements/VGSPDFView/VGSPdfViewModel.swift`
  Internal view-model layer between decoded content and UI elements.
- `Sources/VGSShowSDK/Utils/Helpers/Loggers/VGSLogger.swift`
  Logging policy gate.
- `Sources/VGSShowSDK/Utils/Helpers/Loggers/VGSShowRequestLogger.swift`
  Sensitive area. Any change here must be privacy-reviewed.
- `Sources/VGSShowSDK/Core/Analytics/VGSAnalyticsClient.swift`
  Analytics transport and opt-out behavior.
- `Sources/VGSShowSDK/PrivacyInfo.xcprivacy`
  Privacy declaration that must match shipped behavior.
- `Sources/VGSShowSDK/VGSShowSDK.h`
  Objective-C exposure boundary for public symbols.
- `README.md`
  Public install and usage guidance.
- `AGENTS.md`
  Public integration contract for external agents.

## Security And Privacy Rules
1. Never commit real revealed data.
   No real PANs, account numbers, names, PDFs, images, aliases, vault IDs, hostnames, request payloads, or response bodies in code, tests, fixtures, docs, screenshots, or generated examples.
2. Use synthetic fixtures only.
   Test JSON, images, PDFs, and screenshots must contain fake data created for testing.
3. Do not widen logging.
   If a change touches `VGSLogger`, `VGSShowRequestLogger`, `print`, or error/reporting paths, make sure only safe metadata is emitted. Raw payloads, raw JSON, custom header values, and base64 blobs must stay out of normal contributor changes.
4. Treat analytics as sensitive.
   `VGSAnalyticsClient` may collect usage metadata, not revealed content. Keep payloads minimal and aligned with `PrivacyInfo.xcprivacy`.
5. Keep transport ephemeral.
   Do not replace ephemeral sessions with persistent storage-backed network behavior without an explicit design change and privacy review.
6. Keep secure rendering inside SDK-managed views.
   Do not add code that persists raw reveal values outside the view pipeline unless there is an explicit, reviewed product requirement.
7. Scrub examples and docs.
   `README.md`, root `AGENTS.md`, demo app code, and test comments must not contain secrets or realistic customer data.
8. Review custom headers carefully.
   Examples may show non-sensitive metadata headers only. Never commit secrets or encourage secret-bearing headers in logs.

If a task touches logging, analytics, or the privacy manifest, use the `vgs-show-privacy-logging` skill.

## Public API And Docs Sync Rules
Update the root `AGENTS.md` when:
- public types, enums, delegates, or options change
- integration sequencing changes
- security constraints or error-handling expectations change
- supported environments or initialization guidance change
- testing expectations for integrators materially change

Update `README.md` when:
- install instructions or version pins change
- usage snippets change
- feature descriptions or limitations change
- analytics, logging, or privacy statements change
- demo app guidance changes

Regenerate `docs/` and `docs/docsets/` when:
- public symbol docs change
- public API changes and generated docs would drift

When public API changes, also review:
- `Sources/VGSShowSDK/VGSShowSDK.h`
- `.jazzy.yaml`
- demo app flows under `VGSShowDemoApp`

Contributor rule: if root `AGENTS.md` or `README.md` becomes stale after your change, treat that as an incomplete task.

## Testing Expectations
- Add or update targeted tests under `Tests/VGSShowSDKTests`.
- Cover request flow, decoding, masking, rendering success/failure, and error mapping for the touched area.
- Prefer narrow unit tests first; use demo app or UI tests when behavior is integration-heavy.
- Keep fixtures synthetic and minimal.
- If public behavior changes, ensure demo app paths still exercise that behavior.

Useful test areas:
- `Tests/VGSShowSDKTests/VGSShowTests`
- `Tests/VGSShowSDKTests/DecoderTests`
- `Tests/VGSShowSDKTests/Masks`
- `Tests/VGSShowSDKTests/UIElements`
- `Tests/VGSShowSDKTests/UIElements/CopyPasteTests`

## Skills To Use
Use the smallest matching repo-local skill:
- `vgs-show-sdk-maintenance`
  Core SDK code, public API, logging, analytics.
- `vgs-show-test-harness`
  Unit tests and fixtures.
- `vgs-show-privacy-logging`
  Logging, analytics, privacy manifest work.
- `vgs-show-docs-jazzy`
  Regenerate generated docs.
- `vgs-show-demo-run`
  Demo app verification.
- `vgs-show-ui-tests`
  Demo UI test changes or simulator validation.
- `vgs-show-wrappers`
  SwiftUI or Combine wrapper work.
- `vgs-show-release-bump`
  Version bump and release-prep docs.

## Editing Rules
- Preserve `@MainActor` behavior for UI-bound types unless there is a deliberate concurrency design change.
- Avoid introducing new public API without tests and public-doc updates.
- Avoid deprecated APIs in both source and docs.
- Keep examples deterministic and copy-pastable.
- Do not revert unrelated worktree changes.
- If you create commits, sign them.

## Done Criteria
A contributor task is not complete until all applicable items are true:
- source changes align with the current public contract or intentionally update it
- tests for the touched behavior are added or updated
- no sensitive data was introduced into source, fixtures, docs, screenshots, or logs
- root `AGENTS.md` and `README.md` were updated if the change affects integrators
- generated docs were refreshed if public API documentation changed
