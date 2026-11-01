---
description: Start or resume a long-running goal with chief-of-staff
agent: orchestrator
model: "openai/gpt-6.1-sol#high"
---
Load the `chief-of-staff` skill with the skill tool and follow it for the rest of this session.

Goal: $ARGUMENTS

Before acting, read the project's shared wiki index (for Galaxify, `docs/wiki/index.md`) and the pages it links. If the goal is not in the issue tracker yet, create it with the project's tracker CLI (for GitHub, `gh issue create`).
