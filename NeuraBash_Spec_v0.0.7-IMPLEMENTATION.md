# NeuraBash Specification v0.0.7-IMPLEMENTATION

**Status:** Implementation-ready normative specification  
**Purpose:** Canonical implementation contract for the first complete NeuraBash build  
**Architecture:** GNU Bash-derived shell core + native JUL grammar extension + persistent Julia execution workers  
**Initial platform:** Linux, x86_64, glibc  
**Pinned Bash lineage for first implementation:** GNU Bash 5.2.37  
**Julia compatibility floor:** Julia 1.10+; each NeuraBash release MUST publish the exact supported Julia matrix  
**Research program:** Project NIRA — Neurosymbolic Inference for Reconfigurable Agency  
**Red-team gate:** RT5 — no constitutional failures, no security lies, no CRITICAL/HIGH findings; residual ambiguity 13/100 before v0.0.7 closure  
**Handoff policy:** This revision is the implementation source of truth; later implementation choices MUST NOT silently change observable semantics.  

---

# 0. Definition and terminology

> **NeuraBash is GNU Bash extended with a native, typed Julia trapdoor that lets models move from ordinary shell work into exact mathematics, structured computation, Julia packages, symbolic tooling, and reusable self-authored tools without changing interfaces.**

NeuraBash does not attempt to expose or replace hidden neural reasoning.

It gives a model a low-friction symbolic environment in which useful work can be externalized into executable, inspectable, testable, and reusable machinery.

The design objective is:

```text
ZERO-SHOT AT THE SURFACE.
BOTTOMLESS IN THE DEEP WARP.
```

Normative terminology:

```text
NeuraBash
    the complete shell/runtime described by this specification

Bash / Realspace
    the inherited GNU Bash surface and semantics

JUL
    Julia Utility Layer; the typed Level-1 language entered through |!>

Deep Warp
    full Julia beneath JUL

JIF
    JUL Interchange Format; the canonical cross-runtime value format

Core Pack
    the release-pinned provider environment required by the standard Level-1 library

Forge
    the tool construction, testing, registration, and reuse subsystem
```

The historical project placeholder is not part of the public language surface. New executable names, environment variables, files, documentation, and diagnostics MUST use `NeuraBash` / `neurabash` / `NEURABASH_*` naming unless a compatibility shim is explicitly documented.

# 1. Constitutional invariants

These requirements outrank syntax aesthetics, implementation convenience, and individual subsystem choices.

## INV-001 — Bash is the surface

For Bash-only source, NeuraBash MUST preserve the syntax and execution semantics of its pinned upstream GNU Bash lineage except for explicitly registered identity metadata.

NeuraBash MUST NOT recreate Bash semantics in a parallel parser when upstream Bash already supplies them.

The inherited Bash lexer/parser, expansion engine, executor, redirects, builtins, variables, aliases, functions, job control, signals, traps, shell options, readline integration, and process semantics remain authoritative for Bash behavior.

## INV-002 — Zero-adaptation shell competence

A model already competent with modern GNU Bash MUST be able to perform ordinary shell work in NeuraBash without NeuraBash-specific training.

Ordinary shell competence includes at least:

- filesystem navigation;
- file manipulation;
- shell variables and environment variables;
- pipelines;
- redirection;
- functions;
- loops and conditionals;
- command substitution;
- process substitution;
- aliases;
- `eval`;
- `source`;
- scripts;
- job control;
- traps;
- signals;
- Git;
- arbitrary external commands.

## INV-003 — Explicit descent

JUL semantics begin only through explicit JUL syntax.

NeuraBash MUST NOT infer from command names, file extensions, data shapes, or intent that a Bash expression “really meant” Julia.

## INV-004 — Typed internals

Values moving between JUL stages remain typed runtime values.

A JUL value MUST NOT be converted to display text merely to pass to another JUL stage.

## INV-005 — High-level first, real Julia underneath

The Level-1 JUL surface MUST provide compact, high-leverage operations usable by small models.

The Level-1 surface MUST NOT become the computational ceiling.

Full Julia MUST remain explicitly reachable.

## INV-006 — Easy self-tooling

A reusable tool composed from existing JUL operations MUST be constructible, testable, named, and reused without requiring raw Julia.

Raw Julia remains available when composition is insufficient.

## INV-007 — Zero-admin Julia

Normal JUL use MUST NOT require the caller to manually manage:

- `Project.toml`;
- `Manifest.toml`;
- `JULIA_DEPOT_PATH`;
- environment activation;
- registry state;
- package precompilation;
- Julia cache layout.

NeuraBash owns those concerns.

## INV-008 — Source is authoritative

Persistent tools MUST be reconstructible from inspectable source/IR plus structured metadata.

JIT products, process memory, Julia `Serialization`, precompile caches, and compiled caches are accelerators only.

## INV-009 — Effects are honest

NeuraBash MUST distinguish semantic effects from implementation/runtime effects.

Arbitrary Julia MUST NOT be represented as sandboxed merely because it entered through NeuraBash.

## INV-010 — Model independence

The core language MUST NOT depend on a particular LLM, agent harness, planner, memory system, vector store, fluid-weight architecture, MCP server, or training method.

Those systems are optional consumers or attachments.

---

# 2. Project boundary

NeuraBash is:

1. a GNU Bash-derived shell;
2. a native grammar extension into typed JUL execution;
3. a persistent Julia-backed computation substrate;
4. a high-level symbolic standard library;
5. a reusable tool/artifact system;
6. a harness-compatible shell backend.

NeuraBash is not inherently:

- a fluid-weight system;
- an autonomous agent;
- an LLM memory architecture;
- a planner;
- an MCP implementation;
- a vector database;
- a theorem prover;
- a fine-tune;
- a theory of cognition.

The **Deep Warp Curriculum** is a separate deliverable that teaches models when and how to exploit NeuraBash.

---

# 3. Depth model

## DEPTH-0 — Bash / Realspace

Ordinary Bash remains ordinary Bash.

```bash
pwd
cd ~/repo
git status
rg "TODO" src/
cat log.txt | grep ERROR
export MODE=test
foo=$(date)
for f in *.jl; do echo "$f"; done
cargo test && echo passed
```

No JUL knowledge is required.

## DEPTH-1 — JUL

A compact typed surface.

Canonical namespaces:

```text
core.*
text.*
bytes.*
math.*
vector.*
matrix.*
table.*
stats.*
graph.*
symbolic.*
solve.*
optimize.*
check.*
shell.*
inspect.*
render.*
tool.*
pkg.*
help.*
julia.*
```

## DEPTH-2 — Deep Warp

Actual Julia.

Includes:

- structs;
- abstract and parametric types;
- multiple dispatch;
- modules;
- macros;
- generated functions;
- AST manipulation;
- package APIs;
- native libraries;
- LLVM/JIT;
- GPU libraries;
- FFI;
- arbitrary Julia source.

Deep Warp is Julia, not a restricted Julia-like language.

---

# 4. Upstream Bash contract

## BASH-001 — Pinned upstream

Each NeuraBash release MUST identify one pinned GNU Bash source revision.

For v0.0.6-PRE-RT5 the implementation target is GNU Bash 5.2.37.

The repository MUST record:

```text
UPSTREAM_BASH_VERSION
UPSTREAM_SOURCE_ID
UPSTREAM_SOURCE_HASH
NEURABASH_PATCHSET_VERSION
```

## BASH-002 — Bash-only behavior

Source containing no active JUL syntax MUST follow the inherited Bash execution path.

NeuraBash MUST NOT rewrite Bash-only source into hidden commands.

## BASH-003 — Differential conformance

For every Bash-only test program `T`:

```text
pinned_upstream_bash(T)
neurabash(T)
```

MUST be compared for deterministic observable behavior:

- stdout;
- stderr;
- exit status;
- filesystem effects;
- pipeline status;
- redirects;
- working directory behavior;
- same-shell variable/function effects;
- traps;
- job-control behavior where automatable.

Any unexplained deterministic difference is release-blocking.

## BASH-004 — Identity

NeuraBash MUST NOT falsify upstream identity.

- `$BASH_VERSION` remains the inherited GNU Bash version.
- `$NEURABASH_VERSION` reports NeuraBash version.
- `$NEURABASH_ACTIVE` MAY be a readonly `1`.
- `$0` follows ordinary invocation rules.
- `$SHELL` is not rewritten solely to advertise NeuraBash.
- `neurabash --version` reports both Bash and NeuraBash versions.

## BASH-005 — License boundary

The Bash-derived shell core MUST preserve upstream licensing notices and satisfy the license obligations of the pinned GNU Bash source.

The Julia execution subsystem SHOULD remain separable from the Bash-derived process where practical.

Release engineering MUST perform a real license-compliance review.

---

# 5. JUL transition token

## EXT-001 — Canonical token

The canonical token is:

```text
|!>
```

In Bash grammar it means:

> create or extend a JUL typed pipeline.

In JUL grammar it means:

> pass the current typed value to the next JUL stage.

## EXT-002 — Native grammar only

NeuraBash MUST implement `|!>` in the inherited Bash lexer/parser.

A generic external Bash source preprocessor is prohibited as the authoritative architecture.

## EXT-003 — Empirical collision gate

The token is valid only for an explicitly pinned upstream Bash lineage.

Before release, the build MUST execute a collision corpus against the unmodified pinned upstream Bash binary and require every canonical unquoted active `|!>` form to be rejected as syntax without observable side effects.

The test MUST verify:

1. nonzero parse status;
2. stderr reports syntax rejection;
3. no redirect target or other filesystem effect was produced;
4. no stdout was produced by commands that should never execute.

Required cases include at least:

```bash
echo x |!> /tmp/a
echo x |!>&1
echo x |!>out
echo x | !> /tmp/b
echo x | ! > /tmp/c
echo x |! > /tmp/d
```

plus parser-context tests covering:

```text
pipeline
function
subshell
brace group
command substitution
process substitution
arithmetic
[[ ]]
(( ))
case
time
!
coproc
&&
||
&
redirection adjacency
```

If any supported upstream Bash lineage accepts canonical `|!>` syntax with ordinary Bash semantics, that lineage is unsupported until the token or grammar contract is revised.

## EXT-004 — Bash lexical protection

`|!>` remains ordinary text where upstream Bash lexical state treats it as protected text, including applicable cases inside:

- single quotes;
- double quotes;
- ANSI-C quotes;
- escaped sequences;
- heredoc bodies;
- comments.

NeuraBash MUST reuse Bash lexical state to make this determination.

## EXT-005 — Dynamic source

Because JUL is part of the shell grammar, JUL source introduced later through ordinary Bash parsing mechanisms MUST remain parseable.

Required tests include:

- `eval`;
- `source`;
- alias expansion;
- function definition and invocation;
- sourced NeuraBash scripts.

---

# 6. Mixed pipeline grammar, normalization, and precedence

This section is normative.

A NeuraBash shell pipeline is normalized to an ordered sequence of process-visible pipeline elements.

A pipeline element is exactly one of:

```text
BASH_ELEMENT
JUL_SEGMENT
```

Connectors are:

```text
|     ordinary Bash stdout pipe
|&    ordinary Bash stdout+stderr pipe
|!>   Bash-to-JUL or JUL-to-JUL typed connector
```

A contiguous sequence of JUL stages connected by `|!>` is one `JUL_SEGMENT`.

## GRAM-001 — Legal connector transitions

| Left element | Connector | Right syntax | Normalized meaning |
|---|---|---|---|
| Bash | `|` | Bash | ordinary Bash pipe |
| Bash | `|&` | Bash | ordinary Bash stdout+stderr pipe |
| Bash | `|!>` | JUL stage | Bash stdout -> one JUL segment as `ByteStream` |
| JUL segment | `|!>` | JUL stage | extend the same JUL segment with typed flow |
| JUL segment | `|` | Bash | render JUL result -> Bash byte pipe |
| JUL segment | `|&` | Bash | render JUL stdout, merge JUL stderr per inherited Bash `|&`, then pipe |

A direct Bash-to-JUL `|!>` consumes Bash stdout only.

To include Bash stderr, redirect it explicitly:

```bash
cmd 2>&1 |!> text.decode
```

## GRAM-002 — Multiple JUL islands are legal

```bash
cmd1 |!> op1 | cmd2 |!> op2 | cmd3
```

normalizes to exactly five Bash-visible pipeline elements:

```text
0 BASH(cmd1)
1 JUL(op1)
2 BASH(cmd2)
3 JUL(op2)
4 BASH(cmd3)
```

After completion:

```text
PIPESTATUS[0] = status(cmd1)
PIPESTATUS[1] = status(JUL(op1))
PIPESTATUS[2] = status(cmd2)
PIPESTATUS[3] = status(JUL(op2))
PIPESTATUS[4] = status(cmd3)
```

## GRAM-003 — Precedence and association

`|`, `|&`, and `|!>` occupy the same pipeline precedence level.

Pipeline construction is left-to-right.

The inherited Bash list/control operators:

```text
&&
||
;
&
newline
```

bind outside the completed mixed pipeline and terminate it unless the newline is an explicit continuation under §8.

Examples:

```text
a | b |!> c | d
=> [BASH(a), BASH(b), JUL(c), BASH(d)]

a |!> b | c |!> d
=> [BASH(a), JUL(b), BASH(c), JUL(d)]

a |!> b && c
=> AND_IF( [BASH(a), JUL(b)], c )
```

## GRAM-004 — Prefix `!`

Inherited Bash prefix `!` negates the final status of the complete mixed pipeline after ordinary Bash pipeline-status / `pipefail` calculation.

It does not mutate individual `PIPESTATUS` entries.

```bash
! cmd |!> op | grep x
```

means:

```text
negate_status(
    pipeline[BASH(cmd), JUL(op), BASH(grep x)]
)
```

## GRAM-005 — `time`

The Bash `time` reserved word applies to the complete following mixed pipeline exactly as it applies to an ordinary Bash pipeline.

```bash
time cmd |!> op | grep x
```

times all three normalized elements.

## GRAM-006 — `coproc`

When inherited Bash grammar permits `coproc` before a pipeline/compound command, the complete mixed pipeline is one coprocess job.

The externally visible coprocess descriptors are those of the complete mixed pipeline.

## GRAM-007 — `|&`

`|&` never enters JUL.

When `|&` follows a JUL segment, the JUL worker is the left process from Bash's perspective; its stdout is canonical rendered output and its stderr is diagnostics. The inherited Bash `|&` merge occurs after JUL rendering/diagnostic production.

## GRAM-008 — `set -o pipefail`

`pipefail` uses the exact normalized element status vector described by GRAM-002.

No JUL-specific exception is introduced.

## GRAM-009 — `set -e`

`errexit` observes the final mixed-pipeline status exactly where inherited Bash would observe an ordinary pipeline status.

JUL does not add a second independent `set -e` mechanism.

## GRAM-010 — Redirections

Bash redirections syntactically attached to a `JUL_SEGMENT` apply to the JUL worker process exactly as redirections attached to an ordinary Bash pipeline element.

Examples:

```bash
cat A.csv |!> matrix.read |!> matrix.rank > rank.txt
cat A.csv |!> matrix.read 2> jul.err | grep x
```

Redirection syntax itself remains parsed by inherited Bash grammar.

## GRAM-011 — Required parser oracle

The repository MUST contain committed expected parse/normalization fixtures covering every pairwise and meaningful nested combination of:

```text
|
|&
|!>
!
time
coproc
&&
||
;
&
newline
redirection
subshell
brace group
function
if/while/until
command substitution
process substitution
```

No relationship among these constructs is implementation-defined.

# 7. Root JUL commands and first-stage input

A command may begin with `|!>`:

```bash
|!> math.eval "2 + 2"
```

This creates a `JUL_SEGMENT` with no upstream Bash producer.

## ROOT-001 — Initial current value

A root JUL segment begins with the typed value:

```text
Null
```

## ROOT-002 — Operation input policy

Every Level-1 operation declares exactly one input policy:

```text
NONE
OPTIONAL
REQUIRED
STREAM_REQUIRED
```

Semantics:

```text
NONE
    the operation does not consume the current pipeline value

OPTIONAL
    receives the current value when non-Null; otherwise receives Null

REQUIRED
    Null input is ArgumentError

STREAM_REQUIRED
    requires ByteStream, Bytes, Text, or the exact stream-compatible set
    declared by the operation
```

Therefore:

```bash
|!> matrix.rank
```

returns `ArgumentError`, while:

```bash
|!> math.eval "2+2"
```

is valid.

## ROOT-003 — Binding source stage

A binding source stage:

```text
@NAME
```

replaces the current typed value with the referenced session binding.

```bash
|!> @A |!> matrix.rank
```

## ROOT-004 — Tool parameter references

Inside a tool pipeline block only:

```text
@param.NAME
```

resolves an immutable invocation parameter declared by that tool.

`@param.NAME` outside a tool body is `ParseError`.

# 8. Newlines and multiline JUL

Newline handling is conservative and deterministic.

## NL-001 — Default

A top-level newline terminates the current shell command when the combined Bash/JUL grammar is complete.

## NL-002 — Explicit continuation

A JUL segment continues across a newline only when at least one is true:

1. the previous non-whitespace token is `|!>`;
2. a JUL list, map, or pipeline block `@{ ... }` remains open;
3. a `julia.block` heredoc remains open;
4. inherited Bash backslash-newline continuation is active.

A following-line `|!>` does NOT retroactively continue a command already completed.

## NL-003 — Fresh leading `|!>`

If the prior command completed, a new line beginning with `|!>` starts a new root JUL segment with `Null` input.

Thus:

```bash
cmd |!> op1
|!> op2
```

is two commands.

To continue without a block:

```bash
cmd |!> op1 |!>
    op2
```

To define a multiline tool body:

```bash
|!> tool.define foo @{
    matrix.eig --values-only
    |!> vector.abs
    |!> vector.max
}
```

## NL-004 — Interactive continuation prompt

Readline continuation is driven by the combined parser's incomplete-syntax state.

A trailing `|!>`, unclosed JUL collection/block, or open heredoc MUST request continuation rather than execute a partial command.

# 9. JUL lexical grammar

Once a JUL segment begins, the lexer enters JUL lexical mode until the segment terminates.

Bash word expansion does not occur in JUL lexical mode.

## JLEX-001 — No implicit Bash expansion

These forms MUST NOT invoke Bash expansion inside JUL:

```text
$VAR
$(...)
`...`
*
?
~
{a,b}
```

Shell access is explicit through `shell.*`.

`$` is otherwise reserved in v0.0.x.

## JLEX-002 — Identifiers

```ebnf
letter         = "A"…"Z" | "a"…"z" ;
digit          = "0"…"9" ;
ident_start    = letter | "_" ;
ident_continue = letter | digit | "_" | "-" ;
ident          = ident_start , { ident_continue } ;
qualified_name = ident , { "." , ident } ;
```

