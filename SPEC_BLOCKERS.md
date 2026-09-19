# SPEC_BLOCKERS.md

This file records genuine contradictions between normative requirements in the NeuraBash specification.

**Current status: EMPTY**

No spec blockers identified as of v0.0.7-IMPLEMENTATION handoff.

If a real contradiction is discovered during implementation:

1. Create the smallest failing test that demonstrates it
2. Record both requirement IDs and competing outcomes here
3. Do NOT silently choose one interpretation
4. Continue independent implementation work where possible

## Format for future entries

```markdown
## BLOCKER-XXX

**Conflicting requirements:** [REQ-A] vs [REQ-B]

**Observable outcome A:** ...

**Observable outcome B:** ...

**Test demonstrating conflict:** tests/blockers/XXX.bats

**Resolution:** [pending spec clarification]
```
