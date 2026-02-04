---
name: vgs-show-security-privacy-review
description: Perform security and privacy review for VGSShowSDK changes; use for PR reviews touching logging, analytics, masking, contentPath rules, error mapping, or privacy manifest updates.
---

# VGS Show Security and Privacy Review

## Overview
Perform a structured review to ensure SDK changes comply with AGENTS.md security and privacy requirements.

## Workflow
1. Identify the scope of changes and affected modules.
2. Verify guardrails: no raw revealed data in logs, contentPath non-empty before request, subscribed views present, masking applied before UI, safe error messages.
3. Review logging and analytics configuration for production safety.
4. Check custom headers usage and confirm no secrets are logged.
5. Confirm privacy manifest updates when new API categories or access are added.
6. Ensure tests cover required scenarios or add missing coverage.
7. Report findings with pass or fail and required follow-ups.

## References
- See references/guardrails.md for the security checklist.
- See references/review-commands.md for quick scan commands.
- See references/privacy-manifest.md for manifest location and rules.
