---
name: opsx-archive
description: Close out a completed OpenSpec change by verifying artifact and task completion, optionally syncing delta specs into openspec/specs/, and moving the change directory to an archive. Activate when a change is fully implemented and reviewed.
metadata:
  author: thales
  version: "1.0"
---

# opsx-archive

Archive a completed OpenSpec change. Verify completion, sync delta specs into `openspec/specs/`, and move the change directory to the archive.

## Input

Optionally accept a change name (e.g. `archive add-auth`). If omitted:
- Infer from conversation context if the user mentioned a change.
- Run `openspec list --json` and ask the user to select from active changes.

**Never auto-select a change.** Always confirm or ask.

## Steps

### 1. Resolve the change

Run:

```bash
openspec list --json
```

Show only active (non-archived) changes. Ask the user to pick one if needed and announce the selected change.

### 2. Check artifact completion status

```bash
openspec status --change "<name>" --json
```

Parse:
- `schemaName`
- `planningHome.changesDir`, `changeRoot`, `artifactPaths`
- `artifacts`: artifact name → status (`done` or other)

**Workspace guard:** If `actionContext.mode` is `workspace-planning`, stop. Workspace-wide archive is not supported in this skill.

**If any artifacts are not `done`:**
- List them.
- Ask the user for confirmation before continuing.
- Proceed only if confirmed.

### 3. Check task completion status

Read the tasks artifact (commonly `tasks.md`) that belongs to the change. Count incomplete vs complete tasks:

- `- [ ]` = incomplete
- `- [x]` = complete

**If incomplete tasks exist:**
- Show a warning with the count.
- Ask for confirmation before continuing.

**If no tasks file exists:** Proceed.

### 4. Assess delta spec sync state

Use `artifactPaths.specs.existingOutputPaths` from the status JSON.

- **No delta specs:** proceed without sync.
- **Delta specs exist:**
  - Compare each delta spec with the corresponding main spec at `openspec/specs/<capability>/spec.md`.
  - Summarize adds, modifications, removals, and renames.
  - Prompt the user:
    - If changes are needed: “Sync now (recommended)”, “Archive without syncing”
    - If already synced: “Archive now”, “Sync anyway”, “Cancel”
  - If the user chooses sync, run the sync workflow (e.g. use the `openspec-sync-specs` skill or merge the files manually) before proceeding.

### 5. Perform the archive

1. Ensure the archive directory exists:
   ```bash
   mkdir -p "<planningHome.changesDir>/archive"
   ```
2. Generate the target name: `YYYY-MM-DD-<change-name>`
3. If the target already exists, fail with an error and suggest:
   - Renaming the existing archive, or
   - Deleting it if it is a duplicate, or
   - Waiting until a different date.
4. Move the change directory:
   ```bash
   mv "<changeRoot>" "<planningHome.changesDir>/archive/YYYY-MM-DD-<name>"
   ```

### 6. Display summary

Report:
- Change name
- Schema used
- Archive location
- Spec sync status (`synced`, `sync skipped`, or `no delta specs`)
- Any warnings (incomplete artifacts or tasks)

## Output templates

### On success

```markdown
## Archive Complete

**Change:** <change-name>
**Schema:** <schema-name>
**Archived to:** <archive-path>
**Specs:** ✓ Synced to main specs

All artifacts complete. All tasks complete.
```

### On success (no delta specs)

```markdown
## Archive Complete

**Change:** <change-name>
**Schema:** <schema-name>
**Archived to:** <archive-path>
**Specs:** No delta specs

All artifacts complete. All tasks complete.
```

### On success with warnings

```markdown
## Archive Complete (with warnings)

**Change:** <change-name>
**Schema:** <schema-name>
**Archived to:** <archive-path>
**Specs:** Sync skipped (user chose to skip)

**Warnings:**
- Archived with 2 incomplete artifacts
- Archived with 3 incomplete tasks
- Delta spec sync was skipped

Review the archive if this was not intentional.
```

### On error (archive exists)

```markdown
## Archive Failed

**Change:** <change-name>
**Target:** <archive-path>

Target archive directory already exists.

**Options:**
1. Rename the existing archive
2. Delete the existing archive if it's a duplicate
3. Wait until a different date to archive
```

## Guardrails
- Always prompt for change selection when not provided.
- Use `openspec status --json` as the source of truth for artifact paths.
- Do not block archive on warnings, but always disclose them and confirm.
- Preserve `.openspec.yaml` by moving the entire change directory.
- Run spec sync before the move when the user chooses it.
- Never archive workspace-mode changes.
