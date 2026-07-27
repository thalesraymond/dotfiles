---
name: opencode-planner-mid
description: "Balanced architect agent for standard feature implementation using OpenCode Go models."
model:
  - Qwen 3.7 Plus (customendpoint)
user-invocable: true
disable-model-invocation: false
tools: [vscode, read, agent, search, todo]
handoffs:
  - label: "Explore Codebase First"
    agent: opencode-explore
    prompt: "Locate all files, functions, interfaces, and dependencies for the active OpenSpec change and summarize implementation constraints in a concise report."
    send: true
  - label: "Execute Plan with Builder"
    agent: opencode-builder-mid
    prompt: "Implement the active OpenSpec plan step-by-step. First update spec artifacts if needed, then implement code tasks, and do not deviate from non-goals."
    send: true
---