Operation names are case-sensitive.

Custom Forge tool names are a single unqualified `ident` in v0.0.x.

The standard qualified namespaces in §3 are reserved and cannot be shadowed by custom tools.

## JLEX-003 — Stage

```ebnf
stage = binding_stage
      | literal_stage
      | operation ;
```

## JLEX-004 — Operation

```ebnf
operation = qualified_name , { argument | option } ;
```

After stdlib operation lookup, an unqualified `ident` may resolve to a custom tool according to the scope rules in §23.

## JLEX-005 — Arguments

```ebnf
argument = string
         | integer
         | float
         | boolean
         | null
         | binding_ref
         | param_ref
         | fixture_ref
         | comparator_ref
         | package_spec
         | list
         | map
         | bareword
         | pipeline_block ;
```

## JLEX-006 — Single-quoted strings

Single-quoted JUL strings:

- do not interpolate;
- recognize `\\` and `\'`;
- otherwise preserve content as UTF-8 text.

```text
'$HOME *.jl'
```

is literal text.

## JLEX-007 — Double-quoted strings

Double-quoted JUL strings support exactly:

```text
\n
\r
\t
\\
\"
\uXXXX
\UXXXXXXXX
```

They perform no Bash or Julia interpolation.

Invalid escape sequences are `ParseError`.

## JLEX-008 — Integers

Canonical integer forms:

```text
0
42
-42
0xFF
0b1010
0o755
```

Literals fitting signed Int64 become `Integer`.

Larger literals become `BigInt`.

There is no silent Float conversion of integer literals.

## JLEX-009 — Floating literals

Supported forms include:

```text
3.14
-3.14
1e6
-1.2e-4
```

Baseline high-level floats are IEEE-754 `Float64`.

Non-finite values are produced by computation, not spelled as numeric JUL literals outside explicitly defined evaluator constants.

## JLEX-010 — Bool and Null

```text
true
false
null
```

map to JUL `Bool` and `Null`.

## JLEX-011 — Binding references

```ebnf
binding_ref = "@" , ident ;
```

Binding references are valid as source stages and ordinary arguments.

## JLEX-012 — Tool parameter references

```ebnf
param_ref = "@param." , ident ;
```

A parameter reference is syntactically recognized everywhere but is semantically legal only inside a registered/defining tool body.

Outside such scope it is `ParseError`.

The bare token `@param` is always an ordinary `binding_ref` to a binding literally named `param`. A tool parameter named `param` is referenced as `@param.param`. This is intentional and stable.

## JLEX-012A — Fixture references

```ebnf
fixture_ref = "fixture:" , ident ;
```

Example: `fixture:matrix_A`.

The parser always emits a `FixtureRef`. If the receiving operation schema does not accept `FixtureRef`, validation returns `ArgumentError`; the token is never reinterpreted as a bareword.

Fixture names use `ident` exactly.

Therefore `fixture:foo.bar`, `fixture:`, and `fixture:1x` are `ParseError`, not alternate fixture-name syntaxes.

## JLEX-012B — Comparator references

```ebnf
comparator_ref = "cmp:" , ident , "@" , positive_integer ;
positive_integer = nonzero_digit , { digit } ;
```

Examples: `cmp:exact@1`, `cmp:approx@1`.

The parser always emits a `ComparatorRef`. A non-accepting schema returns `ArgumentError`.

Any token beginning with the reserved literal prefix `cmp:` that does not match the complete `comparator_ref` production is `ParseError` and MUST NOT fall back to a bareword or package specification.

## JLEX-012C — Package specifications

Package requests are a dedicated lexical class independent of the receiving operation:

```ebnf
package_spec = ident , [ "@" , version_constraint ] ;
version_constraint = version
                   | "^" , version
                   | "~" , version
                   | "=" , version
                   | range_clause , { "," , range_clause } ;
range_clause = (">=" | ">" | "<=" | "<" | "=") , version ;
version = digit , { digit } , [ "." , digit , { digit } , [ "." , digit , { digit } ] ] ;
```

Examples: `Graphs`, `Graphs@1.2`, `Graphs@^1.2`, `Graphs@>=1.2,<2.0`.

A syntactically valid `PackageSpec` used where the schema does not accept one is `ArgumentError`.
Comparator references cannot collide with package specs because comparator references require the literal `cmp:` prefix.

## JLEX-013 — Lists

```ebnf
list = "[" , [ argument , { "," , argument } ] , "]" ;
```

Trailing commas are forbidden in v0.0.x.

## JLEX-014 — Maps

Curly braces are exclusively map syntax.

```ebnf
map       = "{" , [ map_entry , { "," , map_entry } ] , "}" ;
map_entry = map_key , ":" , argument ;
map_key   = string | bareword ;
```

Examples:

```text
{}
{"tol": 1e-8}
{method: qr, full: false}
```

A bare `{ ... }` can never mean a pipeline block.

## JLEX-015 — Pipeline blocks

Pipeline blocks use a distinct sigil:

```ebnf
pipeline_block = "@{" , jul_pipeline , "}" ;
```

`@{}` is invalid because a pipeline block MUST contain at least one stage.

This syntax removes all map/block ambiguity.

## JLEX-016 — Barewords

A bareword is a non-whitespace JUL token not otherwise reserved.

Barewords become `Name`.

Operations may schema-coerce `Name` into:

- Text;
- Symbol;
- column name;
- package name;
- tool name;
- enum value.

Characters reserved by JUL syntax terminate or invalidate a bareword as required by the grammar.

The dedicated prefixes `fixture:` and `cmp:` and the `ident@version-constraint` package form are recognized before generic bareword fallback.

## JLEX-017 — Options

```ebnf
option = "--" , ident
       | "--" , ident , "=" , argument ;
```

For:

```text
--key value
```

the following token is parsed by the same `argument` production.

For:

```text
--key=@A
```

the value is a binding reference.

A flag with no value maps to Bool `true`.

Unknown options are `ArgumentError`.

## JLEX-018 — Comments

Outside strings and heredoc bodies:

```text
#
```

begins a JUL comment through end-of-line.

## JLEX-019 — Reserved punctuation

In JUL mode:

```text
@{  { } [ ] , : = |!>
```

have the meanings defined by this specification.

Outside JUL, inherited Bash grammar remains authoritative.

## JLEX-020 — No schema-aware parsing

The syntactic parser MUST NOT need an operation's runtime schema to distinguish maps, pipeline blocks, literals, bindings, parameters, fixtures, comparators, or package specifications.

Operation schemas validate a completed JUL AST after syntactic parsing. A token's syntactic class never changes because a different operation receives it.

# 10. Pipeline blocks

A pipeline block is a first-class JUL IR literal using the unambiguous syntax:

```text
@{ ... }
```

Normative grammar:

```ebnf
pipeline_block = "@{" , jul_pipeline , "}" ;
```

Example:

```bash
|!> tool.define spectral_radius @{
    matrix.eig --values-only
    |!> vector.abs
    |!> vector.max
}
```

## BLOCK-001 — Block is data

Parsing a pipeline block creates JUL pipeline IR.

The block is not executed merely by being parsed.

## BLOCK-002 — Maps are never blocks

`{ ... }` is always a map.

`@{ ... }` is always a pipeline block.

No runtime schema lookup or colon-based fallback is permitted.

## BLOCK-003 — Nested pipeline blocks

Nested pipeline blocks are forbidden in v0.0.x.

Encountering `@{` while already parsing a pipeline block body returns `ParseError`.

## BLOCK-004 — Block-accepting operations

Any operation schema may declare an argument of type `PipelineBlock`, but the v0.0.x Core Pack uses it normatively only for `tool.define`.

`table.filter` does not accept a pipeline block in v0.0.x.

## BLOCK-005 — Grammar-aware special forms

The only grammar-aware Level-1 special form in v0.0.x is:

```text
julia.block <<DELIMITER
```

because it delegates heredoc acquisition to inherited Bash heredoc machinery.

`tool.define` is NOT a parser special form; it receives an ordinary `PipelineBlock` value.

# 11. Raw Julia entry and source capture

Raw Julia entry is explicit.

## JULIA-001 — One-line expression

```bash
|!> julia.eval "sqrt(2)^2"
```

`julia.eval` receives one JUL `Text` argument containing Julia source.

## JULIA-002 — Multiline block

Canonical multiline form:

```bash
|!> julia.block <<'JULIA'
struct Foo{T}
    x::T
end

f(x::Foo) = x.x * 2
f(Foo(21))
JULIA
```

After recognizing `julia.block`, the parser delegates `<<` / `<<-`, delimiter parsing, and heredoc body acquisition to inherited Bash heredoc machinery.

The heredoc body delivered to `julia.block` follows the inherited delimiter quoting/tab-stripping rules.

No other Level-1 operation accepts Bash heredoc syntax in v0.0.x.

`julia.block` requires exactly one following Bash heredoc redirection.

Calling `julia.block` without `<<` / `<<-`, with more than one heredoc, or with ordinary positional Julia-source arguments is `ParseError` in v0.0.x.

Use `julia.eval "..."` for one-line raw Julia source.

## JULIA-003 — Session module

Each logical client session owns one Julia module:

```text
NeuraBashSession_<session_id>
```

Raw Julia for that client executes in that module.

Clients sharing a workspace do NOT share raw session module definitions.

## JULIA-004 — Same-block semantics

A `julia.block` MUST support:

1. defining and invoking a function in the same block;
2. defining a function that calls another function defined earlier in the same block;
3. defining a type and constructing it in the same block;
4. defining and using macros in ordinary legal Julia order;
5. defining generated functions where legal Julia permits it.

The implementation strategy is not normative; the observable semantics are.

## JULIA-005 — Dynamic tool invocation

A raw-Julia function exposed as a JUL tool MUST be invocable immediately after definition and in later commands without user-visible world-age failure.

## JULIA-006 — Authority

`julia.eval` and `julia.block` are `RAW_JULIA`.

They may perform arbitrary actions permitted by the active host security profile.

Language-level checking is not a sandbox for arbitrary Julia.

## JULIA-007 — Captured source artifact

```bash
|!> julia.block --capture=my_source <<'JULIA'
...
JULIA
```

stores the exact source bytes as an immutable session source artifact identified by content hash.

The capture does not claim semantic determinism. It guarantees only that the captured source itself is reconstructible.

## JULIA-008 — Source files for persistent tools

When:

```text
--julia-source=/path/file.jl
```

is used to register a persistent tool, NeuraBash copies the exact file bytes into the artifact at registration time.

Later edits to the original filesystem path do not mutate the registered revision.

Additional definition-time source files MUST be explicitly included with repeated:

```text
--source-dep=/path/dep.jl
```

and are copied into the artifact under deterministic relative names.

Dynamic undeclared source dependencies are not considered reconstructible and MAY make validation fail.

## JULIA-009 — Runtime external effects remain effects

A source-backed tool may still intentionally read files, environment state, network resources, or process state at invocation time.

Source reconstruction does not imply deterministic behavior.

Such tools remain governed by their declared/conservative effects and active security profile.

# 12. Runtime topology and logical-session identity

Reference topology:

```text
GNU Bash-derived NeuraBash shell
        |
        | native JUL AST
        v
JUL pipeline worker process
        |
        | capability-bound local framed protocol
        v
Julia session runtime / workspace service
```

## RT-001 — Process-visible JUL element

A JUL segment participating in a Bash pipeline MUST be represented by an actual child process/process-group participant from Bash's perspective.

The reference implementation uses an out-of-process JUL worker/client.

## RT-002 — Logical session

Each interactive top-level NeuraBash shell creates one logical JUL `session_id`.

Handshake fields:

```text
protocol_version
neurabash_version
artifact_schema_version
jif_version
session_id
workspace_id
julia_version
environment_generation
security_profile_id
```

## RT-003 — Session inheritance across Bash forks

Inherited Bash execution contexts created by the same NeuraBash shell retain the same logical JUL session:

- subshell `( ... )`;
- command substitution `$( ... )`;
- process substitution when it executes NeuraBash/JUL code;
- background jobs `... &`;
- forked function execution created by inherited Bash mechanisms.

This inheritance is maintained by a private capability-bearing file descriptor, not by exposing a reusable plaintext secret in ordinary environment variables.

Reference mechanism:

1. the top-level NeuraBash shell owns a private authenticated session-capability fd;
2. normal external commands receive that fd with close-on-exec behavior and therefore cannot reuse it;
3. immediately before launching a JUL worker, NeuraBash duplicates the capability into the worker intentionally;
4. inherited Bash fork contexts retain internal shell state sufficient to launch workers for the same logical session;
5. unrelated processes cannot attach merely by learning `session_id`;
6. broker/session authorization is derived from the capability channel, not caller-supplied session/profile strings.

A security-equivalent OS capability mechanism is permitted only if no reusable session secret appears in `env` and unrelated local processes cannot attach by identifier alone.

## RT-004 — JUL state visibility across inherited contexts

Because JUL session state is external to Bash variable memory, explicit JUL mutations performed by an inherited subshell/background context are visible to the same logical JUL session after that context exits.

Example:

```bash
( cat A.csv |!> matrix.read |!> core.bind A )
|!> @A |!> matrix.rank
```

MUST find `@A`.

This rule affects JUL state only. It does not alter inherited Bash variable/subshell semantics.

## RT-005 — Concurrent mutation ordering

Requests mutating session bindings/tool state serialize at the JUL session service in receive order.

Two concurrent background jobs racing to create the same binding without `--replace` result in one success and one `ArgumentError`; which request arrives first is intentionally scheduler-dependent.

## RT-006 — Explicit new shell process

Launching a new `neurabash` executable creates a new logical client session by default, even if launched from another NeuraBash shell.

Workspace persistent artifacts/packages remain shareable; session bindings do not.

## RT-007 — Per-client state

Per logical session:

```text
session bindings
session tools
session Julia module
raw Julia definitions
trace/error history
runtime object handles
environment-generation pin
```

## RT-008 — Workspace-shared state

Workspace-shared:

```text
current environment-generation pointer
immutable environment-generation records
persistent workspace tool registry
persistent fixtures
workspace configuration
compatibility aliases
```

## RT-009 — `-c` and `-lc`

`neurabash -c` and `neurabash -lc` use an ephemeral logical session by default.

Cross-invocation persistence requires:

```text
--neura-session=workspace
```

Each invocation still receives a distinct client session/binding namespace unless an explicit future attach API is introduced.

## RT-010 — Runtime version mismatch

A client MUST refuse attachment to an incompatible protocol/artifact/JIF service.

Failure:

```text
DaemonVersionError
```

## RT-011 — Runtime crash

A Julia runtime crash:

- MUST NOT disable Bash-only commands;
- invalidates unrecoverable runtime handles;
- MAY destroy uncaptured raw session definitions;
- MUST NOT destroy persistent artifact source;
- returns structured runtime/stale-handle diagnostics.

# 13. JUL values, type categories, and environment affinity

JUL distinguishes high-level interchange values from environment-affine values.

## VAL-001 — High-level values

Canonical high-level classes:

```text
Null
Bool
Integer        # Int64
BigInt
Float          # Float64
Complex        # ComplexF64
Text
Bytes
ByteStream
Name
List
Map
Vector
Matrix
Tensor
Table
Graph
SymbolicExpression
Equation
EquationSystem
OptimizationProblem
Tool
ProcessResult
Error
PipelineBlock
```

## VAL-002 — Environment-affine values

Environment-affine by default:

```text
JuliaObject
Function
Ptr-backed object
open IO handle
Task
Channel
GPU context
opaque GPU object
package-native object without lossless JIF encoding
```

## VAL-003 — Affinity metadata

Every environment-affine value records:

```text
runtime_id
environment_generation_id
provider/type identity
```

## VAL-004 — No silent cross-environment transfer

An environment-affine value MUST NOT silently cross into another Julia environment generation or isolated worker.

Failure:

```text
NonInterchangeableValueError
```

or, when dependency incompatibility is the cause:

```text
DependencyConflictError
```

## VAL-005 — Dispatch

High-level operations dispatch by actual runtime value class plus the normative `OperationSpec`.

Unsupported input is `TypeError`.

No unsupported value is silently converted through human-readable text.

## VAL-006 — Type notation

Normative JUL type patterns use angle-bracket notation, not Julia `{}` syntax.

Examples:

```text
Any
Number
Integer
BigInt
Float
Complex
Text
Vector<Number>
Matrix<Number>
List<Text>
Map<Text,Any>
Table
Graph
JuliaObject
```

Unions use:

```text
A|B
```

`Number` means `Integer|BigInt|Float|Complex`.

`*` is allowed only as a generic inner wildcard:

```text
Vector<*>
Map<Text,*>
```

Julia spellings such as `Matrix{<:Number}` are not valid JUL type patterns.

# 14. JIF — JUL Interchange Format v1

JIF is the canonical cross-runtime representation for supported typed values.

It is used for:

- isolated tool-worker arguments/results;
- persistent fixtures;
- environment-generation session checkpoints;
- cross-process typed transport when native shared-object identity is unavailable.

JIF is NOT the authoritative source representation of executable tools.

## JIF-001 — Frame

A JIF v1 frame is:

```text
8 bytes    magic ASCII = "JULJIF1\n"
8 bytes    unsigned 64-bit big-endian header length H
H bytes    UTF-8 RFC-8785-canonical JSON header
remaining  binary payload segments, concatenated in header order
```

A decoder MUST reject a header length or payload declaration exceeding configured limits before allocating corresponding memory.

## JIF-002 — Canonical JSON

The header MUST be serialized according to RFC 8785 JSON Canonicalization Scheme (JCS).

NeuraBash adds these schema constraints:

1. header object field names and enum spellings are exactly those specified here;
2. optional fields with normative defaults MUST be omitted;
3. no Unicode normalization is performed before JCS serialization;
4. non-finite IEEE values are never represented as JSON numbers in the header;
5. semantic numeric values whose exact IEEE bit pattern matters are stored in binary payloads, not JSON numeric metadata;
6. shape/length/count/payload-length metadata encoded as JSON integers MUST satisfy `0 <= n <= 2^53 - 1`, the exact RFC-8785 / I-JSON safe-integer range;
7. larger header metadata is not representable in JIF v1 and MUST return `InterchangeError` rather than being rounded or stringified.

Identical JIF semantic values MUST therefore produce identical header bytes and payload bytes.

## JIF-003 — Top-level header

The header has exactly:

```json
{
  "jif": "1.0",
  "root": { "... value descriptor ..." },
  "segments": [
    {
      "length": 0,
      "role": "bytes",
      "sha256": "lowercase-hex"
    }
  ]
}
```

`segments` may be empty.

Segment offsets are implicit: payloads occur in the listed order immediately after the header.

