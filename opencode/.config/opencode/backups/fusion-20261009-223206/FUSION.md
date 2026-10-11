# Fusion orchestration

Configured and validated on OpenCode v2.0.24, 2026-10-09. Revised the same day
for multi-executor routing (Luna default, Kimi sequential fallback), medium
reasoning defaults, and native transcript logging.

## Use

Start `opencode` in a repository. New sessions default to `fusion` and GPT-6.1
Sol at medium reasoning. The visible agents are `build`, `plan`, and `fusion`.
`fusion-executor` (GPT-6 Luna) and `fusion-executor-kimi` (Kimi) are hidden,
subagent-only implementation profiles. Hidden maintenance agents remain
available to OpenCode internally; `general` and `explore` are disabled.

For a reproducible non-interactive invocation:

```sh
opencode run --agent fusion --model openai/gpt-6.1-sol#medium "Implement the requested change"
```

In an existing interactive session, select Fusion in the agent picker **and**
select GPT-6.1 Sol in the model picker. OpenCode stores the agent and model
separately; changing agents does not replace an existing session's model, and a
session's selected model takes precedence over the configured default. The root
model default does not retain a variant in this version, so Sol's variant is
applied at the model-settings level instead (see below). Existing sessions may
keep an earlier model or variant; use the model picker or explicit CLI flags to
change them. Avoid `--auto` if you want approval gates to remain meaningful.

## Model architecture

- `default_agent`: `fusion`.
- `model` (root default for new sessions): `openai/gpt-6.1-sol`. The root
  selector drops `#variant`, so
  `providers.openai.models.gpt-6.1-sol.settings.reasoningEffort` is set to
  `medium`; the default root therefore runs Sol at medium as well.
- `fusion.model`: `openai/gpt-6.1-sol#medium`.
- `fusion-executor.model` (default executor): `openai/gpt-6-luna#high`.
- `fusion-executor-kimi.model` (specialist for harder tasks executor):
  `opencode-go/kimi-k2.7-code`.

Verified catalog variants: Sol `low`/`medium`/`high`/`xhigh`/`max`; Luna
`none`/`low`/`medium`/`high`/`xhigh`/`max`; Kimi has none, so no invented
`#high` selector is used. Both account providers are stored through the
existing OpenCode connections; the OpenAI model endpoint is the ChatGPT
backend (codex). No plan or entitlement level is claimed beyond what those
existing connections verified.

## Routing

User request → Fusion (Sol) discovery and bounded plan → native `subagent`
invocation of an Executor → implementation and verification → Fusion review →
final response. Questions and explanations are handled directly.
Architectural decisions, requirements, and the final review and user response
stay with Sol in every path.

Default delegation goes to `fusion-executor` (Luna) for coherent bounded
implementation tasks, foreground by default. `fusion-executor-kimi` (Kimi) is
invoked only as if a complex tasks require a more robust coder.

Budget: one default implementation pass and at most two focused correction
passes in total, counted across all executors and models. Same-model
corrections reuse the returned child session ID. Every correction must change
the diagnosis or strategy rather than repeat an identical retry. A model
switch starts a new child session seeded with concise state and check
evidence and preserves all user work. When the budget is exhausted, stop and
escalate the blocker to the user; no endless retries.

## Permissions and limitations

Enforced by the configured tool permission rules (ordered rules, last match
wins):

- Fusion can discover files and web sources, load skills, and ask questions.
- Fusion edits require approval. Shell commands require approval except selected
  Git inspection prefixes. Explicit push/reset/clean/rm/sudo commands are denied.
- Fusion may launch only `fusion-executor` and `fusion-executor-kimi` through
  the native subagent tool; every other agent ID is denied.
- Either Executor can edit source and run implementation/test/format commands.
  External-directory access asks for approval. Edit-tool changes to OpenCode's
  global configuration/data directories are denied.
- The Executors cannot launch subagents or ask the user questions. Several
  destructive Git commands, commits, pushes, nested `opencode` commands, and
  PR creation are denied by command patterns.
- Code Mode is denied for all three profiles. Fusion's broad deny also blocks
  unlisted tools, including MCP mutation tools; existing MCP configurations are
  preserved. The Executors retain other default tool permissions.

Prompt instructions, not hard architectural enforcement:

- Default delegation and routing, task scope, architectural escalation, review
  criteria, the pass/correction budget, context efficiency, truthful
  verification reporting, and the no-model-override rule.
- Explicit user authorization before Fusion requests edit approval.
- No shell/API/MCP bypasses, indirect model switching, or scope expansion.
- The "never both, no superiority claims" routing language.

This is native two-executor orchestration, not a sandbox or a Fusion-specific
scheduler. The Executors' broad shell permission is needed for arbitrary build
and test scripts; those scripts run with the host user's authority and could
perform actions not caught by command patterns. Even Git inspection can invoke
configured external helpers. Approvals and prompts do not provide filesystem
isolation. Hidden status affects discovery, not security. A user or a different
agent can address the hidden Executors explicitly. Project config can override
global agent/model settings and append permission rules. For untrusted projects,
use an isolated environment and a narrower project-specific shell policy.

## Logging (native only)

Structured, concise `FUSION_RUN` and `FUSION_REVIEW` text blocks persist in the
normal executor and parent session transcripts. Logging never triggers extra
model runs, plugins, or a custom scheduler.

