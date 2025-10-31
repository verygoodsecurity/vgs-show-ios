# AGENTS.md

Authoritative integration guide for autonomous engineering agents adding **VGSShow iOS SDK (VGSShowSDK)** to downstream iOS apps to *reveal* previously tokenized/aliased data (text, images, PDFs) securely.

Scope & Constraints
- ONLY covers public, non‑deprecated APIs verified in current sources. Deprecated symbols (e.g. deprecated internal masked label attributes) MUST NOT be referenced or used.
- Focus: deterministic, auditable steps (environment setup, view subscription, reveal request flow, masking, error handling, logging hygiene, testing, hardening, upgrades).
- Excludes VGSCollect guidance (see dedicated Collect AGENTS file). This file is for SHOW (display) pipeline only.

Success Criteria (Every Task Must Honor)
1. No sensitive raw revealed data persisted outside UI views or copied to logs/analytics (except allowed metadata: lengths, boolean flags).  
2. All reveal views have a non‑empty `contentPath` before requests.  
3. Reveal requests never executed with zero subscribed views unless intentionally validated (warn expected).  
4. Error handling maps SDK/network errors to safe user messages (no internal codes leaked).  
5. All custom headers intentional & documented; none contain secrets at runtime logs.  
6. Deprecated APIs avoided; new code compiles clean against current SDK.  
7. Tests cover: successful multi‑view reveal, missing path warning, error decoding path mismatch, secure masking behavior, PDF & image rendering success/failure.  
8. Unsubscribe logic used to prevent stale views / retain cycles when views deallocate.  
9. UI masking (`isSecureText` / secure ranges) applied before any user‑visible refresh when required.  
10. Build + tests reproducible; environment & vault ID statically configured (never from end‑user input).

---
## 1. Core Mental Model
`VGSShow` = session object bound to a tenant (vault) + environment (sandbox/live with optional data region).  
Views (`VGSLabel`, `VGSImageView`, `VGSPDFView`) subscribe to a single `VGSShow` instance. Each view declares a `contentPath` (JSON key) used to extract a field from the reveal response payload.  
A single request (`VGSShow.request`) decodes JSON once, routing revealed values to all subscribed views according to their paths. Unmatched paths yield warnings + error callbacks per view.

Data Flow
1. Configure `VGSShow` with vault/environment.  
2. Create UI view(s); set `contentPath` before (or immediately after) subscribing (must be non‑empty pre‑request).  
3. `show.subscribe(view)` registers the view model.  
4. Call `show.request(...)`.  
5. SDK fetches JSON → decodes → updates each view model → renders transformed / masked UI.  
6. Optional: clear or unsubscribe when no longer needed.

Security Boundary: Only the SDK and its managed views hold raw revealed values; application layer must avoid storing or logging them.

---
## 2. Public API Surface (Show SDK)
Objects & Enums (public, non‑deprecated):
- Core: `VGSShow`
- Views: `VGSLabel`, `VGSImageView`, `VGSPDFView`
- Delegates: `VGSLabelDelegate`, `VGSImageViewDelegate`, `VGSPDFViewDelegate`
- Request/Networking: `VGSHTTPMethod`, `VGSShowRequestOptions`, `VGSShowRequestResult`
- Environment: `VGSEnvironment`
- Errors: `VGSShowError`, `VGSErrorType`
- Logging: `VGSLogger`, `VGSLoggingConfiguration`, `VGSLogLevel`
- Styling: `VGSPlaceholderLabelStyle`
- Typealiases: `VGSJSONData`, `VGSHTTPHeaders`

Exclude any symbol marked `@available(*, deprecated, …)` or internal-only types (view models, decoder factories, secure subclasses).

---
## 3. Environment & Initialization
Inputs:
- `id` (vault/tenant id) – must be non‑empty
- Environment: either raw environment string (`"sandbox"`, `"live-eu1"`, etc.) or `VGSEnvironment` + optional `dataRegion`
- Optional `hostname` for custom domain

Examples:
```swift
let show = VGSShow(id: sandboxVaultId, environment: .sandbox)
let showRegional = VGSShow(id: sandboxVaultId, environment: .sandbox, dataRegion: "eu-123")
let liveShow = VGSShow(id: liveVaultId, environment: .live, hostname: "reveal.example.com")
```
Hardening:
- Debug assert: `precondition(!vaultId.isEmpty)`
- Don’t derive environment from user input; use build config / secure remote config with allow‑list.

---
## 4. View Subscription Lifecycle
Sequence:
1. Instantiate view (`VGSLabel`, `VGSImageView`, `VGSPDFView`).
2. Set `contentPath` (non-empty string key matching backend JSON).
3. Configure mask / placeholder / delegate.
4. `show.subscribe(view)` (idempotent; duplicates ignored).
5. Execute `request`.
6. On teardown or reuse: `show.unsubscribe(view)` or `show.unsubscribeAllViews()`.

Validation Hooks:
- Before request, ensure `subscribedViews.count > 0` and each has non-empty `contentPath`.
- Changing `contentPath` after subscription is fine; ensure not mid-request.