## JIF-004 — Closed payload roles

JIF v1 role enum:

```text
bytes
bigint_decimal
numeric_scalar
dense_array
```

Unknown roles are `InterchangeError`.

## JIF-005 — Scalar encoding

```text
Null
    header descriptor only

Bool
    header descriptor with value true/false

Text
    header descriptor containing JCS JSON string

Name
    header descriptor containing JCS JSON string

Integer
    numeric_scalar payload, dtype=i64, 8 little-endian two's-complement bytes

Float
    numeric_scalar payload, dtype=f64, exact IEEE-754 binary64 bits

Complex
    numeric_scalar payload, dtype=c64, real Float64 bytes then imag Float64 bytes

BigInt
    bigint_decimal payload containing canonical ASCII decimal:
        optional leading "-"
        no "+"
        no leading zeros except "0"
        "-0" forbidden
```

JIF Float/Complex preserve:

- NaN payload bits;
- positive/negative infinity;
- signed zero.

## JIF-006 — Canonical dtype names

Closed v1 dtype enum:

```text
bool
i8 i16 i32 i64
u8 u16 u32 u64
f32 f64
c32 c64
```

Spellings are lowercase exactly.

## JIF-007 — Dense numeric arrays

`Vector`, `Matrix`, and `Tensor` descriptor fields:

```text
type
dtype
shape[]
layout="column_major"
segment=<index>
```

Payload:

- little-endian;
- densely packed;
- Julia/Fortran column-major logical order;
- no padding.

Before allocation, decoder MUST validate:

```text
product(shape) * sizeof(dtype) == declared segment length
```

using overflow-safe arithmetic.

## JIF-008 — Recursive List

`List` contains an ordered JSON array of child value descriptors.

Child descriptors may reference payload segments.

## JIF-009 — Map

JIF `Map` keys are Text only.

Descriptor contains a JSON object from Text key to child descriptor.

RFC 8785 determines canonical key ordering.

Runtime JUL maps with non-Text keys are non-interchangeable unless an operation explicitly converts them.

## JIF-010 — Table

A JIF Table descriptor contains:

```text
type="Table"
row_count
columns=[
  {"name": <Text>, "value": <Vector/List descriptor>},
  ...
]
```

Rules:

- column names are unique;
- column order is semantic and preserved;
- every column length equals `row_count`;
- duplicate names are `InterchangeError`.

## JIF-011 — Graph

Interchangeable Graph vertices are homogeneous:

```text
all Int64
or
all Text
```

Graph descriptor:

```text
directed
vertices
edges
weighted
```

Canonical graph ordering:

- Int64 vertices: ascending numeric;
- Text vertices: ascending UTF-8 byte sequence;
- edges: lexicographic `(src_key,dst_key[,weight_bits])`;
- undirected edges canonicalize endpoints so smaller key is first.

Parallel duplicate edges are not representable in v1 Core Graph unless the Graph contract explicitly declares multigraph support. Core `graph.build` rejects duplicates by default.

## JIF-012 — Symbolic AST

A JIF `SymbolicExpression` is provider-independent.

Node forms are exactly:

```text
Literal(value=<JIF scalar>)
Symbol(name=<Text>)
Unary(op=<operator_id>, arg=<node>)
Binary(op=<operator_id>, left=<node>, right=<node>)
Call(op=<operator_id>, args=[node...])
Comparison(op=<operator_id>, left=<node>, right=<node>)
```

Closed v1 operator IDs:

```text
add sub mul div mod pow neg pos
eq ne lt le gt ge
abs sqrt cbrt exp log log2 log10
sin cos tan asin acos atan sinh cosh tanh
floor ceil round min max sum prod
```

Provider-native symbolic nodes without a lossless mapping are environment-affine.

## JIF-013 — ErrorRecord

JIF Error values contain only the normative error fields from §31 plus JIF-interchangeable remediation metadata.

Provider-native exceptions/stack objects are NOT embedded.

They remain server-side behind `trace_id`.

## JIF-014 — Corruption validation

Decoder MUST reject:

- bad magic;
- unsupported JIF major version;
- truncated header;
- invalid RFC-8785 JSON;
- unknown descriptor type;
- unknown dtype/role;
- segment length mismatch;
- SHA-256 mismatch;
- shape overflow;
- duplicate Table column names;
- invalid BigInt decimal;
- cyclic descriptor structures;
- configured depth/size limit violations.

Failure is `InterchangeError`.

## JIF-015 — Version negotiation

Handshake advertises supported JIF major/minor ranges.

Major mismatch is incompatible.

Within major 1, a decoder MAY accept a newer minor only if every encountered field/type/role is known and the newer minor declares backward compatibility.

Unknown required semantics cause `InterchangeError`; they are never ignored silently.

## JIF-016 — Resource limits

Every decoder has configurable maxima for:

```text
frame bytes
header bytes
nesting depth
collection element count
array rank
array element count
individual payload bytes
```

Limit violation is `ResourceError`, not an attempted allocation.

## JIF-015A — Semantic identity for canonical bytes

For JIF canonical-byte purposes:

- Map insertion order is not semantic; RFC-8785 key ordering is canonical.
- Table column order is semantic and preserved.
- List/Vector/Matrix/Tensor element order is semantic.
- Graph ordering is the canonical ordering from JIF-011.
- Symbolic AST child order is semantic and source-order-preserving unless an explicit transformation created a different AST.
- Float/Complex identity is the exact IEEE bit pattern, including signed zero and NaN payload bits.
- BigInt identity is mathematical integer value; canonical decimal payload eliminates redundant spellings such as leading zeros.

Thus Maps differing only in insertion order encode identically, while NaNs with different payload bits encode differently.

# 15. Stream semantics

## STREAM-001 — Bash input

A Bash element connected to JUL through `|!>` supplies stdout as lazy raw `ByteStream`.

## STREAM-002 — Root input

A root JUL segment starts with `Null`, never a fabricated empty stream.

## STREAM-003 — Backpressure

Bridge transport uses bounded buffering and backpressure.

It MUST NOT consume unbounded upstream output into memory merely because the next stage is JUL.

## STREAM-004 — Materialization budget

Reference defaults:

```text
max_in_memory_materialization = 256 MiB
spill_to_disk                 = true
max_spill                     = 4 GiB
```

CLI/runtime configuration may change these through:

```text
--neura-memory-limit
--neura-spill-limit
```

## STREAM-005 — Spill storage

Spill files are private to the session security domain, budget-accounted, and deleted on successful completion.

Crash cleanup is best-effort.

Disk-full or budget exhaustion returns `ResourceError`.

## STREAM-006 — Cancellation during spill

Cancellation stops further consumption, closes spill files, and reports `CancelledError`.

## STREAM-007 — Encoding

`ByteStream` is raw bytes.

Text consumers explicitly declare UTF-8 or require `text.decode`.

Invalid UTF-8 under a UTF-8 contract is `DecodeError`.

## STREAM-008 — Binary safety

NUL and arbitrary byte values are legal.

No transport layer may assume C-string termination.

## STREAM-009 — Producer failure

Upstream Bash failure does not erase bytes already written.

JUL receives bytes until the upstream pipe closes.

Final status is governed by inherited pipeline/`pipefail` semantics.

## STREAM-010 — Downstream close / SIGPIPE

A JUL worker writing canonical output into a Bash pipe follows ordinary producer SIGPIPE semantics.

Normative default:

- SIGPIPE disposition for the process-visible JUL worker is the platform default;
- if the downstream reader closes and the worker is terminated by SIGPIPE, the worker status is signal-equivalent `141` on Linux (`128 + SIGPIPE`);
- `PIPESTATUS` records that value;
- `pipefail` observes it exactly as for an ordinary producer;
- no extra JUL error diagnostic is emitted solely for SIGPIPE.

If the implementation detects `EPIPE` rather than receiving the signal, it MUST translate the condition into the same shell-visible status and cancel internal work feeding that output.

## STREAM-011 — Semantic failure after partial output

A rendering/computation failure other than ordinary SIGPIPE after partial bytes were emitted returns the mapped nonzero error status and includes:

```text
partial_output_possible: true
```

in the structured diagnostic.

This is distinct from ordinary downstream-close behavior.

## STREAM-012 — Back-cancellation

When downstream SIGPIPE/EPIPE ends a JUL worker, internal Julia computation producing that stream SHOULD be cancelled promptly to avoid useless continued work.

Failure to cancel promptly is a performance bug, not permission to change the shell-visible status.

# 16. JUL-to-Bash rendering

An ordinary Bash pipe following JUL ends typed mode.

## BOUND-001

Crossing JUL -> Bash requires bytes.

## BOUND-002 — Canonical shell renderer

Baseline renderers:

```text
Text      -> UTF-8 bytes exactly
Bytes     -> raw bytes
Bool      -> ASCII "true" or "false"
Integer   -> canonical decimal ASCII
Float     -> round-trip-safe ASCII representation
Complex   -> canonical "a+bi" form
Vector    -> newline-delimited element shell rendering
Matrix    -> TSV rows
Table     -> TSV with header
```

## BOUND-003

A type lacking a canonical shell renderer returns `BoundaryRenderError`.

No arbitrary `show()` dump is used as a pipe format.

## BOUND-004 — TTY pretty output

If a foreground JUL result is the final command and stdout is a TTY, NeuraBash MAY pretty-render it.

TTY pretty rendering is presentation only.

## BOUND-005 — Non-TTY determinism

When stdout is piped, redirected, or captured, canonical shell rendering is mandatory.

## BOUND-006 — Partial output failure

If rendering emits partial bytes and then fails, the JUL segment exits nonzero and stderr reports that partial output may have been observed.

---

# 17. Pipeline status and shell-control contract

A contiguous JUL segment is exactly one Bash pipeline element for process/status purposes.

## PIPE-001

The JUL segment's shell status is exactly its corresponding `PIPESTATUS` entry.

## PIPE-002

Normal successful JUL completion exits `0`.

## PIPE-003

A typed Bool result does not automatically become shell truth.

## PIPE-004 — `shell.require`

`Bool |!> shell.require` preserves the typed Bool and sets the JUL segment process status:

```text
true  -> 0
false -> 1
```

`shell.require` is terminal-only in v0.0.x. It MUST be the final stage of its JUL segment.

Any source shaped as:

```text
... |!> shell.require |!> another.stage
```

fails JUL AST validation with `ParseError` before execution. No sticky-status semantics exist.

## PIPE-005 — Error-as-value versus raised failure

A typed `Error` returned as data exits `0`.

A raised/unhandled NeuraBash error exits according to §32.

To raise a typed Error:

```text
core.raise
```

## PIPE-006 — SIGPIPE

Ordinary downstream-close SIGPIPE uses §15 STREAM-010 and is not remapped into a NeuraBash error code.

## PIPE-007 — `!`

Bash prefix `!` negates only the final mixed pipeline status.

It does not rewrite individual JUL/Bash `PIPESTATUS` entries.

## PIPE-008 — Required control-flow tests

The same mixed pipelines MUST be tested under:

```text
default status
pipefail
set -e
if
while
until
!
time
background
PIPESTATUS
SIGPIPE
```

# 18. Signals and job control

## SIG-001

A foreground JUL segment is part of the foreground pipeline process group.

## SIG-002

SIGINT requests cancellation of the active JUL request and produces normal shell-visible interruption behavior.

## SIG-003

SIGTERM requests cancellation, then terminates the JUL pipeline worker if graceful cancellation does not complete.

## SIG-004

SIGPIPE/broken pipe from downstream is honored.

## SIG-005

Background mixed pipelines MUST work with:

```text
jobs
fg
bg
wait
kill %job
Ctrl-Z / SIGTSTP where upstream Bash supports it
```

## SIG-006

Cancellation MUST leave NeuraBash-owned persistent registries transactionally valid.

## SIG-007

If an effectful operation is cancelled after external effects may have occurred, the structured cancellation record MUST include:

```text
partial_effects_possible: true
```

when known.

---

# 19. Binding model

Canonical operations:

```text
core.bind
core.drop
core.list
```

Example:

```bash
cat A.csv |!> matrix.read |!> core.bind A
|!> @A |!> matrix.rank
```

## BIND-001

Bindings reference typed runtime values.

## BIND-002

Bindings are client-session-local unless explicitly snapshotted into an artifact/fixture.

## BIND-003

Overwrite is rejected by default.

```text
core.bind A --replace
```

permits explicit overwrite.

## BIND-004

After runtime restart:

- restored JIF-compatible bindings may remain valid;
- unrecoverable known bindings return `StaleHandleError`;
- names never defined return `UnknownBindingError`.

---

# 20. Environment generations and multi-client semantics

Julia cannot safely unload arbitrary already-loaded package versions.

NeuraBash therefore uses immutable, linear workspace environment generations.

## ENVGEN-001 — Linear history

Each workspace has exactly one linear generation history:

```text
G1 -> G2 -> G3 -> ...
```

and exactly one atomically stored `current_generation_id`.

Branching workspace generation histories are forbidden in v0.0.x.

## ENVGEN-002 — Immutable generation record

Each generation stores:

```text
generation_id
parent_generation_id
Project.toml
Manifest.toml
manifest_hash
core_pack_version
created_at
```

After commit, the Project/Manifest bytes of a generation are immutable.

## ENVGEN-003 — Session pin

Each logical JUL session is pinned to exactly one generation.

A session does not change generations merely because another client advances the workspace current pointer.

## ENVGEN-004 — New sessions

A new workspace session pins to the workspace's current generation.

## ENVGEN-005 — Package mutation precondition

A session may create a successor generation only when its pin equals the workspace current generation.

If:

```text
session_pin != current_generation
```

then `pkg.use` / `pkg.remove` fail with:

```text
GenerationPinnedError
```

Remediation includes:

```text
pkg.refresh
```

## ENVGEN-006 — Staging and atomic commit

Under the workspace environment lock:

1. resolve from the current generation;
2. create a staging generation directory;
3. write Project/Manifest completely;
4. validate parse/hash/core-pack constraints;
5. complete brokered download/build/precompile required by policy;
6. atomically rename staging -> immutable generation directory;
7. atomically replace `current_generation_id`.

Crash before step 6 leaves only disposable staging state.

Crash after step 6 but before step 7 leaves a valid orphan generation not current.

Crash after step 7 leaves a valid committed current generation.

In v0.0.x, startup maintenance MAY automatically remove only never-committed staging directories. It MUST NOT automatically delete any committed environment generation, whether current or historical.

Explicit committed-generation garbage collection is deferred to a future specified operation.

## ENVGEN-007 — Other clients after commit

When Session A commits G2:

- A may migrate according to ENVGEN-009;
- Session B already pinned to G1 continues running on G1;
- B is not forcibly restarted;
- B's in-flight requests are not cancelled by A's commit;
- B cannot mutate packages until it refreshes to current.

## ENVGEN-008 — Busy calling session

The calling session MUST have no other active JUL requests when performing an activation/restart.

If active work exists:

```text
SessionBusyError
```

unless the caller uses:

```text
--wait
```

which waits for that session's existing requests to quiesce.

Other sessions do not block generation commit except through the environment mutation lock.

## ENVGEN-009 — Default activation: restart-preserve

Before committing an operation whose default activation is `restart-preserve`, NeuraBash computes a migration plan for the invoking session:

```text
JIF-restorable bindings
environment-affine bindings
uncaptured raw Julia definitions
session tools dependent on runtime state
```

If migration would lose environment-affine bindings or uncaptured definitions, the operation does NOT commit by default and returns `GenerationMigrationError` with the loss set.

The caller may choose:

```text
--activate=defer
```

or:

```text
--drop-affine
```

## ENVGEN-010 — `--drop-affine`

When explicitly selected:

1. commit the new generation;
2. checkpoint JIF-compatible bindings;
3. stop the old runtime;
4. start runtime on new generation;
5. restore JIF bindings;
6. mark lost environment-affine bindings/definitions stale or absent;
7. return a complete activation report.

No loss is silent.

## ENVGEN-011 — Deferred activation

`--activate=defer` commits the new generation/current pointer but keeps the invoking session pinned to its old generation.

Its next package mutation is therefore rejected until `pkg.refresh`.

## ENVGEN-012 — `pkg.refresh`

`pkg.refresh` migrates a non-current session to the current workspace generation.

It performs the same migration preflight as ENVGEN-009.

Default refresh refuses lossy migration.

`pkg.refresh --drop-affine` explicitly accepts loss.

## ENVGEN-013 — Runtime restart failure

If a generation is committed successfully but the invoking session's restart fails:

- the workspace current pointer remains on the valid new generation;
- the old session remains pinned to its prior generation if still alive;
- the command returns `RuntimeRestartError`;
- remediation includes retrying `pkg.refresh`.

NeuraBash MUST NOT automatically roll back the shared current pointer after commit because other clients may already have observed/attached to it.

## ENVGEN-014 — Generation retention

Committed generation records and their Project/Manifest metadata are retained for the life of the workspace in v0.0.x.

Package/cache garbage collection MAY reclaim reproducible provider download/precompile cache entries only when the immutable generation remains reconstructible. A live session's pinned generation resources MUST remain loadable for that session's lifetime.

If a reclaimed reproducible cache entry is later required, it may be reconstructed from the pinned generation under active package/security policy. Failure is `PackageError`, never silent substitution of another generation.

## ENVGEN-015 — Validation context

Tool validation records include the exact generation manifest hash.

A tool may be PASSING in G1 and STALE/BLOCKED/UNTESTED in G2 without mutating its source revision.

# 21. Package model

## PKG-001 — Core Pack

NeuraBash ships or bootstraps a release-pinned Core Pack containing the dependencies required by mandatory Level-1 operations.

Core Pack versions are authoritative within a NeuraBash release.

A standard primitive MUST NOT secretly install or replace a provider package.

## PKG-002 — Core Pack immutability

If a requested workspace package constraint conflicts with a Core Pack package/version requirement:

```text
CorePackConflictError
```

is returned.

There is NO `--override-core-pack` in v0.0.x.

Remediation may suggest:

- compatible version;
- source-backed/raw Julia isolated tool;
- a different NeuraBash release.

## PKG-003 — Explicit package mutation

`pkg.use` and `pkg.remove` are explicit brokered package mutation operations.

They never mutate the active immutable generation in place.

## PKG-004 — Version-constraint grammar

Package request:

```text
NAME[@CONSTRAINT]
```

Canonical constraints:

```text
NAME
NAME@1.2            # shorthand for ^1.2
NAME@1.2.3          # shorthand for ^1.2.3
NAME@^1.2
NAME@~1.2
NAME@=1.2.3         # exact
NAME@>=1.2,<2.0
```

Semantics:

```text
^a.b.c
    SemVer-compatible caret range

~a.b
    >=a.b.0 and <a.(b+1).0

=a.b.c
    exact version

comma
    logical intersection of range clauses
```

