---
name: opsx-apply
description: Execute the active OpenSpec change by reading its artifacts, implementing pending tasks, updating spec files, and running verification commands. Activate when the user wants to apply, implement, or continue an OpenSpec change.
metadata:
  author: thales
  version: "1.0"
---

# opsx-apply

Apply the active OpenSpec change. Update spec artifacts first, implement code tasks, and stop on the first failure.

## Input

Optionally accept a change name (e.g. `apply add-auth`). If omitted:
- Infer from conversation context if the user mentioned a change.
- Auto-select if only one active change exists.
- Otherwise run `openspec list --json` and ask the user to choose.

Always announce: **“Using change: <name>”** (and how to override).

## Steps

### 1. Select and validate the change

- If no name is provided, use the rules above.
- Run:
  ```bash
  openspec status --change "<name>" --json
  ```
- Parse the JSON for:
  - `schemaName`
  - `planningHome`, `changeRoot`, `actionContext`
  - Which artifact holds the task list (usually `tasks` for spec-driven schemas)

**Workspace guard:** If `actionContext.mode` is `workspace-planning` and `allowedEditRoots` is empty, stop. Explain that full-workspace apply is not supported; ask for an affected repo/area.

### 2. Get apply instructions

```bash
openspec instructions apply --change "<name>" --json
```

Extract:
- `contextFiles`: map of artifact ID → concrete file paths
- Progress and remaining task list
- Dynamic instruction text

Handle states:
- `blocked`: show the blocker and suggest continuing other work.
- `all_done`: congratulate and suggest `/opsx:archive`.
- Otherwise proceed.

### 3. Read context files

Read every file listed in `contextFiles`. The exact set depends on the schema (e.g. `proposal.md`, `design.md`, `tasks.md`). Do not assume fixed filenames.

### 4. Show progress

Display:
- Schema name
- “N/M tasks complete”
- Remaining tasks overview
- Key dynamic instruction from the CLI

### 5. Implement pending tasks

For each remaining task:

1. State which task is being worked on.
2. Keep changes minimal and scoped to the task.
3. Update spec artifacts **before** changing code when artifacts need to reflect new decisions.
4. Mark the task complete: change `- [ ]` to `- [x]` **immediately** after it passes verification.
5. Continue to the next task.

**Pause if:**
- The task is unclear → ask for clarification.
- Implementation reveals a design problem → suggest updating artifacts and stop for guidance.
- An error or blocker is encountered → report it and stop.

### 6. Verify continuously

Use the repository-specific verification commands from `AGENTS.md` / `.github/copilot-instructions.md`. Typical commands include:

- `pnpm lint && pnpm format:check && pnpm build && pnpm test && pnpm coverage`
- `go test ./... && go vet ./... && golangci-lint run`

**Stop immediately** on the first failure and report why before continuing.

### 7. Finalize

When all tasks are done:
- Run a final verification pass.
- Summarize completed tasks and files changed.
- Suggest running `/opsx:archive`.

## Output templates

### During implementation

```markdown
## Implementing: <change-name> (schema: <schema-name>)

Working on task 3/7: <task description>
...
✓ Task complete
```

### On completion

```markdown
## Implementation Complete

**Change:** <change-name>
**Schema:** <schema-name>
**Progress:** 7/7 tasks complete ✓

### Completed This Session
- [x] Task 1
- [x] Task 2

All tasks complete! You can archive this change with `/opsx:archive`.
```

### On pause

```markdown
## Implementation Paused

**Change:** <change-name>
**Schema:** <schema-name>
**Progress:** 4/7 tasks complete

### Issue Encountered
<description>

**Options:**
1. <option 1>
2. <option 2>
3. Other approach

What would you like to do?
```

## Guardrails
- Never guess a change name; ask when ambiguous.
- Read all `contextFiles` before editing.
- Prefer `openspec instructions` over hard-coded file names.
- Keep diffs minimal; do not refactor unrelated code.
- Update task checkboxes as soon as tasks are verified.
- Stop on all errors, blockers, and ambiguous requirements.