---
## 5. VGSLabel (Text Reveal)
Capabilities:
- `contentPath`: required.
- Secure masking: `isSecureText` (mask all) + `setSecureText(start:end:)` / `setSecureText(ranges:)` for partial masks.
- Mask symbol: `secureTextSymbol` (must be 1 character; warn otherwise).
- Transformation: `addTransformationRegex(_:template:)` (applied pre-masking display transformation).
- Placeholder: `placeholder`, `placeholderStyle` (`VGSPlaceholderLabelStyle`).
- Copy: `copyTextToClipboard(format: .raw | .transformed)`.
- Inspection: `isEmpty`, `revealedRawTextLength` (metadata only; do NOT log actual text).
- Accessibility: `vgsAccessibilityLabel`, `vgsAccessibilityHint`, `vgsIsAccessibilityElement`.

Masking Patterns:
- Full mask: set `isSecureText = true` without ranges.
- Show last 4: after reveal, compute length `L`; `setSecureText(start: 0, end: L - 5)` if `L > 4`.

---
## 6. VGSImageView (Image Reveal)
- `contentPath` to base64 or raw image data value.
- `imageContentMode` to control layout.
- `hasImage` to check success.
- `clear()` to remove previous image.
- Delegate: `imageDidChange(in:)`, `imageView(_:didFailWithError:)` (e.g., `.invalidImageData`).

---
## 7. VGSPDFView (PDF Reveal)
- `contentPath` to base64 PDF data.
- Display settings: `pdfDisplayMode`, `pdfDisplayDirection`, `pdfAutoScales`, `displayAsBook`, `pageShadowsEnabled`, `pdfBackgroundColor`.
- `hasDocument` to verify success.
- Delegate: `documentDidChange(in:)`, `pdfView(_:didFailWithError:)` (e.g., `.invalidPDFData`).

---
## 8. Placeholder Styling
`VGSPlaceholderLabelStyle` fields (color, font, lines, alignment, lineBreakMode, characterSpacing). Apply via `label.placeholderStyle = ...` prior to request.

---
## 9. Making a Reveal Request
API:
```swift
show.request(
  path: "/reveal",
  method: .post,
  payload: ["reveal": ["user.name", "user.avatar_base64"]],
  requestOptions: {
    var opt = VGSShowRequestOptions()
    opt.requestTimeoutInterval = 15
    return opt
  }()
) { result in
  switch result {
  case .success(let status):
    // Views already updated
    print("Reveal success status=\(status)")
  case .failure(let status, let error):
    handleRevealFailure(status: status, error: error)
  }
}
```
Notes:
- `payload` structure is tenant specific; request only necessary keys.
- If no subscribed views, a warning is logged; enforce precondition if unintended.
- `customHeaders` must be set before invoking `request`.

---
## 10. Custom Headers
Assign as dictionary: `show.customHeaders = ["X-Correlation-ID": uuid]`.
Never include secrets or PII. Headers are captured in analytics only as metadata (presence), not values; still sanitize logs.

---
## 11. Error Model & Handling
`VGSShowRequestResult`:
- `.success(code)`
- `.failure(code, Error?)`

`VGSShowError.type` (`VGSErrorType`) codes (subset):
- `unexpectedResponseType (1400)`
- `unexpectedResponseDataFormat (1401)`
- `responseIsInvalidJSON (1402)`
- `fieldNotFound (1403)`
- `invalidJSONPayload (1404)`
- `invalidBase64Data (1405)`
- `invalidPDFData (1406)`
- `invalidImageData (1407)`
- `invalidConfigurationURL (1480)`

Mapping Strategy:
```swift
func userMessage(for error: Error?) -> String {
  guard let e = error as? VGSShowError else { return "Reveal failed" }
  switch e.type! {
  case .fieldNotFound: return "Requested data unavailable"
  case .invalidPDFData, .invalidImageData: return "Cannot display document"
  case .invalidBase64Data: return "Corrupted data"
  default: return "Reveal failed"
  }
}
```
Never expose raw `error.userInfo` contents to end users.

---
## 12. Logging
Configuration:
```swift
VGSLogger.shared.configuration.level = .warning // .none in production
VGSLogger.shared.configuration.isNetworkDebugEnabled = false
VGSLogger.shared.configuration.isExtensiveDebugEnabled = false
```
Rules:
- Production: `.none` or at most `.warning` (if incident debugging approved).
- Forbidden log content: raw revealed strings, base64 blobs, vault id inside end-user strings, custom header values.
- Use `VGSLogger.shared.disableAllLoggers()` for fail‑safe disable.

---
## 13. Analytics
Toggle collection:
```swift
VGSAnalyticsClient.shared.shouldCollectAnalytics = false // if policy mandates
```
Allowed: On/off toggle only. Do not mutate analytics payload fields or intercept events.

---
## 14. Masking / Transformation Order
Internal pipeline (conceptual): Raw decode → transformation regex(es) → secure masking → UI render.
Agent Actions:
- Define transformations prior to reveal if deterministic; or after reveal if conditional.
- Apply secure ranges only after length known (post-reveal). If length influences UI layout, delay layout pass until masking applied.