The parser MUST expose the normalized interval set in `pkg.use --plan` and `pkg.info`.

Invalid constraints are `ArgumentError`.

## PKG-005 — Synchronous default

Package mutation is synchronous by default.

It MUST:

- emit compact progress on stderr;
- be cancellable;
- obey configurable timeout;
- return structured result.

Reference timeout:

```text
10 minutes
```

## PKG-006 — Locking

Workspace generation mutation uses the inter-process environment lock in §35.

Per-session serialization alone is insufficient.

## PKG-007 — Explicit request precedence for non-Core tools

A valid explicit `pkg.use` request may advance the workspace generation even if ordinary workspace/user tools will require revalidation.

After resolution:

```text
tool dependency constraint unsatisfied
    -> BLOCKED in the new context

constraint still satisfied but no validation record for new context
    -> STALE in the new context

matching validation record
    -> PASSING
```

Artifact source/revisions themselves are not rewritten.

## PKG-008 — Strict tool preservation

```text
pkg.use X --strict-tools
pkg.remove X --strict-tools
```

fail with `DependencyConflictError` if any currently visible registered tool that is PASSING in the current context would become STALE or BLOCKED.

Core Pack conflict always fails regardless of this flag.

## PKG-009 — Planning

```text
pkg.use X --plan
pkg.remove X --plan
```

perform no mutation.

Planning reads `current_generation_id` exactly once at plan start and uses that immutable generation as `base_generation`. It does not acquire the environment mutation lock.

A concurrent commit may make the returned plan stale before printing; the plan remains truthful against its recorded base generation. A later real mutation re-checks the caller's generation pin and re-resolves; a returned plan is never blindly committed.

Plan output contains:

```text
base_generation
proposed_manifest_hash
package changes
affected tool statuses
Core Pack check
session migration impact
activation mode
```

## PKG-010 — Broker boundary

Package resolution/download/build/artifact acquisition/precompile are brokered substrate operations.

A hardened runtime consumes an immutable resolved generation.

The broker is not arbitrary raw Julia inside the sandbox.

## PKG-011 — Isolated tool execution

An isolated tool worker has its own Julia environment and the minimal NeuraBash JIF/runtime shim.

It does NOT automatically load the workspace Core Pack.

It may use standard JUL operations only if their providers are explicitly available and compatible in that isolated environment.

Inputs and outputs MUST be JIF-interchangeable.

## PKG-012 — Environment-affine exclusion

Environment-affine values cannot cross into an incompatible isolated environment.

No render-to-text fallback exists.

## PKG-013 — `pkg.refresh`

`pkg.refresh` is defined by §20 and is the only standard operation that migrates an already-running stale-pinned client to the workspace current generation.

## PKG-014 — `pkg.search`

Default `pkg.search` uses already available registry/cache state and is `READ_FS`.

```text
pkg.search QUERY --refresh
```

may use `NETWORK` through the package broker after policy approval.

# 22. Package and generation result formats

## PKGRES-001 — `PackageChangePlan`

`pkg.use/remove --plan` returns:

```text
requested_package
requested_constraint
base_generation
proposed_manifest_hash
package_changes[]
affected_tools[]
core_pack_conflicts[]
migration:
    jif_bindings[]
    affine_bindings[]
    uncaptured_definitions[]
activation_mode
```

## PKGRES-002 — `PackageChangeResult`

Successful commit returns:

```text
package
requested_constraint
resolved_version
old_generation
new_generation
manifest_hash
changed
precompiled
elapsed_ms
affected_tools[]
activation_mode
restored_bindings[]
stale_or_lost_bindings[]
lost_definitions[]
```

## PKGRES-003 — `RefreshResult`

`pkg.refresh` returns:

```text
old_generation
new_generation
restored_bindings[]
stale_or_lost_bindings[]
lost_definitions[]
elapsed_ms
```

## PKGRES-004 — Package failure

Structured package failure contains:

```text
package
constraint
resolver_message
conflicting_constraints[]
requesting_tools[]
core_pack_conflict
recoverable
remediation[]
```

# 23. Forge tool model and parameter semantics

A tool is a named reusable JUL computation.

Implementation kinds:

```text
JUL_PIPELINE
JULIA_SOURCE
PACKAGE_ADAPTER
```

Custom tool names in v0.0.x are unqualified identifiers and may not shadow reserved stdlib qualified names.

## TOOL-001 — Composition-first definition

Canonical parameterless tool:

```bash
|!> tool.define spectral_radius @{
    matrix.eig --values-only
    |!> vector.abs
    |!> vector.max
}
```

Default tool input policy is `REQUIRED`.

## TOOL-002 — Typed named parameters

Tools may declare zero or more named parameters with repeated:

```text
--param="NAME:TYPE"
--param="NAME:TYPE=DEFAULT_LITERAL"
```

Parameter declaration grammar:

```ebnf
param_decl = ident , ":" , type_pattern , [ "=" , default_literal ] ;
```

The declaration is carried inside a JUL string argument to `--param`.

Inside that declaration string:

1. split at the first `:` not inside a quoted default literal;
2. parse the type using §13;
3. split at the first later `=` not inside a quoted literal, if present;
4. parse the default with JUL literal grammar only;
5. defaults MUST be JIF-interchangeable literals and cannot be binding/fixture/parameter references.

Examples:

```text
--param="factor:Float=1.0"
--param='label:Text="a:b=c"'
--param='columns:List<Text>=["a","b"]'
```

Parameter names MUST NOT begin with literal prefix `exec-`. Such a declaration returns `ArgumentError`; `exec-*` is reserved across direct-stage and `tool.run` paths.

Parameters are named-only at invocation time.

Example:

```bash
|!> tool.define scaled_radius \
    --param="factor:Float=1.0" @{
        matrix.eig --values-only
        |!> vector.abs
        |!> vector.max
        |!> math.scale @param.factor
    }
```

(`math.scale` must exist in the operation registry for this example to be executable; the parameter semantics do not depend on this particular operation.)

## TOOL-003 — Parameter references

Inside a tool body:

```text
@param.factor
```

resolves the immutable invocation parameter.

Parameter lookup precedes no session binding because the namespace is syntactically distinct.

## TOOL-004 — Tool input contract

Definition option:

```text
--input=none|optional|required
```

Default is:

```text
required
```

The incoming pipeline value is the tool's implicit primary input.

## TOOL-005 — Direct stage invocation

A registered tool is callable as a normal unqualified stage:

```bash
|!> @A |!> scale --factor=2
```

Invocation validation:

- missing required param -> `ArgumentError`;
- unknown param -> `ArgumentError`;
- type mismatch -> `TypeError`;
- params are immutable for that call.

## TOOL-006 — `tool.run` equivalence

`tool.run` is the explicit control-plane invocation path.

Reserved execution options all use `--exec-*` and are never forwarded as tool parameters:

```text
--exec-input=@A
--exec-isolated
--exec-allow-stale
```

All other options are matched against the tool's declared params.

Thus:

```bash
|!> @A |!> scale --factor=2
```

and:

```bash
|!> tool.run scale --exec-input=@A --factor=2
```

MUST produce equivalent tool semantics in ordinary non-isolated, non-stale execution.

## TOOL-007 — Multiple logical inputs

Additional inputs are declared as named parameters whose types may include JIF values.

Example tool signature:

```text
input: Table
params:
    other: Table
    on: Text
```

Invocation:

```bash
|!> @A |!> join_tables --other=@B --on=id
```

There is no implicit positional second input.

## TOOL-008 — Session Julia symbol

```bash
|!> tool.define my_op --julia-symbol=my_op
```

creates a SESSION-ONLY tool unless reconstructible captured source is attached.

## TOOL-009 — Source-backed Julia tool

Persistent Julia tool forms:

```bash
|!> tool.define my_op \
    --julia-source=/path/op.jl \
    --symbol=my_op \
    --source-dep=/path/helper.jl
```

or:

```bash
|!> julia.block --capture=my_source <<'JULIA'
...
JULIA

|!> tool.define my_op \
    --julia-artifact=my_source \
    --symbol=my_op
```

The primary source and declared source dependencies are copied into the immutable revision.

## TOOL-010 — Persistent registration guard

`tool.register` MUST reject a `JULIA_SOURCE` tool lacking reconstructible captured source.

Failure:

```text
SourceCaptureError
```

## TOOL-011 — Stable tool identity

Within one scope, the first persistent registration of a new tool name creates one stable:

```text
artifact_id
```

All later revisions of that same tool identity retain the same `artifact_id`.

`revision` is a monotonically increasing positive integer.

`content_hash` is per revision.

## TOOL-012 — Tool contract

Every revision records:

```text
name
artifact_id
revision
scope
implementation_kind
source_or_ir
input_policy
input_contract
params[]
output_contract
semantic_effects
dependency_constraints
tests
documentation
artifact_schema_version
content_hash
created_against_neurabash_version
created_against_julia_version
```

## TOOL-013 — Scopes

```text
session
workspace
user
```

Custom tool lookup:

```text
session
workspace
user
```

Stdlib qualified names are resolved separately and cannot be shadowed.

## TOOL-014 — Registration policy

Persistent registration:

```text
PASSING  -> allowed
UNTESTED -> rejected unless --allow-untested
FAILING  -> rejected
STALE    -> rejected
BLOCKED  -> rejected
```

An `--allow-untested` registration records that fact permanently in revision metadata.

## TOOL-015 — Contextual status

`PASSING`, `STALE`, and `BLOCKED` are evaluated relative to a validation/runtime context, not globally burned into source.

A user-scope tool can therefore be PASSING in workspace A and BLOCKED in workspace B without mutating the artifact revision.

# 24. Tool tests, fixtures, comparators, and validation context

Persistent validation MUST be reproducible without ephemeral session bindings.

## TEST-001 — Immutable fixture

A persistent fixture is:

```text
fixture_id
name
jif_sha256
jif_bytes
created_at
```

Fixture bytes are immutable and content-addressed by SHA-256.

Creating another fixture with identical JIF bytes MAY deduplicate storage.

## TEST-002 — Snapshot

```bash
|!> tool.fixture.snapshot @A --name=matrix_A
```

succeeds only for JIF-interchangeable values.

The snapshot is serialized immediately into canonical JIF; it does not retain a live object handle.

## TEST-003 — Fresh decode

Every test invocation decodes fixture input into a fresh runtime value.

Mutation by one test cannot mutate the stored fixture or another test's input.

## TEST-004 — Test case

Persistent test record:

```text
input_fixture_or_inline_jif
parameter_values
expected_fixture_or_inline_jif
comparator_id
comparator_options
required_effects
```

No naked session binding reference may be persisted.

## TEST-005 — Built-in comparator IDs

v0.0.x provides versioned comparators:

```text
exact@1
approx@1
type@1
shape@1
```

Semantics:

```text
exact@1
    JUL structural equality from check.equal

approx@1
    numeric scalar/array elementwise tolerance using `atol`/`rtol`;
    accepted comparator options are `--atol` and `--rtol`;
    `--tol` is NOT an alias in v0.0.x

type@1
    check.type pattern match

shape@1
    check.shape match
```

Comparator version is part of the test-suite hash.

Custom executable comparators are not used for persistent PASSING state in v0.0.x.

## TEST-006 — Nondeterministic/effectful tools

A persistent PASSING claim requires deterministic test predicates.

Effectful tools MAY be tested, but results are only valid for the recorded validation context and security profile.

External-world nondeterminism is not magically made reproducible.

## TEST-007 — Security profile

`tool.test` executes under the session security profile active at the instant `tool.test` is invoked.

The profile used when a test was added, fixture was snapshotted, or tool was registered does not override the invocation-time profile.

The invocation-time profile id is recorded in the validation context hash.

If required effects are denied by policy, the test result is:

```text
BLOCKED
```

not `FAILING`.

## TEST-008 — Validation context hash

Every validation record is keyed by a canonical hash over at least:

```text
tool artifact_id + revision
tool content_hash
test-suite hash
environment manifest hash
Core Pack version
Julia version
NeuraBash version
security profile id
comparator ids/versions
```

## TEST-009 — Status

For the current context:

```text
UNTESTED
PASSING
FAILING
STALE
BLOCKED
```

Definitions:

```text
UNTESTED
    no validation record exists

PASSING
    all persistent tests passed under exactly matching context

FAILING
    at least one test semantically failed under matching context

STALE
    prior validation exists, dependencies remain satisfiable,
    but current context hash differs

BLOCKED
    dependencies or required capabilities cannot currently be satisfied
```

## TEST-010 — Stale execution

STALE/BLOCKED tools refuse direct normal execution.

Explicit experimental override:

```text
tool.run NAME --exec-allow-stale
```

is allowed only when the tool is loadable and policy permits; the override is logged in provenance.

# 25. Tool removal, revision history, and migration

## LIFE-001 — Session removal

Removing a session-only tool deletes the session definition.

## LIFE-002 — Persistent revision removal

```text
tool.remove NAME --revision=N
```

tombstones only revision N.

It does not delete the stable tool `artifact_id` or other revisions.

## LIFE-003 — Whole-tool tombstone

```text
tool.remove NAME --all-revisions
```

tombstones the name/current pointer and all revisions from normal lookup.

Historical content remains until explicit administrative garbage collection.

## LIFE-004 — Current revision

The highest non-tombstoned registered revision is current unless an explicit rollback operation is later standardized.

`tool.find` returns current revision by default.

## LIFE-005 — Standard operation IDs

Persistent JUL pipeline IR stores versioned canonical operation IDs:

```text
matrix.svd@1
```

not display names alone.

## LIFE-006 — Compatibility alias

A standard-library rename MAY provide explicit compatibility alias metadata.

No heuristic migration is allowed.

## LIFE-007 — Failed migration

Missing operation/provider with no declared migration results in contextual:

```text
STALE
```

or:

```text
BLOCKED
```

Invocation raises `ToolInvalidatedError`.

# 26. Artifact and source storage

## ART-001 — Authoritative representation

Persistent executable artifact authority is:

```text
source_or_ir
tool contract
declared source dependencies
tests
fixture references
dependency constraints
normative metadata
hashes
```

## ART-002 — Runtime serialization is disposable

Julia `Serialization`, JIT products, method instances, native code caches, and live object graphs MUST NOT be the only persistent representation.

## ART-003 — Atomic writes

Workspace/user artifact revisions are staged, hashed, fsynced as appropriate, then atomically published.

Readers observe complete old or complete new metadata, never partial files.

## ART-004 — Content hash

Each revision's `content_hash` is SHA-256 over a canonical artifact manifest plus exact authoritative source/IR bytes in deterministic file order.

Runtime timestamps not required for semantics are excluded from the hash.

## ART-005 — Integrity

Hash mismatch or missing authoritative source produces:

```text
ArtifactIntegrityError
```

and the artifact MUST NOT execute.

## ART-006 — Raw Julia source tree

For source-backed Julia tools, captured source files are stored beneath an artifact-local source root.

At tool-load time:

- entry source path is artifact-relative;
- declared source dependencies are available under captured relative names;
- the original external filesystem source path is irrelevant.

Runtime filesystem/network reads performed by the tool remain ordinary effects and are not treated as source dependencies automatically.

## ART-007 — Semantic reproducibility claim

"Reconstructible" means NeuraBash has sufficient executable source/IR and declared package constraints to attempt loading the same revision.

It does NOT mean an effectful raw-Julia tool will produce identical output when external state differs.

# 27. Standard operation contract schema and documentation records

Every Level-1 operation MUST have a machine-readable `OperationSpec`.

Required fields:

```text
name
operation_id
input_policy
accepted_input_types
positional_arguments[]
options[]
output_type
semantic_effects[]
streaming_behavior
provider
errors[]
short_help
example
stability
```

`stability` is:

```text
core
experimental
```

Only `core` operations are mandatory for v0.0.x conformance.

## OPSPEC-001 — `help.concise`

`help.concise OP` returns a typed Map with exactly:

```text
name
operation_id
short_help
input_policy
accepted_input_types
positional_arguments
options
output_type
semantic_effects
stability
example
related
```

## OPSPEC-002 — `help.deep`

`help.deep OP` returns all `help.concise` fields plus:

```text
provider
errors
streaming_behavior
provider_version
notes
```

## OPSPEC-003 — `inspect.value`

`inspect.value` returns a typed Map with exactly these baseline fields:

```text
jul_type
julia_type
interchangeable
environment_generation
length
shape
estimated_bytes
preview
```

Fields not applicable are `Null`.

Normative field semantics:

```text
jul_type
    §13 JUL type notation

julia_type
    stable textual Julia runtime type name where available, else Null

interchangeable
    Bool

environment_generation
    generation id for environment-affine/runtime-backed values, else Null

length
    Text -> Unicode scalar-value count
    Bytes -> byte count
    List/Vector -> element count
    Map -> entry count
    Table -> row count
    Matrix/Tensor -> total element count
    otherwise Null

shape
    Vector -> [n]
    Matrix/Tensor -> dimensions
    Table -> [rows, columns]
    otherwise Null

estimated_bytes
    JIF-interchangeable -> exact canonical JIF v1 frame byte length
    environment-affine -> Null
```

`preview`:

1. use the canonical shell renderer when one exists;
2. if UTF-8 output is <=80 bytes, return all of it;
3. otherwise truncate to the longest code-point boundary at or below 80 bytes and append U+2026 `…`;
4. if no canonical shell renderer exists, return Null;
5. arbitrary `JuliaObject` preview is Null.

`inspect.value` MUST NOT call arbitrary user-defined Julia `show` methods.

## OPSPEC-004 — `tool.find`

`tool.find QUERY` returns a Table with ordered columns:

```text
name
scope
artifact_id
revision
status
implementation_kind
input_contract
output_contract
effects
content_hash
```

Rows are ordered by exact-name match first, then scope precedence, then lexical name, then descending revision.

## OPSPEC-005 — Machine discoverability

No operation is conforming merely because its name exists.

Its `OperationSpec`, concise help, deep help, and conformance tests MUST exist.

# 28. Level-1 standard library contracts

The contracts below are normative for operations marked CORE.

Notation:

```text
INPUT_POLICY
IN
ARGS
OPTIONS
OUT
FX
ERR
```

All unspecified options are invalid.

## 28.1 Core data/session operations

### core.bind — CORE

```text
INPUT_POLICY: REQUIRED
IN: Any
ARGS: Name
OPTIONS: --replace::Bool=false
OUT: same input value
FX: session-state mutation only
ERR: ArgumentError
```

### core.drop — CORE

```text
INPUT_POLICY: NONE
ARGS: Name
OUT: Bool
FX: session-state mutation only
ERR: UnknownBindingError
```

### core.list — CORE

```text
INPUT_POLICY: NONE
OUT: Table(name,type,state,interchangeable)
FX: PURE
```

