# COMPATIBILITY_DEVIATIONS.md

This file documents intentional deviations from upstream GNU Bash semantics.

The default expectation is an empty registry for Bash-only semantics.

## DEV-EXPORT-F-JUL — Mandatory v0.0.x entry

```text
id: DEV-EXPORT-F-JUL
upstream behavior: Bash functions may be exported with export -f
NeuraBash behavior: functions containing JUL AST nodes are rejected by export -f
reason: ordinary upstream Bash consumers cannot parse JUL syntax
test: tests/trace/export_f_jul_rejected.bats
risk: Low — only affects functions mixing JUL syntax with export -f
migration/remediation: Use pure Bash functions when export -f is required
```

Pure Bash function export is not a deviation.
