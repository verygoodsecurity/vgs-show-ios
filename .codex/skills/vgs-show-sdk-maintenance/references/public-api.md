# Public API Boundaries

Check public surface:
- Search for public or open declarations in Sources/VGSShowSDK.
- Review generated docs in docs/ for the public API set.
- Verify Objective-C exposure in Sources/VGSShowSDK/VGSShowSDK.h.

Avoid deprecated or internal types:
- Search for @available(*, deprecated) or deprecated in source and docs.
- Do not reference internal view models or decoder helpers.

When adding public API:
- Add tests and update docs.
- Keep logging and analytics behavior privacy-safe.