### core.type — CORE

```text
INPUT_POLICY: REQUIRED
IN: Any
OUT: Text using §13 JUL type notation
FX: PURE
```

### core.collect — CORE

```text
INPUT_POLICY: REQUIRED
IN: ByteStream | iterable high-level value
OPTIONS: --limit=<nonnegative integer>
OUT:
    ByteStream -> Bytes
    iterable   -> Vector/List as appropriate
FX: PURE plus runtime temp/storage effects
ERR: ResourceError, TypeError
```

### core.raise — CORE

```text
INPUT_POLICY: REQUIRED
IN: Error
OUT: none
FX: PURE
ERR: raises supplied Error
```

## 28.2 Text/bytes

### text.decode — CORE

```text
INPUT_POLICY: REQUIRED
IN: ByteStream | Bytes
OPTIONS: --encoding=utf-8
OUT: Text
FX: PURE
ERR: DecodeError, ResourceError
```

Only UTF-8 is mandatory in v0.0.x.

### text.encode — CORE

```text
INPUT_POLICY: REQUIRED
IN: Text
OPTIONS: --encoding=utf-8
OUT: Bytes
FX: PURE
```

### text.lines — CORE

```text
INPUT_POLICY: REQUIRED
IN: Text
OUT: Vector<Text>
FX: PURE
```

Line separators recognized:

```text
\n
\r\n
\r
```

Terminators are removed.

Rules:

```text
""            -> []
"a\nb"        -> ["a","b"]
"a\nb\n"      -> ["a","b"]
"\n"          -> [""]
"a\n\nb"      -> ["a","","b"]
```

A single final line terminator does not create an extra trailing empty element.

### text.split — CORE

```text
INPUT_POLICY: REQUIRED
IN: Text
ARGS: Text separator
OUT: Vector<Text>
FX: PURE
ERR: ArgumentError if separator is empty
```

Separator is a literal substring, not regex.

Adjacent separators preserve empty interior fields:

```text
"a..b" split "." -> ["a","","b"]
```

Trailing separator preserves the final empty field:

```text
"a." split "." -> ["a",""]
```

### text.join — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector<Text> | List<Text>
ARGS: Text separator
OUT: Text
FX: PURE
```

### bytes.collect — CORE

```text
INPUT_POLICY: REQUIRED
IN: ByteStream
OUT: Bytes
FX: PURE
ERR: ResourceError
```

### bytes.length — CORE

```text
INPUT_POLICY: REQUIRED
IN: Bytes
OUT: Integer
FX: PURE
```

## 28.3 Math/vector/matrix

### math.eval — CORE

Defined by §29.

### math.simplify — ALIAS

`math.simplify` is an alias of `symbolic.simplify` when input is `SymbolicExpression`.

### math.scale — CORE

```text
INPUT_POLICY: REQUIRED
IN: Number | Vector<Number> | Matrix<Number>
ARGS: Number factor
OUT: same shape/category with promoted numeric element type
FX: PURE
```

### vector.abs — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector<Number>
OUT: Vector<Real>
FX: PURE
```

Complex elements map to magnitude.

### vector.sum — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector<Number>
OUT: Number
FX: PURE
```

Empty numeric vector returns additive identity of its element type when element type is known; otherwise `ArgumentError`.

### vector.mean — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector<Number>
OUT: Float | Complex
FX: PURE
ERR: ArgumentError on empty vector
```

### vector.max / vector.min — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector<Orderable>
OUT: element
FX: PURE
ERR: ArgumentError on empty vector
```

Complex values are not Orderable.

### vector.sort — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector<Orderable>
OPTIONS: --reverse::Bool=false
OUT: Vector
FX: PURE
```

Sort is stable.

### vector.norm — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector<Number>
OPTIONS: --p=<Number>, default=2
OUT: Float
FX: PURE
ERR: ArgumentError for p<=0 except p=Inf
```

### matrix.read — CORE

```text
INPUT_POLICY: STREAM_REQUIRED
IN: ByteStream | Bytes | Text
OPTIONS:
    --format=auto|csv|tsv|whitespace
    --header::Bool=false
OUT: Matrix<Number>
FX: PURE
ERR: DecodeError, ParseError, TypeError, ResourceError
```

`auto` rule:

1. inspect first non-empty logical line;
2. comma only -> csv;
3. tab only -> tsv;
4. neither -> whitespace;
5. both comma and tab -> `ParseError`, require explicit format.

If `--header=true`, first row is ignored as labels and never becomes matrix data.

All remaining cells MUST parse as numbers under §29 numeric rules.

### matrix.from_table — CORE

```text
INPUT_POLICY: REQUIRED
IN: Table
OPTIONS: --columns=[Name...]
OUT: Matrix<Number>
FX: PURE
ERR: TypeError, ArgumentError
```

If `--columns` omitted, all columns MUST be numeric.

### matrix.shape — CORE

```text
INPUT_POLICY: REQUIRED
IN: Matrix | Tensor
OUT: Vector<Integer>
FX: PURE
```

### matrix.transpose — CORE

```text
INPUT_POLICY: REQUIRED
IN: Matrix<Number>
OUT: Matrix<Number>
FX: PURE
```

### matrix.inverse — CORE

```text
INPUT_POLICY: REQUIRED
IN: square Matrix<Number>
OUT: Matrix<Number>
FX: PURE
ERR: TypeError, MathDomainError
```

Singular matrix -> `MathDomainError`.

### matrix.rank — CORE

```text
INPUT_POLICY: REQUIRED
IN: Matrix<Number>
OPTIONS: --tol=<Float>
OUT: Integer
FX: PURE
```

When `--tol` is omitted, provider default tolerance is allowed but MUST be reported by `help.deep` and test tolerances MUST not assume cross-BLAS bit identity.

### matrix.det — CORE

```text
INPUT_POLICY: REQUIRED
IN: square Matrix<Number>
OUT: Number
FX: PURE
```

### matrix.eig — CORE

```text
INPUT_POLICY: REQUIRED
IN: square Matrix<Number>
OPTIONS:
    --values-only::Bool=false
OUT:
    values-only -> Vector<Complex>
    default     -> Map{"values":Vector<Complex>,"vectors":Matrix<Complex>}
FX: PURE
ERR: TypeError, JuliaError
```

All outputs are promoted to `ComplexF64` for a stable type contract, including real spectra.

Eigenvalue order is ascending lexicographic:

```text
(real(value), imag(value))
```

Eigenvectors are reordered to match.

For repeated eigenvalues, basis choice inside the repeated eigenspace is provider-dependent and conformance MUST check residuals/subspace validity, not exact vector bytes.

### matrix.svd — CORE

```text
INPUT_POLICY: REQUIRED
IN: Matrix<Number>
OPTIONS: --full::Bool=false
OUT: Map{"U":Matrix,"S":Vector<Float>,"Vt":Matrix}
FX: PURE
ERR: TypeError, JuliaError
```

Let `A` be `m x n`, `k=min(m,n)`.

`--full=false`:

```text
U  m x k
S  k
Vt k x n
A ≈ U * Diagonal(S) * Vt
```

`--full=true`:

```text
U  m x m
S  k
Vt n x n
```

Singular values are nonnegative descending.

Column/row signs or complex phases are not canonical; conformance checks reconstruction and orthogonality, not exact basis bytes.

## 28.4 Table/stats

### table.read — CORE

```text
INPUT_POLICY: STREAM_REQUIRED
IN: ByteStream | Bytes | Text
OPTIONS:
    --format=auto|csv|tsv
    --header::Bool=true
OUT: Table
FX: PURE
ERR: DecodeError, ParseError, ResourceError
```

`auto`:

```text
comma-only first non-empty line -> csv
tab-only                        -> tsv
both/neither                    -> ParseError
```

If header is false, generated ordered names are:

```text
col1 col2 ... colN
```

Duplicate header names are `ParseError`.

CSV dialect:

- delimiter comma;
- double-quoted fields allowed;
- `""` escapes a literal quote inside a quoted field;
- LF and CRLF record endings accepted;
- CR/LF inside a field is allowed only while quoted;
- backslash has no escape meaning;
- spaces outside quotes are data and are not trimmed.

TSV uses the same quoting rules with tab delimiter.

Every data row MUST have exactly the same field count as the header, or as the first data row when `--header=false`. Short or long rows are `ParseError`; rows are never padded or truncated.

Column types are inferred from all rows using deterministic promotion:

```text
Integer -> BigInt -> Float -> Complex -> Text
```

An unquoted empty field is `Null`; quoted empty field `""` is empty Text. Presence of Null does not force Text. Numeric parsing is locale-independent and uses `.` as decimal separator.

### table.select — CORE

```text
INPUT_POLICY: REQUIRED
IN: Table
ARGS: one or more Name/Text column names
OUT: Table preserving requested column order
FX: PURE
ERR: ArgumentError
```

### table.filter — CORE

```text
INPUT_POLICY: REQUIRED
IN: Table
ARGS: exactly one Text predicate
OUT: Table preserving original row order
FX: PURE
ERR: ParseError, TypeError, ArgumentError
```

The predicate MUST be quoted JUL Text:

```bash
|!> @T |!> table.filter "status == 'active' && count > 2"
```

Bare predicate tokens are rejected.

Predicate grammar is §29 symbolic predicate grammar.

Evaluation is row-wise.

Each column name is bound as a read-only symbol to that row's value.

Inside `table.filter`, bare identifier resolution is:

1. exact matching column name;
2. predefined symbolic constant (`pi`, `e`, `Inf`, `NaN`);
3. otherwise `ArgumentError` for unknown row symbol.

Function-call position is separate: `sum(...)`, `abs(...)`, etc. resolve to allowlisted functions even if a column has that spelling. A column named `sum` is referenced as bare `sum`.

Final predicate result:

```text
true  -> keep row
false -> remove row
Null  -> remove row
other -> TypeError
```

No pipeline block or effectful predicate is accepted in v0.0.x.

### table.group — CORE

```text
INPUT_POLICY: REQUIRED
IN: Table
ARGS: one or more column names
OUT: List<Map{"key":List,"rows":Table}>
FX: PURE
```

Groups appear in order of first occurrence of each key tuple.

### table.join — CORE

```text
INPUT_POLICY: REQUIRED
IN: Table
ARGS: second Table MUST be binding reference
OPTIONS:
    --on=<Name or List<Name>>
    --kind=inner|left|right|outer
OUT: Table
FX: PURE
ERR: ArgumentError, TypeError
```

Canonical form:

```bash
|!> @A |!> table.join @B --on=id
```

No literal Table syntax exists in v0.0.x.

Join ordering:

```text
inner/left
    iterate left rows in original order; for each, emit matches in original right-row order

right
    iterate right rows in original order; for each, emit matches in original left-row order

outer
    emit the left-join sequence, then unmatched right rows in original right-row order
```

For left/right/outer joins, cells from a missing side are `Null`. Null fill does not replace the declared non-Null column value type; the column is nullable.

Duplicate non-key names become `<name>_left` and `<name>_right`. If either generated name collides with any existing output column name, return `ArgumentError`; no `_2`/heuristic suffixing is performed.

### table.describe — CORE

```text
INPUT_POLICY: REQUIRED
IN: Table
OUT: Table
FX: PURE
```

Output ordered rows per input column and columns:

```text
column
type
count
missing
unique
mean
std
min
max
```

`table.describe` computes numeric statistics over non-Null cells only and reports `missing` separately.

For a numeric column:

- `count` is the number of non-Null cells;
- `missing` is the number of Null cells;
- `unique` counts distinct non-Null values using `check.equal` semantics;
- `mean`, `min`, and `max` are computed over non-Null values when `count >= 1`, otherwise Null;
- `std` uses the sample standard-deviation rule from `stats.std` when `count >= 2`, otherwise Null.

For a non-numeric column, `mean` and `std` are Null.

`min` and `max` are produced only when the non-Null values are Orderable; otherwise they are Null.

### stats.mean — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector<Number> | Matrix<Number> | Table
OPTIONS: --dim=1|2 (Matrix only), --column=<Name> (Table only)
OUT: Number | Vector
FX: PURE
ERR: ArgumentError, TypeError
```

Vector: arithmetic mean. Matrix without `--dim`: all elements. `--dim=1`: one value per column. `--dim=2`: one per row. Table requires one Number-or-Null column; any Null is `ArgumentError` in v0.0.x.

### stats.median — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector<Real> | Matrix<Real> | Table
OPTIONS: --dim=1|2, --column=<Name>
OUT: Real | Vector<Real>
FX: PURE
ERR: ArgumentError, TypeError
```

`Real = Integer|BigInt|Float`; Complex is rejected. Values sort ascending. Even count returns arithmetic mean of the two central values. Empty input is `ArgumentError`. Table Null policy matches `stats.mean`.

### stats.variance / stats.std — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector<Number> | Matrix<Number> | Table
OPTIONS: --dim=1|2, --column=<Name>
OUT: Float | Vector<Float>
FX: PURE
ERR: ArgumentError, TypeError
```

Sample variance denominator is `n-1`. Complex variance is `sum(abs2(x-mean(x)))/(n-1)` and std is its square root. Fewer than two observations is `ArgumentError`. Table Null policy matches `stats.mean`.

### stats.correlate — CORE

```text
INPUT_POLICY: REQUIRED
IN: Matrix<Real> | Table
OPTIONS: --columns=[Name...] for Table
OUT: Matrix<Float>
FX: PURE
ERR: ArgumentError, TypeError
```

Matrix columns are variables. Table requires selected Real-valued columns with no Nulls. Output is Pearson correlation in supplied column order. If either variable in a pair has zero sample standard deviation, that correlation entry is `NaN`, including a constant column's diagonal.

## 28.5 Graph

### graph.build — CORE

```text
INPUT_POLICY: REQUIRED
IN: Table
OPTIONS:
    --src=<Name> REQUIRED
    --dst=<Name> REQUIRED
    --weight=<Name> optional
    --directed::Bool=false
    --duplicates=error|first|last|sum (default error)
OUT: Graph
FX: PURE
ERR: ArgumentError, TypeError
```

Vertex labels MUST be homogeneous Int64 or homogeneous Text.

If `--weight` is supplied, the named weight column MUST contain only:

```text
Integer
BigInt
Float
```

with no Null values.

A Null or non-numeric weight is `TypeError`.

Self loops are allowed.

Duplicate edge key is `(src,dst)` for directed graphs and the canonical unordered endpoint pair for undirected graphs. Policy is applied in input row order:

```text
error -> second duplicate is ArgumentError
first -> retain first edge and first weight
last  -> retain last edge and last weight
sum   -> requires --weight and numeric weights; retain one edge with row-order numeric sum
```

For an unweighted graph, `sum` is `ArgumentError`.

### graph.neighbors — CORE

```text
INPUT_POLICY: REQUIRED
IN: Graph
ARGS: vertex
OUT: List<Vertex>
FX: PURE
```

Order follows canonical vertex order from JIF.

### graph.path — CORE

```text
INPUT_POLICY: REQUIRED
IN: Graph
ARGS: source destination
OPTIONS: --algorithm=auto|bfs|dijkstra
OUT: List<Vertex>
FX: PURE
ERR: ArgumentError
```

`auto` uses BFS for unweighted graphs and Dijkstra for weighted nonnegative graphs.

Ties choose lexicographically/numerically smallest next vertex by canonical vertex order.

Negative weights are `ArgumentError` for Dijkstra.

No path -> empty List.

### graph.components — CORE

```text
INPUT_POLICY: REQUIRED
IN: Graph
OUT: List<List<Vertex>>
FX: PURE
```

Each component and the outer component list are ordered by canonical minimum vertex.

For directed graphs this operation returns weakly connected components.

### graph.degree — CORE

```text
INPUT_POLICY: REQUIRED
IN: Graph
OPTIONS: --mode=all|in|out
OUT: Table(vertex,degree)
FX: PURE
```

For undirected graphs only `all` is valid.

Rows follow canonical vertex order.

## 28.6 Symbolic / solving

### symbolic.expr — CORE

```text
INPUT_POLICY: NONE
ARGS: Text expression
OUT: SymbolicExpression | Equation
FX: PURE
ERR: ParseError
```

Grammar and AST are §29.

### symbolic.simplify — CORE

```text
INPUT_POLICY: REQUIRED
IN: SymbolicExpression
OUT: SymbolicExpression
FX: PURE
```

v0.0.x mandatory simplification is the deterministic baseline in §29.

Provider-specific stronger simplifiers must use provider/package namespaces and are not allowed to silently change `symbolic.simplify`.

### symbolic.substitute — CORE

```text
INPUT_POLICY: REQUIRED
IN: SymbolicExpression
ARGS: Map<Text,JIF-scalar-or-SymbolicExpression>
OUT: SymbolicExpression
FX: PURE
```

Substitution keys are symbol names.

### solve.equation — CORE

```text
INPUT_POLICY: REQUIRED
IN: Equation
OPTIONS: --for=<Name> REQUIRED
OUT: List<JIF scalar | SymbolicExpression>
FX: PURE
ERR: ArgumentError, MissingCapability
```

Provider is pinned by Core Pack.

Solution ordering for finite scalar solutions is canonical ascending numeric when fully numeric; otherwise canonical symbolic JIF byte order.

### solve.system — CORE

```text
INPUT_POLICY: REQUIRED
IN: EquationSystem | List<Equation>
OPTIONS: --for=[Name...] REQUIRED
OUT: List<Map<Text,JIF scalar | SymbolicExpression>>
FX: PURE
```

Solutions are sorted by canonical JIF bytes of the result maps.

### optimize.min / optimize.max — EXPERIMENTAL

These names are reserved but are NOT mandatory v0.0.x Core Pack conformance operations until a normative `OptimizationProblem` builder/provider contract is standardized.

## 28.7 Checks

### check.type — CORE

```text
INPUT_POLICY: REQUIRED
IN: Any
ARGS: Text/Name JUL type pattern from §13
OUT: Bool
FX: PURE
ERR: ParseError for invalid type pattern
```

Julia type syntax such as `Matrix{Float64}` is rejected.

### check.shape — CORE

```text
INPUT_POLICY: REQUIRED
IN: Vector | Matrix | Tensor | Table
ARGS: List<Integer|Name>
OUT: Bool
FX: PURE
```

For Table shape is `[rows, columns]`.

### check.equal — CORE

```text
INPUT_POLICY: REQUIRED
IN: JIF-comparable high-level value
ARGS: expected JIF-comparable value
OUT: Bool
FX: PURE
ERR: TypeError for environment-affine values
```

Equality:

