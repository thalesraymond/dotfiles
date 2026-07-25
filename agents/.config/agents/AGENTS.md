# Universal AI Development Guidelines

> Global profile for all coding agents. Local `AGENTS.md` or `.github/copilot-instructions.md` extend these rules but never override them.

---

## 1. TDD & Engineering Standards

### Test-First Development

- Write a failing test **before** writing production code (Red → Green → Refactor).
- Name tests as specifications (e.g., `should return 404 when todo does not exist`).
- Mock **only** external boundaries (DB, network, disk). Never mock the system under test.
- Bug fixes require a regression test that fails before the fix.

### Type Safety & Architecture

- Strictly typed code only. Never use `any`, `as any`, or `as unknown`.
- Prefer the simplest implementation. Avoid speculative abstractions or premature optimization.
- Follow Clean/Hexagonal Architecture principles. Remove dead or commented-out code.

### Verification & Fail-Fast

- Run project-specific verification tools (lint, test, build, typecheck).
- **Stop immediately** on the first failure. Fix errors before writing new code.
- Report the exact error, file, and line before attempting a fix.

---

## 2. Agent Workflow

- **Plan First:** Always inspect or produce a step-by-step plan before making edits.
- **Review Loop:** Validate changes via the `@review` agent before finalizing. Fix, verify, and re-review until green.

---

## 3. Commit & Change Hygiene

- Follow [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`.
- Keep commits atomic (one logical change per commit).
- Update documentation and specs alongside behavior changes. Never commit credentials or secrets.

## 4. Additional Rules

> Additional specific rules can be found in the $HOME/.config/agents/rules directory.

- `ponytail.md`: Lazy senior dev mode (efficient, not careless). Follow the ladder of questions before writing code.
