---
name: vgs-show-docs-jazzy
description: Regenerate VGSShowSDK API docs with jazzy; use when public API changes or docs need refresh.
---

# VGS Show Jazzy Docs

## Overview
Rebuild the generated API documentation in docs/ using the repo Jazzy config.

## Workflow
1. Ensure the Jazzy tool is installed and the demo app Swift packages resolve if docs validation needs the demo project.
2. Run jazzy from the repo root using the provided config file.
3. Review updates under docs/ and docs/docsets.
4. Commit regenerated docs only when public API changes warrant it.

## References
- See references/jazzy-config.md for config expectations and paths.