```text
Null/Bool/Text/Name/integers
    exact

Float
    IEEE == ; NaN != NaN ; +0.0 == -0.0

Complex
    component IEEE equality

Bytes
    byte-for-byte

List/Vector
    length + recursive ordered equality

Map
    same Text key set + recursive values

Matrix/Tensor
    shape + ordered element equality

Table
    same ordered column names/types + recursive column equality

Graph
    same directedness + canonical JIF vertex/edge equality

SymbolicExpression
    byte-for-byte structural equality of the JIF-012 AST with source-order preservation; commutative operations are not reordered by check.equal

Tool
    same artifact_id and revision
```

### check.approximate — CORE

```text
INPUT_POLICY: REQUIRED
IN: Number | numeric array
ARGS: expected same shape/category
OPTIONS: --atol=<Float>=0 --rtol=<Float>=1e-8
OUT: Bool
FX: PURE
```

Rule elementwise:

```text
abs(a-b) <= atol + rtol*abs(expected)
```

Precision rules:

- Integer/BigInt subtraction and absolute value are exact;
- comparison MUST NOT first coerce BigInt operands through Float64;
- when Float tolerance participates with Integer/BigInt operands, use arbitrary precision sufficient to exactly represent both integer operands and the supplied Float64 tolerance values before evaluating the inequality;
- Complex magnitude calculation MUST likewise avoid BigInt-to-Float64 truncation when exact integer components are present.

NaN compares false unless a future explicit option is added.

### check.property — EXPERIMENTAL

Reserved for future property predicates; not required in v0.0.x.

## 28.8 Shell / inspect / render

### shell.require — CORE

```text
INPUT_POLICY: REQUIRED
IN: Bool
OUT: same Bool
FX: PURE
PROCESS_STATUS: true->0 false->1
```

### shell.run — CORE

```text
INPUT_POLICY: OPTIONAL
IN: Null | ByteStream | Bytes | Text
ARGS: Text command
OPTIONS:
    --capture::Bool=true
OUT: ProcessResult
FX: PROCESS
ERR: PermissionError, RuntimeError
```

The command is executed by the pinned Bash-compatible command runner, not recursively as JUL source.

Input bytes/text become child stdin; Null means inherited empty/terminal stdin according to execution context.

`--capture=true` returns:

```text
ProcessResult(status, stdout:Bytes, stderr:Bytes)
```

With `--capture=false`, the child inherits the JUL worker process's current stdin, stdout, and stderr file descriptors exactly.

Therefore, if the JUL segment itself is connected to an ordinary Bash pipe or redirection, child stdio participates in that worker's shell-visible pipeline/redirection context.

The JUL operation returns status metadata only; it does not additionally render captured stdout.

At the JUL segment boundary, the operation itself contributes no extra payload bytes beyond bytes the child wrote through inherited worker stdout.

The active security profile governs child process authority.

### shell.env — CORE

```text
INPUT_POLICY: NONE
ARGS: Name/Text
OUT: Text | Null
FX: PURE
```

Returns only environment visible inside the active JUL runtime/security profile.

### inspect.value — CORE

Defined by §27 OPSPEC-003.

### inspect.error — CORE

```text
INPUT_POLICY: NONE
ARGS: trace_id
OPTIONS: --deep::Bool=false
OUT: Error | Text
FX: PURE
```

### inspect.package — CORE

```text
INPUT_POLICY: NONE
ARGS: package name
OUT: Map
FX: READ_FS
```

Required keys:

```text
name
resolved_version
generation
constraint
provider_path
core_pack_member
```

### render.pretty — CORE

```text
INPUT_POLICY: REQUIRED
IN: high-level JUL value
OUT: Text
FX: PURE
```

### render.text — CORE

```text
INPUT_POLICY: REQUIRED
IN: value with explicit text renderer
OUT: Text
FX: PURE
ERR: BoundaryRenderError
```

### render.json — CORE

```text
INPUT_POLICY: REQUIRED
IN: JSON-representable high-level value
OUT: Text
FX: PURE
ERR: JSONEncodingError, NonInterchangeableValueError
```

Output is RFC 8259 JSON.

Finite or non-finite `Complex` is not JSON-representable in Core `render.json`.

Any `Complex` input returns:

```text
NonInterchangeableValueError
```

A non-finite real `Float` (`NaN`, `+Inf`, `-Inf`) returns:

```text
JSONEncodingError
```

No non-finite numeric value is silently converted to `null` or a string.

BigInt is emitted as a JSON number containing its full exact decimal digits. This is valid RFC-8259 JSON, but IEEE-754-only consumers may lose precision outside `±(2^53-1)`. NeuraBash does not silently stringify BigInt; use JIF for lossless typed interchange.

### render.csv / render.tsv — CORE

```text
INPUT_POLICY: REQUIRED
IN: Table | Matrix
OUT: streaming Text
FX: PURE
ERR: TypeError
```

Canonical delimited rendering uses LF record terminators. CSV delimiter is comma; TSV delimiter is tab. Text fields containing delimiter, quote, CR, or LF are double-quoted; a quote inside a quoted field is doubled. Null is an unquoted empty field; empty Text is `""`. Numeric/Bool fields are canonical scalar text.

Table rendering:

- zero columns -> empty byte string;
- one or more columns -> always emit exactly one header row terminated by LF;
- then emit exactly one LF-terminated data row per Table row;
- therefore a zero-row, nonzero-column Table emits only its header row.

Matrix rendering emits no header row and emits one LF-terminated row per matrix row.

### render.repr — CORE for high-level values

```text
INPUT_POLICY: REQUIRED
IN: JIF-interchangeable/high-level value
OUT: Text
FX: PURE
ERR: TypeError for arbitrary JuliaObject
```

`render.repr` MUST NOT invoke arbitrary user-defined Julia `show` on `JuliaObject` in core mode.

A future explicit unsafe Julia repr operation may do so under RAW_JULIA.

## 28.9 Forge

### tool.find — CORE

Defined by §27 OPSPEC-004.

### tool.define — CORE

Defined by §23.

### tool.show — CORE

```text
INPUT_POLICY: NONE
ARGS: tool name
OPTIONS: --revision=<positive integer>
OUT: Map tool contract/metadata
FX: PURE
```

### tool.test — CORE

Defined by §24.

### tool.test.add — CORE

Adds one structured persistent/temporary test under §24.

Canonical persistent reference forms:

```text
--input=fixture:NAME
--expect=<JUL literal or fixture:NAME>
--cmp=cmp:COMPARATOR@VERSION
```

Example:

```bash
|!> tool.test.add spectral_radius \
    --input=fixture:matrix_A \
    --expect=4.81291 \
    --cmp=cmp:approx@1 \
    --atol=1e-6
```

### tool.fixture.snapshot — CORE

Defined by §24.

### tool.register — CORE

```text
INPUT_POLICY: NONE
ARGS: tool name
OPTIONS:
    --scope=workspace|user
    --allow-untested
OUT: Tool
FX: WRITE_FS
```

### tool.remove — CORE

Defined by §25.

### tool.list — CORE

```text
INPUT_POLICY: NONE
OUT: Table(name,scope,artifact_id,revision,status,implementation_kind,content_hash)
FX: PURE
```

Rows sort by scope precedence, lexical name, then descending revision.

### tool.history — CORE

```text
INPUT_POLICY: NONE
ARGS: tool name optional
OUT: Table(name,artifact_id,revision,event,timestamp_utc,content_hash)
FX: PURE
```

`event ∈ {defined, registered, validated, tombstoned}`.

Event emission is normative:

- every successful `tool.define` that creates a new session definition or new revision emits `defined`;
- every successful `tool.register` emits `registered`, including registration of a later revision;
- every completed persistent validation update emits `validated`;
- every successful persistent tombstone operation emits `tombstoned`.

There is no separate `redefined` event in v0.0.x.

`timestamp_utc` is RFC-3339 UTC with `Z`. Rows sort ascending by event time, then revision, then the event enum order shown above as final tie-breaker.

### tool.run — CORE

Defined by §23 TOOL-006.

## 28.10 Packages

### pkg.search — CORE

```text
INPUT_POLICY: NONE
ARGS: Text/Name query
OPTIONS: --refresh::Bool=false
OUT: Table(name,latest_version,source,cached)
FX:
    default -> READ_FS
    refresh -> READ_FS + NETWORK through broker
```

`source ∈ {cache, registry, filesystem}`.

Source precedence is deterministic:

- a locally developed/path package -> `filesystem`;
- with `--refresh=true`, a registry result obtained from the successful refresh -> `registry`, even if an older cached copy also exists;
- without refresh, a registry result served from local registry metadata -> `cache`.

`cached` independently reports whether ordinary install source/artifacts are locally available and does not change `source`.

Rows sort exact case-sensitive name match first, then ASCII case-insensitive prefix match, then lexical name.

### pkg.use / pkg.remove — CORE

Defined by §§20–22.

### pkg.refresh — CORE

Defined by §20 ENVGEN-012.

Options:

```text
--drop-affine
--wait
```

### pkg.info — CORE

```text
INPUT_POLICY: NONE
ARGS: package name optional
OUT: Map/Table
FX: READ_FS
```

### pkg.list — CORE

```text
INPUT_POLICY: NONE
OUT: Table(name,version,constraint,core_pack_member)
FX: READ_FS
```

## 28.11 Help

### help.concise — CORE

Returns exact field set from §27 OPSPEC-001.

### help.deep — CORE

Returns exact field set from §27 OPSPEC-002.

### help.search — CORE

```text
INPUT_POLICY: NONE
ARGS: Text query
OUT: Table(name,kind,short_help,score)
FX: PURE
```

After Unicode simple case-folding:

```text
1.00 exact name match
0.90 name prefix match
0.80 name substring match
0.50 short_help substring match
```

Use the highest matching score; omit nonmatches. Sort descending score, then lexical name, then lexical kind.

## 28.12 Raw Julia

### julia.eval / julia.block — CORE escape hatches

Defined by §11.

Their semantic effect is `RAW_JULIA`.

# 29. `math.eval` and symbolic expression grammars

## 29.1 Mathematical evaluator

`math.eval` is a dedicated restricted evaluator.

It MUST NOT pass source to arbitrary Julia `eval`.

Normative grammar:

```ebnf
expr        = comparison ;
comparison  = sum , [ comp_op , sum ] ;
sum         = product , { ("+" | "-") , product } ;
product     = unary , { ("*" | "/" | "%") , unary } ;
unary       = ("+" | "-") , unary
            | power ;
power       = primary , [ "^" , unary ] ;
primary     = number
            | constant
            | function_call
            | vector_literal
            | matrix_literal
            | "(" , expr , ")" ;

function_call = function_name , "(" , [ expr , { "," , expr } ] , ")" ;
vector_literal = "[" , [ expr , { "," , expr } ] , "]" ;
matrix_literal = "[" , vector_literal , { "," , vector_literal } , "]" ;

comp_op = "==" | "!=" | "<" | "<=" | ">" | ">=" ;
```

This grammar intentionally makes exponentiation tighter than unary sign and right-associative:

```text
-2^2   == -(2^2) == -4
2^3^2  == 2^(3^2) == 512
2^-2   == 0.25
```

Chained comparisons are invalid:

```text
1 < 2 < 3 -> ParseError
```

## 29.2 Allowed constants and scalar literals

Mathematical constants:

```text
pi
e
Inf
NaN
```

`Inf` and `NaN` produce Float64 non-finite values.

The symbolic/predicate grammar additionally recognizes:

```text
true
false
null
```

These produce JIF `Bool(true)`, `Bool(false)`, and `Null` literals.

They are not parsed as symbols named `true`, `false`, or `null`.

This addition applies to §29.8 symbolic/predicate parsing; it does not add arbitrary identifiers to `math.eval`.

## 29.3 Allowed functions

```text
abs
sqrt
cbrt
exp
log
log2
log10
sin
cos
tan
asin
acos
atan
sinh
cosh
tanh
floor
ceil
round
min
max
sum
prod
```

Function arity is fixed by the evaluator's operation table; invalid arity is `ArgumentError`.

## 29.4 Numeric semantics

Integer-only `+`, `-`, `*`, and nonnegative integer exponentiation use exact integer arithmetic:

- result fitting Int64 -> `Integer`;
- overflow beyond Int64 -> promote to `BigInt`;
- no wraparound.

`/` performs floating/complex division.

Examples:

```text
1 / 2   -> 0.5
1 / 0   -> Inf
0 / 0   -> NaN
```

`%` by zero is `MathDomainError`.

For nonzero divisor, `%` follows the Julia/Python modulo convention: result has the sign of the right operand.

```text
-5 % 3 == 1
5 % -3 == -1
```

Negative exponent promotes to Float/Complex as required.

`sqrt(negative real)` and `log(negative real)` return principal `Complex` results rather than `MathDomainError`.

Other provider domain failures not covered here return `MathDomainError`.

## 29.5 Literal promotion

Vector/matrix numeric literals promote elements through:

```text
Integer -> BigInt -> Float -> Complex
```

Ragged matrix literals are `ArgumentError`.

Empty vector `[]` is legal but has unknown numeric element type until an accepting operation supplies context.

Matrix rows MUST be non-empty and equal length; `[[]]` is `ArgumentError`.

## 29.6 Forbidden constructs

Not legal in `math.eval`:

```text
assignment
arbitrary identifiers
field/module access
macros
command literals
file IO
process launch
network
Pkg
eval
include
ccall
```

## 29.7 Resource budget

Evaluator MUST enforce:

```text
maximum AST nodes
maximum nesting
maximum literal collection size
maximum BigInt bits
operation/time budget
```

Budget excess is `ResourceError`.

---

## 29.8 Symbolic expression and predicate grammar

`symbolic.expr` extends the mathematical grammar with identifiers, Text literals, and boolean conjunction/disjunction. `math.eval` does NOT gain Text literals.

```ebnf
symbolic_expr = or_expr ;
or_expr       = and_expr , { "||" , and_expr } ;
and_expr      = comparison , { "&&" , comparison } ;
comparison    = symbolic_sum , [ comp_op , symbolic_sum ] ;
symbolic_sum      = symbolic_product , { ("+" | "-") , symbolic_product } ;
symbolic_product  = symbolic_unary , { ("*" | "/" | "%") , symbolic_unary } ;
symbolic_unary    = ("+" | "-") , symbolic_unary | symbolic_power ;
symbolic_power    = symbolic_primary , [ "^" , symbolic_unary ] ;
symbolic_primary  = number | constant | boolean_literal | null_literal | string_literal | symbol | function_call | "(" , symbolic_expr , ")" ;
symbol = ident ;
boolean_literal = "true" | "false" ;
null_literal = "null" ;
string_literal = single_quoted_string | double_quoted_string ;
```

String escapes use §9 JUL string semantics. A Text literal becomes `Literal(value=<JIF Text>)` in the JIF-012 provider-independent AST.

Outside `table.filter`: predefined constants are constants in bare constant position; allowlisted names followed by `(` are function calls; every other identifier is `Symbol(name)`.

Inside `table.filter`, §28.4 row-column precedence applies. Function-call position remains an allowlisted function even when a column has the same spelling.

`math.eval "x == 'y'"` remains `ParseError`.

Equality `x == y` used as a top-level symbolic object becomes `Equation` when passed to `solve.equation`; inside `table.filter` it is a Bool-producing predicate.

## 29.9 Canonical AST mapping

Parsing produces the provider-independent JIF AST operator IDs in §14 JIF-012.

Column/symbol names become `Symbol(name)` nodes.

## 29.10 Deterministic baseline simplifier

Core `symbolic.simplify` repeatedly applies only these rules until fixed point:

```text
x + 0 -> x
0 + x -> x
x - 0 -> x
x * 1 -> x
1 * x -> x
x * 0 -> 0
0 * x -> 0
x / 1 -> x
x ^ 1 -> x
x ^ 0 -> 1
-(-x) -> x
constant-only subtree -> math.eval-folded constant
```

No factoring, expansion, symbolic cancellation, commutative reordering, trigonometric identity rewriting, or heuristic provider simplification is part of core `symbolic.simplify`.

Provider-specific stronger simplification uses non-core package/provider namespaces.

## 29.11 `table.filter` predicate context

For each row, every column name maps to a read-only Symbol value bound to that row cell.

`&&` and `||` short-circuit.

Final result MUST be Bool.

A Null comparison yields false except:

```text
null == null -> true
null != null -> false
```

Other ordering comparisons with Null are `TypeError`.

# 30. Semantic vs runtime effects

## EFFECT-001 — Semantic effects

```text
PURE
READ_FS
WRITE_FS
PROCESS
NETWORK
PACKAGE_INSTALL
NATIVE_CODE
GPU
RAW_JULIA
```

## EFFECT-002 — Runtime effects

Implementation may internally use:

```text
COMPILE_CACHE
TEMP_STORAGE
ARTIFACT_CACHE
LOGGING
IPC
```

## EFFECT-003 — PURE meaning

`PURE` means no mutation of NeuraBash's semantic environment other than returning a value/error.

The semantic environment includes user/workspace files outside designated private runtime cache/temp roots, session bindings, persistent tools/fixtures/artifacts, workspace generation state, process/network/device-visible state, and environment variables visible to later commands.

JIT, IPC, logging, compilation caches, and private temp files under the designated runtime paths reported by `--neura-paths` are permitted runtime effects and are explicitly outside semantic-effect classification. Such files are never authoritative program state.

## EFFECT-004

Forged tool effects are the union of component semantic effects unless a narrower effect set is proven by the implementation.

## EFFECT-005

This lock/effect analysis applies to NeuraBash-managed operations.

Arbitrary raw Julia can ignore NeuraBash internal conventions and is governed by the security profile, not by semantic declarations alone.

---

# 31. Structured error wire and text formats

Errors are typed values internally.

## ERRFMT-001 — Canonical machine JSON

The canonical machine representation is one RFC-8259 JSON object.

Minimum schema:

```json
{
  "schema": "neurabash.error.v1",
  "class": "TypeError",
  "operation": "matrix.svd",
  "message": "expected numeric matrix",
  "expected": "Matrix<Number>",
  "received": "Text",
  "recoverable": true,
  "remediation": ["matrix.read"],
  "trace_id": "..."
}
```

Additional normative optional fields include:

```text
partial_output_possible
details
```

`details` MUST itself be JSON-representable and MUST NOT contain raw provider exception objects.

## ERRFMT-002 — Output selection

```text
--neura-error-format=json
--neura-error-format=text
```

Defaults:

```text
stderr TTY       -> text
stderr non-TTY   -> json
```

Harnesses SHOULD request JSON explicitly.

## ERRFMT-003 — Deterministic text form

Text mode uses this exact field order:

```text
<Class>: <message>
  operation: <value or ->
  expected: <value or ->
  received: <value or ->
  recoverable: true|false
  remediation: <compact JSON array of escaped strings or []>
  trace_id: <id>
```

If `partial_output_possible=true`, append:

```text
  partial_output_possible: true
```

