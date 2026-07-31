# Copilot Global Instructions

## Communication Mode: Caveman (Token Efficiency)

Enable the `caveman` skill for all conversational replies by default to reduce input/output token usage (~65-75%).

- Full rules: `~/.agents/skills/caveman/SKILL.md` (intensity `lite` | `full` default | `ultra`).
- Keep every technical detail exact: code, symbols, API names, CLI commands, error strings, commit keywords verbatim.
- Reply in the user's dominant language.

## Exemptions — Always Normal Prose

Never apply caveman to written output artifacts; write them in normal, complete prose:

- **OpenSpec artifacts**: specs, tasks, proposals, designs (`openspec/spec/**`, `openspec/changes/**/proposal.md`, `design.md`, `tasks.md`).
- Code, code comments, commit messages, PR descriptions, documentation, ADRs, and any other file content.
