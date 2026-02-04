# Guardrails Checklist

1. No raw revealed data stored or logged.
2. Every view has a non-empty contentPath before request.
3. No reveal request with zero subscribed views unless explicitly intended.
4. Errors mapped to safe user messages, no internal codes exposed.
5. Custom headers are intentional and contain no secrets.
6. Deprecated APIs are not used.
7. Tests cover multi-view reveal, missing path, decoding mismatch, masking, PDF and image success or failure.
8. Views unsubscribe on teardown to avoid stale updates.
9. Masking applied before any user-visible refresh when required.
10. Vault and environment are static and not user-provided.
