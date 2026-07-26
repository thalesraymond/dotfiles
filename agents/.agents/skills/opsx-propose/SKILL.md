---
name: opsx-propose
description: Create a new OpenSpec change with all required artifacts (proposal, design, tasks) in one step. Activate when the user wants to start a new feature, refactor, or bug-fix and an OpenSpec change does not already exist.
metadata:
  author: thales
  version: "1.0"
---

# opsx-propose

Create a new OpenSpec change and generate all artifacts needed before implementation.

## Input

Accept either:
- A kebab-case change name (e.g. `add-user-auth`)
- A plain-language description (e.g. "add user authentication"), from which you derive a kebab-case name

If no input is provided, ask:
> "What change do you want to work on? Describe what you want to build or fix."

**Do not proceed** until the goal is clear.

## Steps

### 1. Name the change

Convert the user's input to kebab-case (`add user authentication` → `add-user-auth`).
Announce: **“Creating change: <name>”**.

If a change with that name already exists, ask whether to continue it or create a new one.

### 2. Scaffold the change

```bash
openspec new change "<name>"
```

### 3. Check artifact build order and paths

```bash
openspec status --change "<name>" --json
```

Extract from the JSON:
- `applyRequires`: artifact IDs that must be completed before implementation (commonly `["tasks"]` or `["proposal","design","tasks"]`)
- `artifacts`: all artifacts, their dependencies and statuses
- `planningHome`, `changeRoot`, `artifactPaths`, `actionContext`: path/scope context (use these instead of assuming repo-local paths)

### 4. Create artifacts in dependency order

Use the **TodoWrite tool** to track progress.

Loop through artifacts whose dependencies are satisfied (`ready`):

1. Get artifact instructions:
   ```bash
   openspec instructions <artifact-id> --change "<name>" --json
   ```
   The output includes:
   - `context`: constraints for you — **do not** copy into the artifact
   - `rules`: constraints for you — **do not** copy into the artifact
   - `template`: structure to use for the artifact
   - `instruction`: schema-specific guidance
   - `resolvedOutputPath`: where to write the artifact
   - `dependencies`: completed artifacts to read for context

2. Read any completed dependency artifacts for context.
3. Write the artifact to `resolvedOutputPath` using `template` as the structure.
4. Apply `context` and `rules` as constraints, but never include them in the file.
5. Show brief progress: **“Created <artifact-id>”**.
6. Re-run `openspec status --change "<name>" --json` and continue until all `applyRequires` artifacts are `done`.

If an artifact requires user input, use **AskUserQuestion** to clarify, then continue.

### 5. Finalize

Show final status:

```bash
openspec status --change "<name>"
```

Then summarize:
- Change name and location
- Artifacts created with brief descriptions
- What's ready
- Next step: **“Run `/opsx:apply` to start implementing.”**

## Output template

```markdown
## Change Proposed

**Change:** <change-name>
**Location:** <change-root>
**Artifacts created:**
- proposal.md — what & why
- design.md — how
- tasks.md — implementation steps

All artifacts are ready. Run `/opsx:apply <change-name>` to begin implementation.
```

## Guardrails
- Never create a change without understanding the user's goal.
- Create **all** artifacts in `applyRequires` before finishing.
- Always read dependency artifacts before creating a downstream one.
- Do **not** copy `<context>`, `<rules>`, or `<project_context>` blocks into artifacts — they are constraints for you, not content.
- Verify each artifact file exists before moving to the next one.
- If a change name already exists, ask whether to continue or rename.
