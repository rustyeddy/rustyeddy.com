---
title: "Writing Agent Instructions for a New Software Project"
date: 2026-08-01
description: >
  An outline for creating concise, verifiable repository instructions that work
  across Claude, GitHub Copilot, and ChatGPT without duplicating project policy.
tags: ["AI Agents", "Claude", "GitHub Copilot", "ChatGPT", "Software Engineering"]
categories: ["Software Engineering"]
---

## Working Thesis

Agent instructions should be treated as an executable interface to a repository,
not as a long prompt. A useful instruction set tells an agent where truth lives,
which boundaries it must preserve, how to verify a change, and when to stop and
ask for a decision.

The [Trader repository](https://github.com/rustyeddy/trader) and its
[agent-instructions pull request](https://github.com/rustyeddy/trader/pull/9)
provide the running example. The pull request is intentionally useful as a
work in progress: its structure shows what to centralize, while its review
comments show why every path and command in an instruction file must be tested.

## Outline

### 1. Begin with the Decisions an Agent Must Not Invent

- Establish the project purpose, current maturity, and safety posture.
- Name architectural boundaries rather than asking the agent to infer them from
  the directory tree.
- Separate settled decisions from open design questions.
- Define explicit stop conditions for changes that require a new architecture
  decision.

**Trader example:** The milestone plan supplies concrete constraints: strategies
emit intents rather than broker orders, risk and execution are separate stages,
and paper trading is the safe default. These are durable project rules. The
choice of a future storage technology is not.

### 2. Put Shared Policy in One Canonical File

- Use a root `AGENTS.md` for instructions that apply across coding agents.
- Keep it short enough to scan before every task.
- Point to architecture records, contribution rules, and detailed workflows
  instead of copying them.
- Prefer a small number of strong constraints over a catalog of generic advice.

Suggested contents:

1. What the project does and does not do.
2. The source-of-truth documents, in reading order.
3. Architectural invariants and safety constraints.
4. Existing build, test, lint, and documentation commands.
5. Scope, review, and definition-of-done rules.
6. Conditions that require clarification rather than implementation.

**Trader example:** Pull request #9 makes `AGENTS.md` the canonical entry point,
then keeps the Claude and Copilot files as adapters. That avoids maintaining
three independent versions of the project rules.

### 3. Add Thin Adapters for Claude, Copilot, and ChatGPT

| Agent | Repository entry point | Keep tool-specific |
| --- | --- | --- |
| Claude Code | `CLAUDE.md` | Claude imports, commands, and scoped rules |
| GitHub Copilot | `.github/copilot-instructions.md` | Copilot's issue, review, and PR workflow |
| ChatGPT/Codex | `AGENTS.md` | Directory-scoped overrides; project or task context belongs outside shared repository policy |

- `CLAUDE.md` can import the canonical file and the few documents Claude should
  load for every task.
- Copilot's repository file should direct the coding agent and reviewer to the
  same policy, then state only the GitHub-specific workflow.
- ChatGPT conversations need the same project constraints, but transient goals
  and uploaded context should remain in the ChatGPT project or task rather than
  being committed as repository policy. Codex can consume `AGENTS.md` directly.
- Trader does not add a ChatGPT-specific file in pull request #9. That absence
  reinforces the boundary: shared policy belongs in the repository, while
  conversation-specific context belongs in ChatGPT.
- Do not copy the same architecture and test rules into every adapter. Duplicate
  instructions drift and make precedence unclear.

### 4. Write Instructions an Agent Can Verify

Turn preferences into observable requirements:

- Weak: "Write good tests."
- Strong: "Add deterministic tests for new behavior and run `make check`."
- Weak: "Respect the architecture."
- Strong: "Strategies emit intents; they do not import broker adapters or submit
  orders."
- Weak: "Update docs when needed."
- Strong: "Update the architecture document when a package boundary changes;
  record durable decisions in an ADR."

For each command, say whether it checks or modifies the tree. For each referenced
document, explain why and when it should be read.

### 5. Keep Project Knowledge Layered

- Root instructions: universal repository rules.
- Architecture and ADRs: system decisions and dependency direction.
- Contribution guide: workflow and definition of done.
- Path-specific instructions: rules for one language, package, or subsystem.
- Skills or workflow documents: repeatable procedures that are too detailed for
  the root file.
- Issue or task: the desired outcome, scope, non-goals, and acceptance criteria.

Explain precedence explicitly. Local instructions may specialize a root rule,
but should not silently contradict safety or architectural constraints.

### 6. Test the Instructions Like an Interface

Before merging an instruction change:

1. Open every linked file from a fresh checkout.
2. Run every required command exactly as written.
3. Confirm the command checks what the prose claims.
4. Ask each supported agent to summarize the applicable rules.
5. Give each agent one small representative task and compare its plan with the
   architecture and acceptance criteria.
6. Review the resulting diff for scope, tests, documentation, and safety.

**Trader review lesson:** Pull request #9 points to `CONTRIBUTING.org`,
`docs/arch/package-boundaries.org`, and detailed workflow files before those
files exist. Its Copilot review catches the broken references. The PR also says
workflows were updated without adding a workflow. These are documentation
defects, but to an agent they are broken dependencies.

The same check applies to commands. Trader's current `make check` runs formatting,
vetting, and tests, but not its separate race target. Instructions should describe
the command that exists, then change the Makefile and prose together when the
quality gate changes.

### 7. Avoid Common Failure Modes

- A giant prompt that competes with the task for context.
- Generic rules the formatter, compiler, or test suite already enforces.
- Broken links, aspirational commands, and nonexistent workflows.
- Three tool-specific files that duplicate and contradict one another.
- Rules without a reason, scope, or way to verify compliance.
- Requirements that force agents to read the entire documentation tree.
- Permission to make architectural decisions merely to finish an issue.
- Stale instructions that describe the intended repository instead of the
  repository an agent actually receives.

### 8. Evolve Instructions from Review Evidence

- Add a durable rule when the same review correction recurs.
- Remove a rule once automation makes it redundant.
- Keep task-specific lessons in issues and pull requests unless they generalize.
- Review instruction files when commands, package boundaries, or the definition
  of done changes.
- Assign ownership: instruction changes deserve the same review as build and CI
  changes because they alter automated contributor behavior.

### 9. A Minimal Starting Template

```text
# Project
Purpose, maturity, and non-goals.

## Read Before Changing Code
Only existing source-of-truth documents, in order.

## Invariants
Architectural and safety decisions the agent must preserve.

## Workflow
Scope rules, definition of done, and when to stop.

## Verification
Exact commands and what each one proves.
```

Add a tool-specific adapter only when that tool needs different discovery,
scoping, or workflow instructions.

## Closing Checklist

- Is there one canonical source for shared policy?
- Does every referenced path exist?
- Does every command run and verify what the text promises?
- Are architecture, safety, and non-goals explicit?
- Can the agent distinguish settled decisions from open questions?
- Are Claude, Copilot, and ChatGPT receiving the same project rules without
  copied policy?
- Are local overrides narrow and is precedence clear?
- Is the instruction set shorter than the documentation it points to?
- Would a new engineer also find these instructions accurate and useful?

## Source Notes for the Finished Article

- [Trader pull request #9](https://github.com/rustyeddy/trader/pull/9) for the
  `AGENTS.md`, `CLAUDE.md`, Copilot adapter, and review examples.
- [Claude Code memory documentation](https://code.claude.com/docs/en/memory) for
  `CLAUDE.md` discovery and imports.
- [GitHub Copilot custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions)
  for repository and path-specific instruction support.
- [OpenAI agent configuration](https://developers.openai.com/codex/guides/agents-md)
  for `AGENTS.md` discovery and precedence in ChatGPT/Codex workflows.
