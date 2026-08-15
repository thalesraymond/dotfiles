#!/usr/bin/env bash
# Worktree helpers for working on several tasks in parallel.
#
# Layout: $HOME/projects/<project>.worktree/<branch>
#   <project> = basename of the git repo root.
#
# This file is meant to be SOURCED, not executed, so it sets no shell options
# that would leak into the caller's shell.
#
# Usage (after sourcing, from any checkout of the repo):
#   wt_create <branch> [base]   # open a lane; base matters only for new branches
#   wt_remove <branch>          # close a lane, keep the branch
#   wt_remove_branch <branch>   # close a lane and delete the branch

# Root that holds every lane of the current repo.
wt_root() {
  local project_dir project_name
  project_dir="$(git rev-parse --show-toplevel)" || return 1
  project_name="$(basename "$project_dir")"
  printf '%s' "$HOME/projects/${project_name}.worktree"
}

# Lane path for a branch.
wt_path() {
  printf '%s/%s' "$(wt_root)" "$1"
}

# Open a lane for a branch. Picks the command itself, no prompting:
#   branch exists locally      -> git worktree add <path> <branch>
#   branch exists on origin/   -> git worktree add --track -b <branch> <path> origin/<branch>
#   branch is brand new        -> git worktree add -b <branch> <path> <base>
wt_create() {
  local branch="$1"
  local base="${2:-HEAD}"
  local root wt
  root="$(wt_root)" || return 1
  wt="$(wt_path "$branch")"

  if [[ -d "$wt" ]]; then
    echo "error: lane already exists at $wt" >&2
    return 1
  fi

  mkdir -p "$root"

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git worktree add "$wt" "$branch"
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    git worktree add --track -b "$branch" "$wt" "origin/$branch"
  else
    git worktree add -b "$branch" "$wt" "$base"
  fi
}

# Close a lane for a branch. The branch itself survives.
wt_remove() {
  local branch="$1"
  local wt
  wt="$(wt_path "$branch")"

  if [[ ! -d "$wt" ]]; then
    echo "error: no lane at $wt" >&2
    return 1
  fi

  git worktree remove --force "$wt"
}

# Close a lane and delete its branch.
wt_remove_branch() {
  wt_remove "$1" || return 1
  git branch -D "$1"
}
