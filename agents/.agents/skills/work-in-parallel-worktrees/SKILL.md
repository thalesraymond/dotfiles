---
name: work-in-parallel-worktrees
description: >-
  Work on two or more tickets or tasks at the same time in the same repository,
  each branch in its own worktree lane. Use when the user wants to work on
  multiple tasks, tickets, or PRs in parallel in one repo, needs several
  branches checked out at once, or wants to switch between tasks without
  stashing or re-checking out.
---

# Work in parallel worktrees

Every branch gets its own **lane**: a separate checkout at
`$HOME/projects/<project>.worktree/<branch>`, so two tasks never fight over one
working tree. Switching tasks costs a `cd`, never a stash.

## Steps

1. **Load the helpers.** In the main checkout, source the helper script from
   the skill folder:

   ```bash
   source ~/.agents/skills/work-in-parallel-worktrees/helpers/worktrees.sh
   ```

   (If the skill lives elsewhere, source it from wherever this `SKILL.md`
   sits.)

   Completion: `type wt_create` prints the function body.

2. **Open a lane per task.** For every branch the user named, run
   `wt_create <branch> [base]` from the main checkout. The script picks the
   command itself, no prompting:
   - branch exists locally → checked out as-is;
   - branch exists only on `origin/` → checked out tracking the remote;
   - branch is new → created with `-b` from `base` (default: current `HEAD`).

   Completion: `git worktree list` shows every task branch checked out exactly
   once at `$HOME/projects/<project>.worktree/<branch>`. If a task's branch is
   already active in the main checkout, that checkout is its lane — no worktree
   needed.

3. **Work inside the lanes.** cd into each lane to build, test, and commit
   there. The main checkout is untouched and keeps whatever the user had
   active, so other lanes (and their branches) stay safe mid-flight.

   Completion: the task's work is committed (and pushed, if that's the repo's
   workflow) from inside its lane.

4. **Close finished lanes.** When a task is merged or abandoned:
   `wt_remove <branch>` drops its worktree; `wt_remove_branch <branch>` also
   deletes the branch. Run from the main checkout.

   Completion: `git worktree list` shows no lane for finished tasks, and
   `git branch` no longer lists any branch you deleted.

## Rules

- One lane per branch: a branch already checked out somewhere cannot open a
  second lane — `wt_create` fails with a message rather than guessing.
- `<project>` is the basename of the repo root; every lane of a repo lives
  under `$HOME/projects/<project>.worktree/`.
- Branches with slashes (e.g. `feature/foo`) nest their directories.
- A new branch forks from `HEAD` by default; pass a base (`wt_create my-task
main`) when the task must start from another ref.
- Close a lane before deleting its branch — `wt_remove_branch` does both in
  the right order.
