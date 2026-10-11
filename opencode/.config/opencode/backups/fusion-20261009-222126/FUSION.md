# Fusion orchestration

Configured and validated on OpenCode v2.0.24, 2026-10-09.

## Use

Start `opencode` in a repository. New sessions default to `fusion` and GPT-6.1 Sol.
The visible agents are `build`, `plan`, and `fusion`. `fusion-executor` is a
hidden, subagent-only implementation profile. Hidden maintenance agents remain
available to OpenCode internally; `general` and `explore` are disabled.

For a reproducible non-interactive invocation with high reasoning:

```sh
opencode run --agent fusion --model openai/gpt-6.1-sol#high "Implement the requested change"
```

In an existing interactive session, select Fusion in the agent picker **and**
select GPT-6.1 Sol/high in the model picker. OpenCode stores the agent and model
separately; changing agents does not replace an existing session's model.
The root model default does not retain a variant in this version. The default
invocation test used Sol without an explicit variant; the explicit invocation
test used Sol/high. Avoid `--auto` if you want approval gates to remain meaningful.

## Workflow

User request → Fusion discovery and bounded plan → native `subagent` invocation
of `fusion-executor` → implementation and verification → Fusion review → final
response. Related corrections reuse the returned child session ID. Questions
and explanations are handled directly. The prompt normally budgets one
implementation pass and no more than two correction passes before escalation.

Both profiles live in `~/.config/opencode/opencode.json`, under `agents`:

- `fusion.model`: `openai/gpt-6.1-sol#high`.
- `fusion-executor.model`: `opencode-go/mimo-v2.6-pro`.
- `model`: default primary-session model, currently `openai/gpt-6.1-sol`.
- `default_agent`: `fusion`.

SWE-2 was absent from the available provider catalog. Codex Spark was present,
but a live invocation failed because it is unsupported with this ChatGPT
account. MiMo-V2.6-Pro succeeded through the existing OpenCode Go connection.
Its catalog rates were $0.435 input / $0.87 output / $0.003625 cached input per
million tokens. Actual subscription accounting may differ. OpenAI's connection
did not report prices; no measured cost or comparative coding benchmark is
claimed. MiMo is a cost-conscious alternative, not a demonstrated SWE-2
equivalent.

## Permissions and limitations

Enforced by the configured tool permission rules:

- Fusion can discover files and web sources, load skills, and ask questions.
- Fusion edits require approval. Shell commands require approval except selected
  Git inspection prefixes. Explicit push/reset/clean/rm/sudo commands are denied.
- Fusion may launch only `fusion-executor` through the native subagent tool.
- The Executor can edit source and run implementation/test/format commands.
  External-directory access asks for approval. Edit-tool changes to OpenCode's
  global configuration/data directories are denied.
- The Executor cannot launch subagents or ask the user questions. Several
  destructive Git commands, commits, pushes, nested `opencode` commands, and
  PR creation are denied by command patterns.
- Code Mode is denied for both profiles. Fusion's broad deny also blocks
  unlisted tools, including MCP mutation tools; existing MCP configurations are
  preserved. The Executor retains other default tool permissions.

Prompt instructions, not hard architectural enforcement:

- Default delegation, task scope, architectural escalation, review criteria,
  loop budgets, context efficiency, and truthful verification reporting.
- Explicit user authorization before Fusion requests edit approval.
- No shell/API/MCP bypasses, indirect model switching, or scope expansion.

This is native two-agent orchestration, not a sandbox or a Fusion-specific
scheduler. The Executor's broad shell permission is needed for arbitrary build
and test scripts; those scripts run with the host user's authority and could
perform actions not caught by command patterns. Even Git inspection can invoke
configured external helpers. Approvals and prompts do not provide filesystem
isolation. Hidden status affects discovery, not security. A user or a different
agent can address the hidden Executor explicitly. Project config can override
global agent/model settings and append permission rules. For untrusted projects,
use an isolated environment and a narrower project-specific shell policy.

## Validation evidence

- `opencode reload` accepted the configuration.
- `/api/agent` listed exactly `fusion`, `build`, and `plan` as visible agents,
  with the hidden Executor accessible by ID and the expected model preferences.
- Static checks against server-resolved ordered permissions confirmed expected
  read/edit/shell/delegation effects. These were rule checks, not sandbox tests.
- An invocation without agent/model flags selected Fusion and GPT-6.1 Sol.
- Live delegation used Sol/high in parent
  `ses_edcb5538effeLue5Cap1BHVJJZ` and MiMo-V2.6-Pro in child
  `ses_edcb5453cffeRcQ5jZC1EM8kwA`; neither used a child model override.
- The child shell tool ran
  `python3 -c "assert 2 + 2 == 4; print(\"FUSION_EXECUTOR_CHECK_OK\")"`,
  returned `FUSION_EXECUTOR_CHECK_OK`, and recorded exit code 0. Fusion reviewed
  the result and reported success. No application source was changed or tested.

The six former custom agents were removed from the active global configuration.
The original file is preserved at:

```text
~/.config/opencode/backups/fusion-20261009-214923/opencode.json
```

Unrelated settings were checked against that backup and preserved, except the
OpenSpec plugin entry, which was removed at the user's explicit request. No active
project configuration was found under `/home/thales` or at the four existing
repository roots inspected. Deeper or future project configurations can still
override these defaults.

## Change models later

Use `opencode models` to discover models, then validate account entitlement with
a small live request; catalog presence alone is insufficient. Back up the global
config before editing the relevant `agents.<id>.model`. When changing the primary
model, also update the root `model` for new sessions. Run `opencode reload`, create
a fresh session, and repeat a non-destructive delegation check. Existing sessions
may retain their previous model; use the model picker or explicit CLI flags.

## Existing issues and future improvements

- `opencode-plugin-openspec` was already failing with: "Plugin must export a
  default definition with an id and an effect or setup function." The user
  removed it in another session and explicitly requested that it stay removed.
  Its config entry is absent; orchestration does not require it. Do not restore it.
- V2 documentation says the existing `instructions` setting is preserved but
  not loaded. If those guidelines are required, separately migrate them into
  a discovered `AGENTS.md`, replacing references to removed review agents with
  Fusion's own review. No global instruction files were changed during setup.
- Measure acceptance rate, correction count, latency, subscription consumption,
  and real-project test outcomes before changing the Executor. Tighten shell
  permissions per repository when its validation commands are known.

## Documentation consulted

- https://opencode.ai/v2/docs/agents
- https://opencode.ai/v2/docs/config
- https://opencode.ai/v2/docs/permissions
- https://opencode.ai/v2/docs/cli
- https://opencode.ai/v2/docs/api
- https://opencode.ai/v2/docs/migrate-v1
- https://opencode.ai/v2/openapi.json
