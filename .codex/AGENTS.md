# .codex/AGENTS.md

Internal contributor guide for agents and maintainers working inside the
`vgs-show-ios` repository.

## Scope

- Maintain VGSShowSDK internals without leaking sensitive revealed data.
- Keep public integration guidance and README content accurate when contributor
  changes affect app integrators.
- Prefer deterministic, auditable changes with matching validation.
- Use installed machine-level Codex skills when a task matches a specialized
  workflow. This repository does not keep repo-local Codex skills.

## First Read

Before changing code or docs:
1. Read the repository-level public integration guide to preserve the public
   contract.
2. Read the README if the task may affect setup, usage examples, supported
   versions, or feature descriptions.
3. Inspect the touched module and its tests before editing.
4. Keep unrelated worktree changes untouched.

## Mental Model

`VGSShowSDK` is a UI-bound reveal pipeline.

1. `VGSShow` is the main-actor session and orchestrator. It owns subscribed
   reveal views, request context, and fan-out lifecycle.
2. `APIClient` builds requests, resolves host URLs, applies headers, keeps
   ephemeral transport, and honors request options.
3. The network layer performs one reveal request and decodes once, then routes
   decoded content to every subscribed view model by `contentPath`.
4. View models bridge decoding to rendering for labels, image views, and PDF
   views.
5. UI elements own rendering of sensitive content inside SDK-managed
   components.
6. Text transformations and masking happen inside the SDK display pipeline.
7. Logging and analytics are metadata-only surfaces and must never expose raw
   text, base64 blobs, PDFs, images, vault secrets, or custom header values.

Contributor rule: internal classes help implement the SDK, but they are not
part of the public contract unless explicitly exposed and documented. Do not
leak internal-only types into public examples.

## Security And Privacy Rules

1. Never commit real revealed data.
2. Use synthetic fixtures only.
3. Do not widen logging. Raw payloads, raw JSON, custom header values, and
   base64 blobs must stay out of contributor changes.
4. Treat analytics as sensitive metadata only.
5. Keep transport ephemeral unless an explicit privacy-reviewed design change
   requires otherwise.
6. Keep secure rendering inside SDK-managed views.
7. Scrub examples and docs for secrets or realistic customer data.
8. Review custom headers carefully; examples may show non-sensitive metadata
   headers only.

If a task touches logging, analytics, or the privacy manifest, use the
appropriate privacy-focused workflow before finalizing.

## Public API And Docs Sync Rules

Update public integration guidance when:
- public types, enums, delegates, or options change
- integration sequencing changes
- security constraints or error-handling expectations change
- supported environments or initialization guidance changes
- testing expectations for integrators materially change

Keep the root public guide as an alias to the canonical integration guidance.
Do not replace it with a duplicated markdown file.

Update README content when:
- install instructions or version pins change
- usage snippets change
- feature descriptions or limitations change
- analytics, logging, or privacy statements change
- demo app guidance changes

Regenerate generated API docs when public symbol docs or public API change.

## Testing Expectations

- Add or update targeted unit tests for touched SDK behavior.
- Cover request flow, decoding, masking, rendering success/failure, and error
  mapping for the touched area.
- Prefer narrow unit tests first; use demo app or UI tests when behavior is
  integration-heavy.
- Keep fixtures synthetic and minimal.
- If public behavior changes, ensure demo app paths still exercise that
  behavior.

## Editing Rules

- Preserve `@MainActor` behavior for UI-bound types unless there is a
  deliberate concurrency design change.
- Avoid introducing new public API without tests and public-doc updates.
- Avoid deprecated APIs in both source and docs.
- Keep examples deterministic and copy-pastable.
- Do not revert unrelated worktree changes.
- If you create commits, sign them.

## Done Criteria

A contributor task is not complete until all applicable items are true:
- source changes align with the current public contract or intentionally update
  it
- tests for the touched behavior are added, updated, or clearly not needed
- no sensitive data was introduced into source, fixtures, docs, screenshots, or
  logs
- public integration guidance and README content were updated if the change
  affects integrators
- generated docs were refreshed if public API documentation changed
