---
name: vgs-show-planning
description: Plan complex VGSShowSDK or demo app tasks; use when a request spans multiple files or subsystems, has unclear requirements, or needs a step-by-step plan before execution.
---

# VGS Show Planning

## Overview
Provide a clear, minimal plan before execution when the task is complex or ambiguous. The plan must break work into small, sequenced steps with explicit outcomes.

## When To Plan
Use a plan when the task:
- Touches multiple modules (e.g., SDK core + UI + tests).
- Requires coordination across demo app, docs, or release files.
- Changes security, privacy, logging, or error handling behavior.
- Has unclear requirements, data contracts, or integration points.
- Introduces new tests or significant refactors.

Skip planning for trivial, single-file changes with obvious fixes.

## Workflow
1. Restate the goal, constraints, and non-goals.
2. Identify unknowns and risks; ask targeted questions if blocked.
3. Break the work into 3-7 small steps; each step should have a concrete outcome.
4. Order steps and call out dependencies or optional steps.
5. Add verification: tests, builds, or manual checks.
6. Confirm the plan before execution if requirements are incomplete or the plan changes materially.

## Output Format
- Use a short preface with assumptions and unknowns if needed.
- Provide the plan as a numbered list.
- Include file paths or commands where relevant.
- Keep steps small and atomic.

## References
- See references/planning-checklist.md for quality checks and examples.
