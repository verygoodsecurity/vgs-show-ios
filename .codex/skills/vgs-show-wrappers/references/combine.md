# Combine Wrapper Pattern

Goal:
- Emit status codes or error types only.

Pattern:
- Wrap VGSShow.request in a Future or PassthroughSubject.
- Map VGSShowError to a safe user message without exposing userInfo.

Cancellation:
- Combine cancellation cannot stop an in-flight request.
- On cancel or deinit, unsubscribe views to avoid stale updates.
