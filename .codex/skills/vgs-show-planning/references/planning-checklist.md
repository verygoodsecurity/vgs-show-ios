# Planning Checklist

Use this to review plan quality before execution.

## Core Checks
- Goal and constraints restated clearly.
- Unknowns and risks identified; questions asked if blocking.
- Steps are small, ordered, and outcome-driven.
- Dependencies called out (tests, docs, demo app, release files).
- Verification included (tests, builds, manual checks).

## Step Quality
- Each step should be independently actionable.
- Avoid steps that bundle unrelated changes.
- Keep plans concise: 3-7 steps for most tasks.

## Example Plan Shape
Assumptions:
- Vault ID is configured in DemoAppConfig.

Plan:
1. Update SDK logic in Sources/VGSShowSDK/Core/Show to validate contentPath before request.
2. Add tests in Tests/VGSShowSDKTests/VGSShowTests for missing contentPath warning.
3. Update demo app flow to reflect new validation, if needed.
4. Run unit tests and ensure no new warnings.

## When To Re-plan
- Requirements change mid-task.
- A new dependency appears (e.g., new test suite or docs update).
- The scope expands beyond the original steps.