- Executors end each turn with one compact `FUSION_RUN` block. Fusion appends
  one compact `FUSION_REVIEW` block after each review or correction, adding the
  native child session ID when the child report lacks one.
- Fields: task id, attempt index, executor agent and actual model+variant,
  native child session ID, switch reason (none for a first attempt), exact
  tests/commands with exit codes and outcomes plus not-run checks, correction
  count, and acceptance/review result and status.
- Metrics come from the native session records only. Missing values are written
  as `unknown`, never estimated. Wall elapsed time, request time, and token
  categories are recorded distinctly when available.

To compare per-attempt child sessions, run (as the user; these are read-only
observations, not granted to the agents):

```sh
opencode stats --models --cost --tools --json
sqlite3 "$(opencode debug paths db)" '.tables'
```

Session export and per-session reads use the shared service HTTP API, for
example `GET /api/experimental/session/{sessionID}/export`,
`GET /api/session`, `GET /api/session/{sessionID}`,
`GET /api/session/{sessionID}/message`, and
`GET /api/experimental/session/stats` (see the API reference). No broad
API/session shell permission was added for Fusion: its shell rules remain
approval-gated outside Git inspection, Code Mode stays denied, and the
Executors remain forbidden to run nested `opencode` commands. The user may run
any of these commands directly.

No hardcoded model benchmark claim is recorded here or in the prompts.

## Validation evidence

- `opencode reload` accepted the earlier configuration; the current revision
  was verified by JSON parse and focused static assertions (parent reload and
  live delegation re-check pending).
- `/api/agent` listed exactly `fusion`, `build`, and `plan` as visible agents,
  with the hidden Executors accessible by ID and the expected model preferences.
- Static checks against server-resolved ordered permissions confirmed expected
  read/edit/shell/delegation effects. These were rule checks, not sandbox tests.
- Ordered permission checks confirmed both allowed subagent IDs
  (`fusion-executor`, `fusion-executor-kimi`), denial of other agent IDs, and
  denial of nested subagent launches for both Executors.
- Live smoke successes on 2026-10-09 through the existing connections: Sol at
  medium `ses_edc9e8db2ffeIEaW9r7XpPs1hn`, Luna at high
  `ses_edc9ea999ffeKrhZnR6AbHI1IV`, Kimi `ses_edc9ea3e0ffeCZALlNQjgEcTl2`.
  No Plus plan or entitlement level is claimed beyond the existing connection.
- An earlier invocation without agent/model flags selected Fusion and GPT-6.1
  Sol; an earlier live delegation used Sol/high in parent
  `ses_edcb5538effeLue5Cap1BHVJJZ` and MiMo-V2.6-Pro in child
  `ses_edcb5453cffeRcQ5jZC1EM8kwA` without a child model override. The child
  shell tool ran a trivial assertion, returned `FUSION_EXECUTOR_CHECK_OK`, and
  recorded exit code 0. No application source was changed or tested.

The six former custom agents were removed from the active global configuration.
Backups of prior contents are preserved at:

```text
~/.config/opencode/backups/fusion-20261009-214923/opencode.json
~/.config/opencode/backups/fusion-20261009-222126/opencode.json
~/.config/opencode/backups/fusion-20261009-222126/FUSION.md
```

Unrelated settings were checked against those backups and preserved, except the
OpenSpec plugin entry, which was removed at the user's explicit request. No
active project configuration was found under `/home/thales` or at the four
existing repository roots inspected. Deeper or future project configurations
can still override these defaults.

## Change models later

Use `opencode models` to discover models, then validate account entitlement with
a small live request; catalog presence alone is insufficient. Check the
catalog's variant list before appending `#variant`; an unknown variant is a
model-resolution error. Back up the global config before editing the relevant
`agents.<id>.model`. When changing the primary model, also update the root
`model` for new sessions and the model-level `settings.reasoningEffort` if a
specific default effort is required. Run `opencode reload`, create a fresh
session, and repeat a non-destructive delegation check. Existing sessions may
retain their previous model; use the model picker or explicit CLI flags.

## Existing issues and future improvements

- `opencode-plugin-openspec` was already failing with: "Plugin must export a
  default definition with an id and an effect or setup function." The user
  removed it in another session and explicitly requested that it stay removed.
  Its config entry is absent; orchestration does not require it. Do not restore it.
- V2 documentation says the existing `instructions` setting is preserved but
  not loaded. If those guidelines are required, separately migrate them into
  a discovered `AGENTS.md`, replacing references to removed review agents with
  Fusion's own review. No global instruction files were changed during setup.
- The previous executor, MiMo-V2.6-Pro through the OpenCode Go connection, is no
  longer routed by default. Its catalog rates were $0.435 input / $0.87 output /
  $0.003625 cached input per million tokens; actual subscription accounting may
  differ. The OpenAI connection reported no prices. No measured cost or
  comparative coding benchmark is claimed for any model here.
- Measure acceptance rate, correction count, latency, subscription consumption,
  and real-project test outcomes before changing an Executor. Tighten shell
  permissions per repository when its validation commands are known.

## Documentation consulted

- https://opencode.ai/v2/docs/agents
- https://opencode.ai/v2/docs/models
- https://opencode.ai/v2/docs/config
- https://opencode.ai/v2/docs/permissions
- https://opencode.ai/v2/docs/cli
- https://opencode.ai/v2/docs/api
- https://opencode.ai/v2/docs/migrate-v1
- https://opencode.ai/v2/openapi.json