Text mode is human-oriented but deterministic.

Before insertion into a text-mode field:

```text
\  -> \\
LF  -> \n
CR  -> \r
TAB -> \t
other control characters -> \u00XX
```

Printable non-ASCII is emitted as UTF-8 without Unicode normalization. No field may inject a raw newline into the line-oriented record.

## ERRFMT-004 — Deep trace

```text
inspect.error TRACE_ID --deep
```

retrieves provider exception/stack detail if still retained.

Default failure output MUST NOT dump uncontrolled Julia stacks.

## ERRFMT-005 — Nested/isolated errors

Errors crossing JIF use JIF ErrorRecord.

The outer caller preserves the original:

```text
class
message
operation
trace_id
```

and may add one transport trace id in `details`.

It MUST NOT collapse every isolated-worker failure into generic `RuntimeError`.

# 32. Error classes and exit codes

Unhandled raised errors map exactly:

| Exit | Classes |
|---:|---|
| 64 | `ParseError`, `ArgumentError`, `CompatibilityError` |
| 65 | `TypeError`, `DecodeError`, `MathDomainError`, `BoundaryRenderError`, `JSONEncodingError`, `InterchangeError`, `NonInterchangeableValueError` |
| 66 | `MissingCapability`, `UnknownBindingError`, `ToolError`, `ToolInvalidatedError`, `ArtifactIntegrityError`, `SourceCaptureError` |
| 67 | `PackageError`, `DependencyConflictError`, `CorePackConflictError`, `GenerationPinnedError`, `GenerationMigrationError` |
| 68 | `PermissionError`, `SandboxUnavailableError` |
| 69 | `TimeoutError`, `ResourceError`, `CancelledError`, `SessionBusyError` |
| 70 | `JuliaError`, `RuntimeError`, `RuntimeRestartError` |
| 71 | `DaemonError`, `DaemonVersionError`, `StaleHandleError` |

Status `1` is reserved for ordinary false predicate status through `shell.require`.

A typed Error returned as data exits `0` unless explicitly raised.

Ordinary fatal signal statuses, including SIGPIPE 141 on Linux, follow inherited shell conventions and are not remapped into this table.

# 33. Security profiles and enforcement semantics

Security is host-enforced.

NeuraBash does not claim arbitrary Julia can be sandboxed by parsing.

Reference profiles:

| Profile | Workspace | Host FS | Network | Runtime env | Managed package mutation | GPU |
|---|---|---|---|---|---|---|
| `inherit` | host perms | host perms | host perms | inherited | broker/user policy | inherited |
| `readonly` | RO | explicit controlled RO mounts | allowed unless denied | scrubbed | broker only | denied unless granted |
| `workspace` | RW | explicit controlled RO mounts | allowed unless denied | scrubbed | broker only | denied unless granted |
| `sandbox` | configurable workspace | explicit mounts only | denied by default | scrubbed | broker denied by default | denied unless granted |

## SEC-001 — Enforcement backend

Reference Linux implementation uses a compatible combination of:

- user/mount/PID namespaces;
- controlled bind mounts;
- private temp/home;
- seccomp where compatible;
- Landlock where available;
- bubblewrap/container-equivalent isolation.

## SEC-002 — No silent downgrade

If requested semantics cannot be enforced:

```text
SandboxUnavailableError
```

Launch MUST fail.

No automatic fallback to `inherit`.

## SEC-003 — Private HOME

For `readonly`, `workspace`, and `sandbox`:

```text
HOME
XDG_CONFIG_HOME
XDG_CACHE_HOME
```

point to private NeuraBash-controlled paths, never the caller's real home/config directories.

The real home is not mounted unless explicitly granted as a capability/path.

## SEC-004 — Julia startup/config isolation

Contained Julia runtimes start with equivalent of:

```text
--startup-file=no
--history-file=no
```

They do not read `~/.julia/config/startup.jl` from the host user.

The host user's Julia startup/config tree MUST also be unreachable through mounted filesystem paths, HOME/XDG variables, depot/load paths, or inherited file descriptors unless explicitly granted. `--startup-file=no` is defense in depth, not the sole boundary.

## SEC-005 — Controlled depot stack

Contained profiles use a depot stack conceptually:

```text
private_writable_runtime_depot
:
read_only_core_pack_depot
:
read_only_workspace_generation_resources
```

The caller's ordinary user depot is not mounted by default.

Private writable depot space is for runtime caches/temp state and does not grant write access to immutable managed Project/Manifest generations.

## SEC-006 — Controlled project/load path

The runtime's `JULIA_PROJECT`/load path point only at the selected immutable environment generation and approved Core/runtime shim locations.

Managed generation Project/Manifest files are mounted/read as immutable.

Raw Julia MAY create ephemeral private environments inside permitted scratch space if policy/network allow it, but such environments:

- do not mutate NeuraBash managed generations;
- are not persistent workspace package state;
- cannot satisfy persistent tool dependencies unless imported through the broker.

## SEC-007 — Environment scrub

Contained profiles begin from a minimal allowlist such as:

```text
PATH
HOME
TMPDIR
LANG
LC_*
XDG_CONFIG_HOME
XDG_CACHE_HOME
JULIA_DEPOT_PATH
JULIA_PROJECT
JULIA_LOAD_PATH
```

Host secrets/agent sockets/tokens are absent unless explicitly granted.

Examples excluded by default:

```text
AWS_*
GITHUB_TOKEN
SSH_AUTH_SOCK
credential helper variables
cloud provider tokens
```

## SEC-008 — Git/config isolation

Contained profiles set private config homes and MUST prevent accidental use of host global Git credential/config state.

Contained `readonly`, `workspace`, and `sandbox` profiles MUST behave as if `GIT_CONFIG_NOSYSTEM=1` and MUST use a private global Git config path unless host system/global Git configuration is explicitly granted. Host credential-helper config/files are not mounted by default.

## SEC-009 — `/proc`

Contained profiles use an isolated PID namespace with a corresponding `/proc` view when supported.

`/proc/self` required by the runtime remains visible.

Host process listings/environments/file-descriptor trees outside the namespace MUST NOT be exposed merely because `/proc` is mounted.

If this cannot be enforced on the host kernel for the requested profile, launch fails rather than silently weakening.

## SEC-010 — Inherited file descriptors

Contained runtime startup closes all inherited file descriptors except:

```text
stdin
stdout
stderr
explicitly provisioned capability/broker descriptors
```

No SSH agent, arbitrary Unix socket, or caller-open secret file descriptor is inherited accidentally.

## SEC-011 — Broker channel

A contained runtime does not receive a filesystem path to an unrestricted privileged daemon socket.

The reference design passes a capability-bound pre-opened broker channel associated server-side with:

```text
session_id
workspace_id
security_profile_id
allowed broker operations
```

The sandbox cannot request operations outside that server-side capability set merely by forging a message.

## SEC-012 — Package broker

Package resolution/acquisition/build/precompile for managed environments happens outside the hardened runtime under explicit broker policy.

The runtime consumes immutable results.

## SEC-013 — Symlink/mount escape

Workspace write permission is a mount-namespace capability, not a string-prefix check.

A symlink resolving outside mounted writable resources MUST NOT grant write access outside them.

## SEC-014 — Process creation

Contained profiles do not promise universal `execve` prohibition.

Child processes inherit the same mount/network/environment boundary unless an operation explicitly launches into a stricter child profile.

## SEC-015 — Native libraries / FFI

Raw Julia/FFI can load only libraries reachable through the contained mount namespace and sanitized dynamic-loader configuration.

Contained profiles scrub caller-provided `LD_PRELOAD`, `LD_AUDIT`, and `LD_LIBRARY_PATH`. NeuraBash MAY inject only approved runtime/Core Pack loader paths. Host library paths not mounted into the namespace remain unreachable even if host linker configuration mentions them. Absolute `dlopen`/`ccall` paths outside mounted resources fail by filesystem isolation.

This is an authority boundary, not a claim that `ccall` is syntactically forbidden.

## SEC-016 — GPU capability

GPU is granted explicitly:

```text
--neura-cap=gpu
```

The grant provisions only the device nodes/runtime libraries configured by the host policy.

Failure to provision them returns `PermissionError`/`SandboxUnavailableError`.

Users are not instructed to fall back to `inherit` merely to obtain GPU access.

## SEC-017 — Network

`sandbox` has no network namespace connectivity by default.

`readonly`/`workspace` may allow network according to selected policy, but scrubbed secrets remain scrubbed.

DNS availability follows network capability.

## SEC-018 — Managed-package integrity

Even if raw Julia creates an ephemeral scratch environment, it MUST NOT have write access to NeuraBash managed Core Pack or committed workspace generation metadata under contained profiles.

Reference topology mounts Core Pack and committed generations read-only, on mount points distinct from private writable runtime depot/cache/scratch. Writable scratch/cache directories MUST NOT be parent directories of those managed mounts; symlink traversal cannot convert scratch write permission into write authority over an unmounted or read-only managed path.

# 34. Package broker security boundary

`pkg.use`, `pkg.remove`, registry refresh, package build, and managed precompile are broker requests.

The broker:

1. authenticates the capability-bound session channel;
2. checks profile/organization/user policy;
3. resolves from the workspace current generation;
4. enforces Core Pack immutability;
5. stages downloads/builds/precompile outside the hardened runtime;
6. creates a new immutable generation;
7. atomically commits the workspace current pointer;
8. returns a typed plan/result;
9. never hands the sandbox unrestricted broker authority.

A raw-Julia process cannot convert ordinary `Pkg.add` into a managed `pkg.use` generation mutation.

Only the broker can publish a NeuraBash workspace generation.

# 35. Concurrency and locks

## CON-001

Pure JUL computations MAY run concurrently.

## CON-002

Session binding mutations serialize per logical session.

## CON-003

Persistent artifact registry mutation requires a cross-process artifact lock.

## CON-004

Environment generation mutation requires a cross-process package/environment lock.

## CON-005

Readers observe either the complete previous artifact/generation or complete new one.

## CON-006 — Internal lock order

For locks managed by NeuraBash itself, canonical order is:

```text
environment-generation lock
-> artifact-store lock
-> session-mutation lock
```

NeuraBash internal code MUST NOT acquire them in reverse order.

This guarantee does not constrain arbitrary user raw Julia that independently opens files or third-party locks.

---

# 36. Bash trace, function export, and introspection

Bash-only code retains inherited behavior.

## TRACE-001 — xtrace

For a JUL segment, `set -x` displays the canonical JUL serialization defined by TRACE-002.

For a fixed parsed JUL AST, that serialization is byte-stable within a NeuraBash release.

Cross-release formatting changes are compatibility events and MUST be documented if they change canonical trace bytes.

It MUST NOT display internal socket frames or hidden worker command lines as though typed by the user.

## TRACE-002 — `$BASH_COMMAND`

When a DEBUG trap is invoked for execution of a `JUL_SEGMENT`, `$BASH_COMMAND` is the canonical JUL source serialization of that segment beginning with `|!>`.

Canonical JUL serialization uses one ASCII space around `|!>`, one ASCII space between operation name and successive arguments/options, preserves AST stage/argument/option order, emits Text as double-quoted JUL strings, preserves list order, sorts Map keys by UTF-8 byte order, emits canonical §9 reference lexemes, and omits comments/non-semantic source whitespace.

Example:

```bash
cat A.csv |!> matrix.read |!> matrix.svd
```

The JUL element's canonical `BASH_COMMAND` is:

```text
|!> matrix.read |!> matrix.svd
```

Outside a JUL element, inherited Bash `$BASH_COMMAND` behavior remains unchanged.

## TRACE-003 — `declare -f`

A function containing JUL syntax printed by:

```bash
declare -f NAME
```

MUST be reparsable by NeuraBash and preserve JUL structure.

## TRACE-004 — `export -f` compatibility guard

A function containing any JUL AST node MUST NOT be exported with Bash function-export encoding.

```bash
export -f jul_function
```

fails with status 64 and `CompatibilityError`.

Reason: an exported environment function may be imported by ordinary upstream Bash, which cannot parse JUL syntax.

Pure Bash functions retain inherited `export -f` behavior.

This intentional mixed-language deviation MUST appear in `COMPATIBILITY_DEVIATIONS.md` under stable id `DEV-EXPORT-F-JUL`.

## TRACE-005 — History

History stores user-entered NeuraBash source, not worker/IPC internals.

# 37. Interactive behavior

Because NeuraBash is a Bash-derived shell:

## TTY-001

Bash readline remains the interactive editor.

## TTY-002

NeuraBash MUST NOT insert a generic pre-parser line proxy in front of readline.

## TTY-003

Continuation prompts follow combined parser completeness.

Open JUL blocks, heredocs, and trailing `|!>` continue input.

## TTY-004

Terminal resize, foreground process groups, suspend/resume, Ctrl-C, Ctrl-Z, and job control remain owned by the Bash core.

---

# 38. CLI and harness contract

Required command forms:

```text
neurabash
neurabash -c SOURCE
neurabash -lc SOURCE
neurabash SCRIPT
```

Existing inherited Bash options retain upstream meaning unless explicitly documented.

NeuraBash options use:

```text
--neura-*
```

Required options:

```text
--neura-session=ephemeral|workspace
--neura-profile=inherit|readonly|workspace|sandbox
--neura-cap=gpu                 # repeatable capability family reserved
--neura-error-format=text|json
--neura-memory-limit=<size>
--neura-spill-limit=<size>
--neura-paths
--neura-runtime-info
```

`--neura-no-daemon` does NOT exist in v0.0.x. There is one normative runtime topology; alternate lifecycle modes are not exposed until specified.

## CLI-001 — Shebang

```bash
#!/usr/bin/env neurabash
```

is supported.

## CLI-002 — `--neura-paths`

Always writes one newline-terminated JSON object to stdout:

```json
{
  "cache_dir": "...",
  "core_pack_dir": "...",
  "runtime_dir": "...",
  "spill_dir": "...",
  "user_artifacts_dir": "...",
  "workspace_artifacts_dir": "..."
}
```

Keys shown above are mandatory. Workspace path may be `null` outside a workspace.

Every non-null path is absolute and lexically normalized using this exact algorithm:

1. begin from an absolute path;
2. collapse repeated `/` separators to one;
3. remove `.` path components;
4. resolve `..` lexically by removing the immediately preceding normal component without dereferencing symlinks;
5. attempts to move above `/` remain at `/`;
6. emit no trailing `/` except for root `/`;
7. do not resolve symlinks or require the path to exist.

`--neura-paths` never triggers bootstrap, directory creation, package work, or Julia startup. It reports intended paths even if they do not exist.

No commentary is mixed into stdout.

## CLI-003 — `--neura-runtime-info`

Always writes one newline-terminated JSON object:

```json
{
  "artifact_schema_version": "...",
  "bootstrap_state": "UNINITIALIZED",
  "core_pack_version": "...",
  "default_profile": "...",
  "jif_version": "...",
  "julia_version": null,
  "neurabash_version": "...",
  "protocol_version": "...",
  "upstream_bash_version": "..."
}
```

## HARNESS-001 — Bash substitution

A harness invoking:

```text
bash -lc COMMAND
```

SHOULD be able to invoke:

```text
neurabash -lc COMMAND
```

for Bash-only work without changing task logic.

## HARNESS-002 — Cross-invocation state

Repeated harness calls use separate client sessions.

Workspace tools/packages persist under:

```text
--neura-session=workspace
```

Session bindings do not silently become shared global workspace state.

## HARNESS-003 — Adapter neutrality

MCP/RPC integrations are adapters, not NeuraBash syntax or semantics.

## CLI-004 — Runtime-info before bootstrap

`--neura-runtime-info` is observational and MUST NOT trigger bootstrap.

`bootstrap_state` is exactly one of:

```text
UNINITIALIZED
BOOTSTRAPPING
READY
FAILED
JULIA_MISSING
```

If another authorized process currently owns the bootstrap transaction lock, `bootstrap_state=BOOTSTRAPPING`.

If Julia is discoverable, `julia_version` reports it even before Core Pack bootstrap. If Julia is absent, `julia_version=null` and state is `JULIA_MISSING`.

Successful reporting exits 0 for every valid bootstrap state, including `UNINITIALIZED`, `BOOTSTRAPPING`, and `JULIA_MISSING`. Unreadable/corrupt NeuraBash installation metadata produces the normal structured nonzero error.

# 39. Bootstrap / Core Pack

## BOOT-001

First use MUST initialize NeuraBash-owned Julia state without requiring manual project editing.

## BOOT-002

Bootstrap state uses the same closed enumeration as CLI-004:

```text
UNINITIALIZED
BOOTSTRAPPING
READY
FAILED
JULIA_MISSING
```

Semantics:

```text
UNINITIALIZED
    managed Core Pack/runtime state has not yet been initialized

BOOTSTRAPPING
    an authorized bootstrap transaction is currently in progress

READY
    required managed runtime/Core Pack state is usable

FAILED
    a previous or current bootstrap attempt failed and diagnostic state exists

JULIA_MISSING
    required Julia executable/runtime cannot be discovered
```

The state MUST be machine-distinguishable and observable without initiating bootstrap.

## BOOT-003

Missing Julia produces direct remediation.

## BOOT-004

Core Pack manifest/version is tied to the NeuraBash release.

Changing it is a compatibility event.

---

# 40. Deep Warp Curriculum

The curriculum is separate from the language implementation.

It trains **allocation strategy**, not merely Julia syntax.

## DW-001 — Exactness delegation

Use executable deterministic computation instead of neural approximation when appropriate.

## DW-002 — Representation selection

Move structured relationships into explicit structures:

```text
graph
matrix
table
set
symbolic expression
constraint/equation system
```

## DW-003 — Repetition detection

Repeated deterministic reasoning is a tool candidate.

## DW-004 — Retrieve before reinvent

Search:

```text
tool
stdlib
package
```

before rebuilding.

## DW-005 — Escalation ladder

Prefer:

```text
existing Level-1 operation
-> composition
-> existing package
-> raw Julia
-> lower-level custom implementation
```

unless the task justifies skipping levels.

## DW-006 — Validate

Reusable tooling should be tested before consequential repeated use.

## DW-007 — Reuse

Validated machinery replaces repeated re-derivation.

## DW-008 — Avoid framework disease

Do not scaffold trivial one-off work.

---

# 41. Research ablations

## A0

```text
Model + pinned upstream Bash
```

## A1

```text
Same model + NeuraBash
Bash-only tasks
No JUL instruction
```

Measures surface parity.

## A2

```text
Same model + NeuraBash
One-page JUL syntax/capability cheat sheet
No self-scaffolding curriculum
```

Measures symbolic capability given minimum syntax knowledge.

## A3

```text
Same model + NeuraBash
Same cheat sheet
Deep Warp curriculum
```