---
## 15. Performance & Concurrency
- Single `VGSShow` instance per logical screen / context.
- Batch multiple view reveals in one request.
- Avoid overlapping multiple requests for same view set; serialize unless streaming updates required.
- Large base64 assets: ensure backend enforces size caps; consider progress indicators for large PDFs (future enhancement — current API synchronous post decode to UI).

---
## 16. Testing Strategy (Minimum Set)
1. Happy Path Multi-View: Two labels + image + pdf with stub JSON (or mock) → all populated; result `.success`.
2. Missing Path Warning: One label path absent → delegate error + `fieldNotFound` error; request still `.success`.
3. Invalid Image: Provide invalid base64 → image delegate failure `.invalidImageData`.
4. Invalid PDF: Provide invalid base64 → pdf delegate failure `.invalidPDFData`.
5. Secure Masking: Reveal text, apply partial mask → ensure displayed differs from raw (capture screenshot or rendered text), but last visible digits preserved.
6. Copy Operation: With transformation + masking, copy `.transformed` vs `.raw`; ensure clipboard content matches expected format and never includes masked symbol when copying raw intentionally (only if policy allows raw copy).
7. Timeout Option: Set very low `requestTimeoutInterval` and simulate network stall to produce `.failure` path.

All tests must avoid logging raw secrets. Use synthetic sample strings.

---
## 17. Upgrade Workflow
1. Bump SDK version (SPM/CocoaPods) explicitly.
2. Rebuild & run tests (cover all strategy cases above).
3. Scan for new deprecations (`grep -R "deprecated"`).
4. Update this AGENTS file if new public view types / options added.
5. Confirm logging defaults unchanged.
6. Validate error code set (diff old vs new) and adapt mapping tests.

---
## 18. Security Checklist (Per PR)
[ ] Vault/environment initialization validated (non-empty, correct stage).  
[ ] No raw revealed values logged.  
[ ] All subscribed views have non-empty `contentPath`.  
[ ] Partial reveals handled (warnings tested).  
[ ] Masking applied where required (sensitive fields).  
[ ] Custom headers sanitized.  
[ ] Logging level production-safe.  
[ ] No deprecated API usage.  
[ ] Tests updated/green (see §16).  

---
## 19. Common Failure Modes & Mitigations
| Failure | Cause | Mitigation |
|---------|-------|-----------|
| Warning: empty content path | Forgot to set `contentPath` | Add pre-request assert / factory guard |
| Some data not revealed | Backend keys mismatch | Align contract; add integration test |
| Image/PDF invalid error | Corrupted or wrong base64 | Backend validation; reject invalid format earlier |
| Mask not applied | Ranges set before length known | Defer `setSecureText` until after reveal completion |
| Memory spike | Oversized base64 asset | Enforce size limit server-side; consider pagination for PDFs |

---
## 20. Quick Reference Snippets
Initialize:
```swift
let show = VGSShow(id: vaultId, environment: .sandbox)
```
Subscribe & Reveal:
```swift
let label = VGSLabel(); label.contentPath = "user.email"; show.subscribe(label)
show.request(path: "/reveal") { _ in }
```
Image Reveal:
```swift
let avatar = VGSImageView(); avatar.contentPath = "user.avatar"; show.subscribe(avatar)
```
PDF Reveal:
```swift
  let pdfView = VGSPDFView(); pdfView.contentPath = "docs.statement"; show.subscribe(pdfView)
```
Secure Last4:
```swift
label.isSecureText = true
// After reveal
afterReveal { let L = label.revealedRawTextLength; if L > 4 { label.setSecureText(start: 0, end: L - 5) } }
```
Copy:
```swift
label.copyTextToClipboard(format: .transformed)
```
Timeout Option:
```swift
var opt = VGSShowRequestOptions(); opt.requestTimeoutInterval = 10
show.request(path: "/reveal", requestOptions: opt) { _ in }
```
Unsubscribe Cleanup:
```swift
show.unsubscribeAllViews()
```
Disable Logging:
```swift
VGSLogger.shared.disableAllLoggers()
```
Analytics Opt-Out:
```swift
VGSAnalyticsClient.shared.shouldCollectAnalytics = false
```

---
## 21. Implementation Recipe (End-to-End)
1. Validate vault id + environment; construct `VGSShow`.
2. Instantiate views; set `contentPath`, optional placeholders, secure flags.
3. Subscribe all views.
4. Optionally set `customHeaders` & build payload listing necessary keys.
5. Invoke single batched `request`.
6. On callback success: UI already updated; adjust mask ranges if needed.
7. On failure: map error → user message; optionally retry with backoff.
8. On screen teardown: unsubscribe views.

---
## 22. Final Agent Rules
When uncertain choose the approach that:
1. Minimizes API surface & complexity (single batched request over multiple).  
2. Avoids exposing or persisting raw revealed data.  
3. Uses only documented public, non‑deprecated interfaces here.  
4. Improves determinism & test coverage.  
5. Keeps logging minimal in production.  

End of AGENTS.md
