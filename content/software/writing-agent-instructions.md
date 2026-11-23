---
title: "AGENTS.md and CLAUDE.md for Teams: Writing Agent Instructions You Can Verify"
date: 2026-08-01
lastmod: 2026-11-20
description: "How to write AGENTS.md and CLAUDE.md files for a team repo: one canonical file, thin tool adapters, rules every agent can verify, and a named owner."
tags: ["AI Agents", "Claude", "GitHub Copilot", "Codex", "Software Engineering"]
categories: ["Software Engineering"]
image: "/img/agents.jpg"
image_alt: "Three robots study a printed project plan at a workbench, in front of a chalkboard with diagrams labeled Agent Instructions and Project Specification."
---

## For leads

If your team uses coding agents, five requirements cover most of the risk.
Put them in your team standard and point developers at this page for the how.

1. **One canonical instruction file per repository.** `AGENTS.md` holds the
   shared rules. Tool-specific files such as `CLAUDE.md` stay thin and point
   to it, so the rules can't drift apart.
2. **Review instruction changes like CI changes.** They change what automated
   contributors do, so they get a pull request and a reviewer.
3. **Test every path and command they mention.** A broken link or a command
   that doesn't exist is a broken dependency for an agent.
4. **Give them an owner.** Someone updates them when commands, boundaries or
   the definition of done change.
5. **Agents never make the merge or release call.** A named person approves,
   and nobody, human or agent, pushes to the branch that auto-deploys.