Measures exploitation strategy.

Later optional conditions:

```text
A4 shared persistent tool store
A5 external memory
A6 adaptive/fluid substrate
```

The core language result MUST NOT depend on A5/A6.

---

# 42. Hypotheses

## H0 — Bash parity

Ordinary shell performance under NeuraBash is statistically indistinguishable from pinned Bash within a predefined benchmark tolerance.

## H1 — Symbolic uplift

Given minimal JUL syntax knowledge, NeuraBash improves tasks with deterministic, mathematical, structural, or reusable subproblems.

## H2 — Curriculum uplift

Deep Warp training improves recognition and exploitation of symbolic externalization opportunities.

## H3 — Tool accumulation

Persistent model-created tools reduce future token cost, latency, repeated reasoning, or error rate on related tasks.

---

# 43. Cognitive amortization

For pattern `P` and tool `T`:

```text
C_build(T) = construct + validate cost
C_use(T)   = retrieve + invoke cost
C_raw(P)   = repeated direct-solution cost
```

Useful amortization:

```text
C_build(T) + n*C_use(T) < n*C_raw(P)
```

for realistic `n`.

Metrics:

- tokens;
- latency;
- tool calls;
- correctness;
- recovery rate;
- reuse count.

---

# 44. Conformance suites and implementation gates

Required suite layout:

```text
tests/upstream-bash/
tests/bash-diff/
tests/token-collision/
tests/parser/
tests/precedence/
tests/jul-grammar/
tests/mixed-pipeline/
tests/streams/
tests/jif/
tests/render/
tests/types/
tests/math/
tests/symbolic/
tests/stdlib-contracts/
tests/julia/
tests/world-age/
tests/packages/
tests/env-generations/
tests/tools/
tests/tool-fixtures/
tests/artifacts/
tests/errors/
tests/status/
tests/signals/
tests/jobs/
tests/concurrency/
tests/security/
tests/trace/
tests/tty/
tests/harness/
tests/e2e/
```

Every normative MUST maps to:

- executable conformance test; or
- explicit `MANUAL-CONFORMANCE` record with justification.

## GATE-P0 — Before implementation agent is allowed to expand the architecture

These fixtures MUST exist first, even if initially failing against NeuraBash:

```text
token-collision corpus against pinned Bash
mixed-operator expected AST corpus
map-vs-@block grammar fixtures
JIF canonical-byte fixtures
math precedence/numeric fixtures
```

## GATE-P1 — Before first claimed end-to-end alpha

Must pass:

```text
mixed pipeline status/job tests
JUL heredoc tests
two-client environment-generation tests
tool parameter/invocation tests
tool source persistence + fixture tests
private HOME/depot sandbox tests
world-age semantic tests
SIGPIPE tests
```

## GATE-P2 — Before "conforming v0.0.x"

Must pass:

```text
full selected upstream Bash differential corpus
one contract suite per CORE Level-1 operation
package conflict/locking/crash suite
JIF cross-process canonical round-trip suite
CLI JSON schema suite
canonical E2E demo literally
security profile capability suite
```

# 45. Differential Bash policy

## DIFF-001

Comparator is the exact pinned upstream Bash build used as the NeuraBash base.

## DIFF-002

Intentional nondeterminism is normalized field-by-field only.

Examples:

- PID;
- timestamp;
- temporary path;
- scheduling where upstream gives no ordering guarantee.

## DIFF-003

Broad regex deletion is prohibited as a way to hide differences.

## DIFF-004

The initial corpus combines:

1. runnable upstream Bash tests;
2. regression tests around every NeuraBash Bash patch;
3. the token-collision corpus;
4. adversarial grammar combinations;
5. real harness command corpora.

## DIFF-005

Any deterministic difference absent from the compatibility-deviation registry fails conformance.

---

# 46. Compatibility-deviation registry

Repository file:

```text
COMPATIBILITY_DEVIATIONS.md
```

Each intentional deviation requires:

```text
id
upstream behavior
NeuraBash behavior
reason
risk
test
migration/remediation
```

The default expectation is an empty registry for Bash-only semantics.

---

## DEV-EXPORT-F-JUL — Mandatory v0.0.x entry

```text
id: DEV-EXPORT-F-JUL
upstream behavior: Bash functions may be exported with export -f
NeuraBash behavior: functions containing JUL AST nodes are rejected by export -f
reason: ordinary upstream Bash consumers cannot parse JUL syntax
test: tests/trace/export_f_jul_rejected.julbash
```

Pure Bash function export is not a deviation.

# 47. Canonical end-to-end demonstration

A conforming implementation MUST support behavior equivalent to:

```bash
$ git status
# ordinary inherited Bash output

$ cat A.csv |!> matrix.read |!> matrix.svd
# typed SVD result, pretty-rendered because stdout is a TTY

$ cat A.csv |!> matrix.read |!> core.bind A

$ |!> @A |!> matrix.rank
5

$ |!> tool.define spectral_radius @{
>     matrix.eig --values-only
>     |!> vector.abs
>     |!> vector.max
> }
defined spectral_radius revision=1 status=UNTESTED

$ |!> tool.fixture.snapshot @A --name=matrix_A
fixture matrix_A created

$ |!> tool.test.add spectral_radius \
      --input=fixture:matrix_A \
      --expect=4.81291 \
      --cmp=cmp:approx@1 \
      --atol=1e-6

$ |!> tool.test spectral_radius
PASSING

$ |!> tool.register spectral_radius --scope=workspace
registered spectral_radius revision=1

$ cat B.csv |!> matrix.read |!> spectral_radius
4.81291

$ |!> tool.find spectral_radius
# one structured tool-summary row

$ |!> pkg.use Example --plan
# PackageChangePlan, no mutation

$ |!> pkg.use Example
# if migration is lossless:
# new immutable generation committed; current session restarts and restores JIF bindings
```

The package conformance suite MUST use a local fixture registry/package so the test does not depend on public-network availability.

A fresh later workspace session MUST retrieve and execute `spectral_radius` without reconstructing its source manually.

# 48. Required multi-client environment-generation demonstration

A conformance scenario MUST demonstrate this exact sequence:

```text
1. Workspace current = G1.
2. Session A pins G1.
3. Session B pins G1.
4. A creates JIF binding @A1.
5. B starts a long but finite pure request on G1.
6. A runs a package plan; B is unaffected.
7. A commits G2 from G1.
8. B's request completes normally on G1.
9. Workspace current = G2.
10. A migrates/restarts on G2.
11. B remains pinned G1.
12. B attempts pkg.use and receives GenerationPinnedError.
13. B runs pkg.refresh.
14. If B has only JIF state, B migrates to G2 and restores it.
15. If B has an affine value, ordinary refresh returns GenerationMigrationError.
16. B explicitly uses --drop-affine; migration succeeds and reports loss.
17. New Session C starts directly on G2.
```

The test MUST also exercise crash points immediately before and after atomic current-pointer replacement.

# 49. Required isolated-tool and JIF demonstration

Conformance MUST create two intentionally incompatible Julia package environments.

It MUST prove:

1. an Int64/Float64 Matrix JIF value crosses into an isolated worker;
2. NaN, Inf, and signed zero survive JIF numeric payload round-trip bit semantics where applicable;
3. canonical header/payload bytes match committed fixtures;
4. JIF output returns and reconstructs correctly;
5. a package-native environment-affine object is rejected before text fallback;
6. a nested Table containing an opaque JuliaObject is rejected as non-interchangeable;
7. an isolated tool returning Function/JuliaObject is rejected at the return boundary;
8. ErrorRecord crosses JIF without raw provider exception serialization;
9. malformed shape/length/hash input is rejected before dangerous allocation.

# 50. Non-negotiable failure conditions

Implementation is nonconforming if any of the following occur:

1. Bash-only work requires JUL knowledge.
2. Bash-only source gains unexplained changed semantics.
3. JUL is implemented by a generic external Bash source rewriter as authoritative parser.
4. A second hand-written Bash lexer determines Bash lexical state.
5. `|!>` collides with accepted syntax in the pinned upstream collision corpus.
6. Mixed-pipeline precedence/status is implementation-defined.
7. Multiple Bash↔JUL transitions are ambiguous.
8. `{}` can mean either Map or PipelineBlock.
9. Typed values are stringified between JUL stages by default.
10. JIF does not have canonical committed-byte fixtures.
11. Environment-affine values silently cross incompatible runtimes.
12. Workspace environment generations branch in v0.0.x.
13. A stale-pinned client can mutate packages without refresh.
14. Package mutation edits a committed generation in place.
15. Package activation silently drops affine session state.
16. Core Pack providers can be replaced by ordinary `pkg.use`.
17. Standard primitives silently install packages.
18. Normal JUL use requires manual Julia environment management.
19. Level-1 forms an artificial ceiling preventing explicit raw Julia.
20. Persistent raw-Julia tools can register without captured reconstructible source.
21. Persistent tests depend on ephemeral live bindings.
22. Validation PASSING is not qualified by environment/profile/test context.
23. Tool parameter binding semantics are implementation-defined.
24. Artifact ID/revision/content-hash identity is ambiguous.
25. Default errors dump uncontrolled Julia traces.
26. Error machine format or exit class mapping is unspecified.
27. Bool silently becomes shell truth without explicit status operation.
28. SIGPIPE behavior differs arbitrarily across implementations.
29. Streams materialize without resource policy.
30. Requested security profiles silently downgrade.
31. Contained profiles use the caller's real HOME/depot/startup file by default.
32. Contained runtime inherits arbitrary secret file descriptors/environment.
33. A sandbox has unrestricted access to a privileged daemon/broker socket.
34. Raw Julia can write committed managed Core Pack/generation metadata in contained profiles.
35. Runtime crashes destroy persistent tool source.
36. Artifact integrity failures are ignored.
37. `export -f` silently exports JUL-containing function bodies to ordinary Bash consumers.
38. A CORE Level-1 operation lacks a normative OperationSpec/test.
39. Any persistent artifact depends solely on opaque Julia runtime serialization.

Additional v0.0.6 nonconformance conditions:

40. the canonical E2E demo uses token forms absent from JUL grammar;
41. nonterminal `shell.require` has implementation-defined status semantics;
42. JIF header integers silently exceed `2^53-1`;
43. committed environment generations are automatically deleted in v0.0.x;
44. a Forge parameter may use reserved `exec-*`;
45. CORE table parsing pads/truncates malformed rows contrary to §28;
46. contained profiles can reach host Julia startup/config paths by default.

# 51. Builder obligations

The implementation agent MUST:

1. fork/vendor the pinned GNU Bash source;
2. keep the Bash grammar patch small and auditable;
3. add native JUL grammar/AST support;
4. implement the exact mixed-pipeline normalization/status rules in §6;
5. implement `{}` as Map and `@{}` as PipelineBlock with no schema-aware ambiguity;
6. implement the JUL lexical grammar before adding syntax;
7. implement an actual process-visible JUL pipeline worker;
8. implement logical-session inheritance rules for Bash forks/subshells;
9. implement JIF v1 canonical framing and committed byte fixtures;
10. implement immutable linear environment generations;
11. implement migration preflight and no-silent-loss semantics;
12. implement immutable Core Pack constraints;
13. implement the package broker and environment/artifact locks;
14. implement Forge parameters, source capture, fixtures, contextual validation, revisions, and retrieval;
15. implement every CORE OperationSpec exactly or fail the build;
16. implement raw Julia same-block/world-age semantic tests;
17. implement canonical structured errors and status mapping;
18. implement contained-profile private HOME/depot/startup isolation;
19. implement capability-bound broker access rather than exposing an unrestricted daemon socket;
20. implement all P0/P1/P2 conformance gates;
21. preserve and run the selected upstream Bash differential tests;
22. surface every test failure;
23. document every intentional compatibility deviation;
24. refuse to invent semantics where this specification remains ambiguous.

The builder MAY choose internal data structures, languages for support processes, IPC library, test framework, and performance optimizations only when they do not change observable semantics.

v0.0.6 closure obligations:

25. implement FixtureRef / ComparatorRef / PackageSpec lexical classes exactly;
26. implement terminal-only `shell.require`;
27. implement strict CSV/TSV/table/join contracts;
28. implement Text-capable symbolic predicates and name precedence;
29. reject JIF header metadata above `2^53-1`;
30. implement deterministic trace serialization and `DEV-EXPORT-F-JUL`;
31. do not invent semantics where this specification is silent.

# 52. Implementation handoff contract

v0.0.7-IMPLEMENTATION is the normative implementation source of truth.

The architecture/specification red-team sequence is complete.

Recorded gate trajectory:

```text
RT3  builder ambiguity: 58/100
RT4  builder ambiguity: 22/100
RT5  builder ambiguity: 13/100
RT5  constitutional failures: none
RT5  security lies: none
RT5  CRITICAL findings: none
RT5  HIGH findings: none
RT5  verdict before closure: READY AFTER MINOR SPEC PATCH
```

v0.0.7 applies the RT5 blocking patch list and the remaining cheap oracle clarifications.

## HANDOFF-001 — No silent redesign

The implementation agent MUST implement the normative semantics in this document.

It MUST NOT replace:

- native Bash parser integration with an external source rewriter;
- `|!>` with a different user syntax;
- JUL typed flow with text serialization between stages;
- JIF with opaque Julia serialization;
- immutable linear environment generations with in-place package mutation;
- Forge source/IR artifacts with opaque closures;
- host-enforced security profiles with language-only checks.

## HANDOFF-002 — Internal freedom

The implementation agent MAY choose internal implementation details not fixed by observable semantics, including:

```text
support-process implementation language
IPC library
Rust/C/Julia internal module boundaries
in-memory data structures
private cache implementation
test framework
build orchestration
performance optimizations
```

provided normative behavior and tests remain conforming.

## HANDOFF-003 — Spec conflict handling

If the implementation agent discovers a genuine contradiction between normative requirements:

1. do not silently choose one;
2. create the smallest failing conformance test reproducing it;
3. record both requirement IDs and competing outcomes in `SPEC_BLOCKERS.md`;
4. continue independent implementation work;
5. do not weaken a MUST merely to make tests pass.

A missing internal implementation detail that does not affect observable semantics is NOT a spec blocker.

## HANDOFF-004 — Test-first gates

Before broad implementation, commit the P0 grammar/JIF/pipeline fixtures from §44.

Conformance tests are developed alongside each subsystem.

The build is complete only when the required conformance gates pass or remaining platform-dependent manual items are explicitly documented.

## HANDOFF-005 — Compatibility discipline

Bash-only behavior is compared against the exact pinned GNU Bash build.

A deterministic Bash-only difference must be fixed or explicitly entered in `COMPATIBILITY_DEVIATIONS.md` where this specification requires/allows it.

No unexplained difference is accepted.

## HANDOFF-006 — Failure honesty

The implementation agent MUST surface:

```text
compiler errors
test failures
unsupported host-kernel security capabilities
Julia/package failures
performance/resource failures
remaining SPEC_BLOCKERS
```

It MUST NOT replace a required subsystem with a stub while reporting the build complete.

## HANDOFF-007 — Completion report

The final implementation report MUST include:

```text
build instructions
repository/module map
pinned Bash source identity/hash
Julia/Core Pack versions
conformance counts by suite
remaining failures, if any
COMPATIBILITY_DEVIATIONS.md contents
SPEC_BLOCKERS.md contents
security backend actually active
canonical §47 E2E transcript
```

A zero-entry `SPEC_BLOCKERS.md` is the implementation target.

# 53. North Star

The intended progression is:

```text
"I know Bash."
    ->
"This shell can carry typed values."
    ->
"I can execute exact mathematics."
    ->
"I can represent structured problems directly."
    ->
"I can use Julia packages without environment ceremony."
    ->
"I can compose the symbolic operation I need."
    ->
"If composition is insufficient, I can use real Julia."
    ->
"I can expose that implementation as a typed tool."
    ->
"I can parameterize it."
    ->
"I can test it against immutable fixtures."
    ->
"I can keep it as reconstructible source/IR."
    ->
"I can retrieve it in another session."
    ->
"I do not need to solve that deterministic subproblem from scratch again."
```

The human does not need to predict every primitive the model will eventually require.

The substrate supplies a stable shell prior, an explicit typed descent, a bottomless Julia escape hatch, and a mechanism for useful symbolic machinery to accumulate.

# 54. RT5 final closure matrix

RT5 result on v0.0.6-PRE-RT5:

```text
constitutional failures: none
security lies: none
CRITICAL findings: none
HIGH findings: none
builder ambiguity score: 13/100
verdict: READY AFTER MINOR SPEC PATCH
```

v0.0.7 applies the complete blocking patch list plus the remaining cheap genie/MUST-audit clarifications.

| RT5 item | v0.0.7 resolution |
|---|---|
| RT5-001 JSON Complex | all Complex rejected by `render.json` with `NonInterchangeableValueError`; real non-finite Float remains `JSONEncodingError` |
| RT5-002 shell.run no-capture | child inherits JUL worker stdin/stdout/stderr exactly |
| RT5-003 test `--tol` | typo removed; approximate comparator uses `--atol` / `--rtol`; no `--tol` alias |
| RT5-004 predicate Bool/Null | `true`, `false`, `null` are explicit symbolic/predicate scalar literals |
| RT5-005 bootstrap enum | one shared enum: UNINITIALIZED, BOOTSTRAPPING, READY, FAILED, JULIA_MISSING |
| RT5-006 table.describe Nulls | statistics use non-Null values; missing counted separately; insufficient sample fields become Null |
| RT5-007 graph weight type | weight column restricted to Integer/BigInt/Float, no Null |
| RT5-008 tool.history | `defined` on every new definition/revision; `registered` on every successful registration |
| RT5-009 empty delimited Table | zero columns -> empty bytes; nonzero columns -> header even with zero rows |
| RT5-010 path normalization | exact lexical algorithm; no trailing slash except root |
| MUST audit: path normalization | exact component algorithm defined |
| MUST audit: table.describe applicability | explicit per-field rules defined |
| MUST audit: tool.test profile timing | invocation-time profile, included in validation context |
| MUST audit: trace stability | TRACE-002 serializer, byte-stable within release |
| info: malformed `cmp:` | reserved prefix; malformed forms are ParseError |
| info: fixture dotted names | fixture name is exactly `ident`; invalid alternate forms are ParseError |
| info: julia.block no heredoc | ParseError; exactly one heredoc required |
| info: pkg.search cache/registry | deterministic source precedence specified |
| info: remediation comma ambiguity | remediation is compact JSON string array in text mode |
| info: BigInt approximate | arbitrary-precision comparison; no Float64 truncation of BigInt operands |

This revision is deliberately not followed by another architecture red-team gate.

The next phase is implementation and empirical conformance.

---

**END NeuraBash v0.0.7-IMPLEMENTATION**
