---
name: copilot-planner-low
description: "Fast architect agent for simple tasks and minor adjustments."
model:
  - Claude Haiku 4.5 (copilot)
user-invocable: true
disable-model-invocation: false
tools: [vscode, read, agent, search, todo]
handoffs:
  - label: "Explore Codebase First"
    agent: copilot-explorer
    prompt: "Locate all files, functions, interfaces, and dependencies for the active OpenSpec change and summarize implementation constraints in a concise report."
    send: true
  - label: "Execute Plan with Builder"
    agent: copilot-builder-low
    prompt: "Implement the active OpenSpec plan step-by-step. First update spec artifacts if needed, then implement code tasks, and do not deviate from non-goals."
    send: true
---