The rest of this page is the practitioner version: what goes in the files,
how the main tools find them, how to run several agents on one repository,
and how to test the result. The examples come from this website's repository,
which is edited by Claude, Codex and Copilot. For the release side of the same
problem, see [release gates when AI writes the code](/software/release-process/#release-gates-when-ai-writes-the-code),
and for the wider process, the [software delivery guide](/software/).

## Instruction files are an interface, not a prompt

A prompt is something you type once and revise until the answer looks right.
An instruction file is read by every agent, on every task, including tasks
you didn't anticipate. It behaves more like an API: other things depend on
it, and a wrong entry fails in places you aren't looking.

A useful instruction set tells an agent four things:

- where the truth lives (which documents, in what order),
- which boundaries it must preserve,
- how to verify a change, and
- when to stop and ask for a decision.

Everything else is either enforced better by a tool (formatters, linters,
the compiler) or belongs in the issue that describes the task.

## What goes in, and what doesn't

Keep the file short enough to scan before every task. Claude Code's
documentation suggests targeting [under 200 lines per `CLAUDE.md`](https://code.claude.com/docs/en/memory),
and Codex stops adding instruction files once the combined size reaches
`project_doc_max_bytes`, 32 KiB by default
([Codex AGENTS.md guide](https://developers.openai.com/codex/guides/agents-md)).
Both limits point the same way: a long file competes with the task for context,
or gets cut off.

Include:

1. **What the project does and doesn't do.** Purpose, maturity, non-goals.
2. **Source-of-truth documents, in reading order,** with a reason to read
   each one.
3. **Invariants and safety constraints** the agent must preserve.
4. **The commands that exist,** and whether each one checks or modifies the
   tree.
5. **Scope, review and definition-of-done rules.**
6. **Conditions that require asking** instead of implementing.

Leave out generic advice ("write clean code"), anything a formatter or test
already enforces, and any decision the agent shouldn't make for itself.

### Turn preferences into observable rules

Compare these pairs. The second line of each can be checked by looking at a
diff.

- Weak: "Write good tests."
  Strong: "Add deterministic tests for new behavior and run `make check`."
- Weak: "Respect the architecture."
  Strong: "Strategies emit intents; they do not import broker adapters or
  submit orders."
- Weak: "Update docs when needed."
  Strong: "Update the architecture document when a package boundary changes;
  record durable decisions in an ADR."

The strong versions come from the [Trader repository's agent-instructions
pull request](https://github.com/rustyeddy/trader/pull/9), which is still a
work in progress. Treat those examples as the shape of a rule, not as current
Trader policy.

### Tie each rule to a real failure

This site's `AGENTS.md` has seven short rules. The one that shows the pattern
best is rule 6:

> Always double-quote `title:` and `summary:` values in front matter
> (e.g. `title: "Money in Go: Fixed-Point Types"`). An unquoted colon is
> invalid YAML and breaks the Hugo build, even in a draft.
> `scripts/check-metadata` (run by `make check-site`) catches this.

Three things make it a good rule. It states the behavior (quote the value).
It says why (a real build break). And it names the check that enforces it,
so an agent that ignores the rule gets caught by `make check-site` instead
of by a reader. A rule with no reason invites an agent to decide it doesn't
apply; a rule with no enforcement depends on every agent remembering it.

Rule 4 works the same way: "Never push to `master`: it auto-deploys. Work on
a branch and open a pull request for review." The reason is in the sentence.

## One source of truth, thin adapters per tool

Each tool has its own entry point, so the temptation is to write three
versions of the project rules. Don't. Duplicates drift, and when they
disagree nobody knows which one the agent followed.

Put shared policy in a root `AGENTS.md`. Keep each tool-specific file to what
that tool needs: its imports, its commands, its workflow.

### What the tools read

As of 2026-11-20, from each vendor's documentation. Tools change quickly,
so check the linked page before you rely on a row.

| Tool | Reads | Notes |
| --- | --- | --- |
| Claude Code | `CLAUDE.md`, `.claude/CLAUDE.md`, `CLAUDE.local.md`; `AGENTS.md` when no `CLAUDE.md` exists | Files above the working directory load at launch; subdirectory files load on demand. `@path` imports, up to four hops deep. |
| Codex | `AGENTS.md` (or `AGENTS.override.md`), one file per directory, from the project root down | Global file in the Codex home loads first. Closer files appear later and override earlier guidance. 32 KiB default cap. |
| GitHub Copilot | `.github/copilot-instructions.md`; path-specific `.github/instructions/*.instructions.md`; agent files (`AGENTS.md`, and a root `CLAUDE.md` or `GEMINI.md`) on some surfaces | Varies by surface; see the support matrix below. Path-specific files need an `applyTo` glob. The nearest `AGENTS.md` takes precedence. |

Sources: [Claude Code memory](https://code.claude.com/docs/en/memory),
[Codex AGENTS.md](https://developers.openai.com/codex/guides/agents-md),
[Copilot repository instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions),
and the [AGENTS.md convention](https://agents.md).

Two details matter in practice.

**Claude Code and `AGENTS.md`.** Older guides say Claude Code ignores
`AGENTS.md`. The current memory documentation says it reads `AGENTS.md`
directly when there is no `CLAUDE.md` or `CLAUDE.local.md` in the working
directory or above it, in version 2.1.277 or later. When you do keep a
`CLAUDE.md`, the documentation recommends importing the shared file with an
`@AGENTS.md` line, or symlinking one file to the other. Prefer the import
when you also have Claude-specific content or when anyone works on Windows:
the documentation notes that Claude's edit tools refuse to write through a
symlink, that creating one on Windows needs Administrator privileges or
Developer Mode, and that Git checks a committed symlink out as plain text
unless `core.symlinks` is enabled.

**Having both files changes the default.** With an `AGENTS.md` and a
`CLAUDE.md` in the working directory or above it, the default behavior is
that Claude reads "Your `CLAUDE.md` files only". A **Project instructions**
setting in `/config` can change that, for example to load both files, but a
teammate's settings aren't something the repo controls. So the portable
approach is the import: once you add a `CLAUDE.md`, even for one
Claude-specific rule, have it import `AGENTS.md`. This site missed that, as
described below.

**Copilot's surfaces differ.** GitHub's
[support matrix](https://docs.github.com/en/copilot/reference/custom-instructions-support)
lists different files per surface. As of the same date, it lists
`.github/copilot-instructions.md` everywhere but none of the agent files for
GitHub.com Copilot Chat; `AGENTS.md` but not `CLAUDE.md` for VS Code Chat; and
`AGENTS.md`, `CLAUDE.md` and `GEMINI.md` for the GitHub.com cloud agent and
code review. Check the surface your team actually uses.

A minimal Claude adapter, when you have a few Claude-only rules, looks like
this:

```markdown
@AGENTS.md

## Claude Code
- Use plan mode for changes that touch more than one package.
```

### What this repo does, and the bug it had

`AGENTS.md` is the shared entry point and points to `POSITIONING.md`,
`EDITORIAL.md` and `STYLEGUIDE.md`. `CLAUDE.md` holds the repo mechanics
(build, layout, drafts, front matter), and `AGENTS.md` item 3 says those
"apply to every agent, not only Claude." There is no Copilot-specific file.

That was the design. It didn't work as designed for Claude Code, because
`CLAUDE.md` never imported `AGENTS.md`. With both files present and default
settings, Claude reads only `CLAUDE.md`, so a default Claude session here
didn't load the seven `AGENTS.md` rules, including "never push to `master`"
and "quote `title:`".
Review of the pull request for this page caught it. The fix was one line,
`@AGENTS.md`, at the top of `CLAUDE.md`
([pull request 215](https://github.com/rustyeddy/rustyeddy.com/pull/215)).

The general lesson: the structure of your files says nothing about what each
tool loads. Add a tool-specific file only when the tool needs different
discovery, scoping or workflow instructions, and when you do, check that it
connects to the shared one.

## Running several agents on one repository

This is where a shared instruction set earns its keep. Several agents with
different habits will touch the same files, and the instructions are the
only thing they have in common.

![Instruction layers: POSITIONING.md overrides the shared AGENTS.md, which is imported or referenced by tool-specific adapters such as CLAUDE.md and a Copilot file, which are applied to the issue or task at hand.](/diagrams/agent-instruction-layers.svg)

**Settle precedence in writing.** The tools merge files by distance from the
working directory, not by importance. Claude Code concatenates every file it
finds rather than overriding, and its documentation warns that when
instructions conflict, Claude may pick one arbitrarily. So write the order
down. Here it is `POSITIONING.md`, then `AGENTS.md`, then `CLAUDE.md`:
`CLAUDE.md` says `POSITIONING.md` "overrides anything here," and `AGENTS.md`
item 1 requires reading it before touching content. That is the order for
repository files. Two other inputs sit outside it. An issue or task
description is below all the repository files: if an issue asks for
something a shared rule forbids, the agent should stop and say so, which is a
team policy, not something the tools enforce. A direct instruction from the
person at the keyboard is different. The `AGENTS.md` convention says explicit
chat prompts override everything, so a person can knowingly override a rule
in a session. Decide which of those you want, and write it down.

**Copilot may read both files.** GitHub lists both `AGENTS.md` and a root
`CLAUDE.md` for the cloud agent and code review. Listing both doesn't say
they load together, or which wins if they conflict, and other surfaces list
fewer files. In a repo like this one, assume a Copilot surface might see
`CLAUDE.md`, `AGENTS.md` or both. That is one more reason to keep
tool-specific content out of a root `CLAUDE.md` and let it carry shared
policy only through the import.

**One writer per branch.** Two agents editing the same branch produce
conflicts and, worse, silent overwrites. Give each task its own branch and one
agent.

**Review with a different mind.** The author shouldn't be the only reviewer.
Use a different model, or a fresh agent session with no memory of the work,
and give it the same instruction files. On [pull request 207](https://github.com/rustyeddy/rustyeddy.com/pull/207),
Codex drafted the change and a separate agent reviewed it. The PR description
records the review's finding that the diagram was too wide for narrow screens;
the fix went into the diagram source and was rechecked.

**Say what you couldn't do.** The same pull request shows a rule worth
writing down. Codex couldn't reach the content tracker, so the PR said so
under "Before marking ready" instead of guessing at the tracker's contents.
An instruction like "if a required source is unavailable, say so in the PR
and don't infer it" costs one line and prevents invented facts.

**The human keeps merge authority, and nobody pushes to the deploy branch.**
This repo deploys on every push to `master`. `AGENTS.md` rule 4 keeps agents
on branches, and the pull request is where a person decides. A gate only
helps on branches that run it: in [the incident described in the release
process article](/software/release-process/#a-gate-only-protects-branches-that-run-it),
a pull request branched before the checks existed merged without them, and
the deploy failed on the check it had skipped.

## Layered project knowledge and precedence

Not everything belongs in the root file. Use layers, each with one job:

| Layer | Holds |
| --- | --- |
| Root `AGENTS.md` | Universal rules for the repository |
| Architecture documents and ADRs | System decisions and dependency direction |
| Contribution guide | Workflow and definition of done |
| Path-specific instructions | Rules for one language, package or subsystem |
| Skills or workflow documents | Repeatable procedures too long for the root file |
| Issue or task | Outcome, scope, non-goals, acceptance criteria |

Local files may specialize a root rule but shouldn't silently contradict a
safety or architectural constraint. The `AGENTS.md` convention says "the
closest `AGENTS.md` to the edited file wins; explicit user chat prompts
override everything," so decide deliberately which rules a nested file is
allowed to change. In a monorepo, a package-level file can add its test
command. It shouldn't turn off the root rule against importing across
boundaries.

## Test instructions like an interface

Before merging an instruction change:

1. **Open every linked file from a fresh checkout.** A path that exists on
   your machine but not in the repository is a broken dependency.
2. **Run every command exactly as written.** Confirm it checks what the prose
   says it checks.
3. **Ask each agent you use to summarize the rules back.** Differences show
   you where the wording is ambiguous or where a tool isn't loading a file.
4. **Give each agent one small, representative task.** Compare its plan with
   the architecture and the acceptance criteria before it writes code.
5. **Review the resulting diff** for scope, tests, documentation and safety.

Step 3 would have caught the bug above. Ask a Claude Code session on this
repo to list the rules, and it would likely not have mentioned the push or
front-matter rules, which live in `AGENTS.md`. The fix and the test are
cheap; skipping the test is what let it sit.

The Trader pull request shows why step 1 matters. In that draft, the
instructions pointed to `CONTRIBUTING.org`, `docs/arch/package-boundaries.org` and detailed workflow
files before those files existed, and said workflows were updated without
adding one. Copilot's review caught the broken references. These look like
documentation defects. To an agent they are missing dependencies.

Commands need the same care. Describe the command that exists, and change
the Makefile and the prose together when the gate changes.

For this site the single gate is `make check-site`: a production Hugo build,
link checks, front-matter checks, content-tone checks and a marker scan. It
runs locally and in CI (`.github/workflows/hugo.yml` runs the same
`./scripts/check-site`), so an agent that passes it locally gets the same
answer from CI. Make one gate, and say so in the instructions.

## Own the files and evolve them from review evidence

Instruction files change what automated contributors do, so treat them like
build and CI configuration. Assign an owner. Require review. Re-read them when
commands, package boundaries or the definition of done change.

Add a rule when the same correction shows up in review more than once. This
site's positioning document is an example. Agents kept reframing pages the
wrong way, so [pull request 212](https://github.com/rustyeddy/rustyeddy.com/pull/212)
added a rule for reference how-tos: keep the full practitioner depth and add a
short "For leads" summary, instead of writing a shortened copy for managers.
The rule exists because of review feedback, not because it sounded sensible.

Remove a rule when automation makes it redundant. If a linter now catches it,
the sentence only costs context. Keep task-specific lessons in the issue or
pull request unless they generalize.

## Common failure modes

The general advice (be specific, stay short, keep one canonical file) is
covered well elsewhere. These are the failures I'd check for first:

- **Broken links and aspirational commands.** The instructions describe the
  repository you wish you had.
- **Stale instructions.** They describe the intended structure after a
  refactor, not the one an agent actually receives.
- **Duplicated policy in three files.** They contradict each other within a
  quarter.
- **Rules without a reason, a scope or a check.** Agents rationalize past
  them.
- **Requirements to read the whole documentation tree.** The task loses the
  context fight.
- **Permission to make architectural decisions to finish an issue.** An agent
  with a goal and no stop condition will choose a design.

## A starting template

```markdown
# AGENTS.md

## Project
Purpose, maturity, and non-goals.

## Read before changing code
Only documents that exist, in order, each with a reason.

## Invariants
Architectural and safety decisions the agent must preserve.

## Workflow
Branch and pull-request rules, definition of done, and when to stop and ask.

## Verification
Exact commands, and what each one proves.
```

Add a tool-specific adapter only when that tool needs something different.

## Closing checklist

- One canonical file holds the shared policy.
- Every referenced path exists in a fresh checkout.
- Every command runs and checks what the text says.
- Architecture, safety and non-goals are explicit, and settled decisions are
  separate from open questions.
- Each tool receives the same project rules without copied policy.
- Local overrides are narrow, and precedence is written down.
- An owner reviews instruction changes like CI changes.
- The file is shorter than the documentation it points to.
- A new engineer would find it accurate and useful too.

The repository examples above reflect
[this repository at a pinned commit](https://github.com/rustyeddy/rustyeddy.com/tree/fa95b8235afaac2ae27466aa014651fdd1d87e55).
