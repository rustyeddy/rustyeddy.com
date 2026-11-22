---
title: "Organizing Tasks with Kanban When AI Agents Do Some of the Work"
description: "How to run a Kanban board where developers and AI coding agents share the work: cards an agent can execute, checkable exit criteria, and a review gate."
weight: 30
date: 2026-05-22
lastmod: 2026-11-22
tags: ["Kanban", "AI Agents", "Project Management", "Software Engineering", "Code Review"]
categories: ["Software Engineering"]
summary: "Kanban for mixed teams of developers and AI coding agents: cards written so an agent can execute them, exit criteria that can be checked, WIP limits on review, and a human gate before Done."
---

## For leads

If some of your team's work is done by AI coding agents, the board is where
you keep control of it. Four requirements cover most of the risk:

1. **Every card passes the "could an agent do this?" test.** If an agent
   couldn't start from the card alone, a new developer couldn't either. Vague
   cards turn into confident wrong work.
2. **Exit criteria are written as checks.** Tests or commands that can be run,
   plus the few things only a person can judge, all stated before work starts.
3. **Limit review, not only work in progress.** Agents can start many cards at
   once. The real limit is how many changes your people can review well.
4. **A person approves before Done.** Nothing an agent produces reaches the
   main branch without independent review and a named human making the call.

The rest of this page is the practitioner version, for whoever runs the board.

## Where this fits

[Use Cases to Tasks](/software/use-cases-to-tasks/) ends with a pile of task
cards: each one tied to a user goal, with acceptance criteria and a size small
enough to finish. This page is about running those cards: who picks them up,
how they move, and what has to be true before one is finished.

The mechanics stay simple. Cards move left to right through a few columns.
What changes when agents join the team is how much each card has to carry,
and where the bottleneck sits.

## Why the board matters more with agents

Software work gets hard to manage when it's invisible. A developer can be
busy for days on a vague task while nobody can tell whether the project is
moving, blocked, or drifting away from what the user needed.

Agents make that problem faster. They start immediately, they don't ask
clarifying questions unless told to, and they produce plausible-looking
changes whether or not the task was well defined. A hidden queue of agent work
fills up in hours, not weeks.

A board turns that work into explicit cards, so anyone looking at it can see:

- What's waiting, and whether it's ready to start.
- What's running, and who or what is running it.
- What's waiting for review.
- What's blocked, and on what.
- What's finished.

The board isn't a status report. It's the team's shared view of the work, and
on a mixed team it's the one place where human and agent work show up side by
side.

## A board for a mixed team

Three columns (`Todo`, `In Progress`, `Done`) are enough for one developer.
A team where agents do some of the work needs two more:

![Kanban board for a mixed team: Backlog, Ready, In Progress, Review and Done. Ready holds cards that pass the agent-readiness test. Review has a work-in-progress limit set by reviewer capacity. A person approves each card into Done.](/diagrams/kanban-mixed-team.svg)

- **Backlog**: cards that exist but aren't ready to start.
- **Ready**: cards that pass the readiness test below. Only these can be picked
  up, by a person or an agent.
- **In Progress**: work being done, with one owner per card.
- **Review**: finished work waiting for independent review. This column gets
  its own limit.
- **Done**: reviewed, approved, and merged.

`Ready` is what keeps agents from starting on half-written cards. `Review`
makes the real bottleneck visible instead of hiding it inside `In Progress`.

## Cards an agent can execute

Cards should come from real user value. A use case describes a user goal; a
card describes a small piece of work that moves it forward. If a card is just
a copied use case, it's too large.

A vague card hides risk:

```text
Build watering dashboard
```

That card could mean layout, API integration, charts, manual controls,
thresholds, error states, and tests. A developer would ask questions. An agent
will pick an interpretation and build it.

A better card is smaller and testable:

```text
Show current soil moisture for one watering zone

Given a zone has a latest soil moisture reading,
when the dashboard loads,
then it displays the zone name, moisture value, unit, and reading time.
```

That's enough for a person who knows the codebase. For an agent, the card
also needs the context a teammate would pick up in conversation: where the
code lives, what it may and may not touch, and how to check its own work.

Here's a card from the self-watering garden project, written to be picked up
by either:

```text
Stop pump when soil reaches damp threshold

Context:
The gateway receives soil moisture readings from a collection station
and knows whether the pump is currently running.

Acceptance criteria:
- Given the pump is running
- And the latest moisture reading is at or above the damp threshold
- When the reading is processed
- Then the gateway publishes a stop command to the control station
- And records the pump state change

Scope:
- Change the threshold decision and its tests only
- Don't change the MQTT topic layout or the control station firmware

Checks (run before moving to Review):
- Unit tests for the threshold decision pass
- Integration test for the reading-to-command path passes

Needs a person:
- Manual test with a simulated MQTT reading on the bench rig
```

The test for every card: **could someone who has never seen this project start
from the card plus the repository's instructions?** If not, it isn't ready.
Rules that apply to every card, such as how to build, how to run the checks,
and which branches are off limits, belong in the repository's instruction
file, not repeated on each card. See
[AGENTS.md and CLAUDE.md for Teams](/software/writing-agent-instructions/) for
that layer.

## Task sizing

A card should usually be small enough for one person to finish in a day or
two. For agent work there's a second limit: **the result has to fit in one
reviewable change.** An agent can produce a thousand-line change in minutes.
Reviewing it well takes hours, and reviewing it badly is how defects reach
production.

Small cards still matter for the old reasons:

- Progress stays visible.
- Blockers surface quickly.
- Review stays thorough.
- Merge conflicts stay rare.
- Test boundaries stay clear.
- Users see working increments sooner.

Splitting a card isn't a sign that planning failed. It's part of turning an
idea into work that can be delivered and checked.

## Exit criteria that can be checked

Every card needs a definition of done: what must be true before it moves on.
On a mixed team, split that definition in two.

**Checks anyone can run.** Unit tests, integration tests, a build, a linter, a
link checker. Write them as commands or named tests, so an agent can run them
and report the results before it asks for review. "Tests pass" is not a check;
"`go test ./...` passes", or a named test suite, is.

**Judgments only a person can make.** A manual hardware test, whether the
change matches what the user actually needed, whether the design fits the
system. Name these explicitly so nobody assumes the automated checks covered
them.

Writing exit criteria when the card is created forces the team to define
observable behavior before anyone starts, which is the bridge to
[Test Driven Software Development](/software/test-driven-software-development/).
With agents it also stops a common failure: an agent declaring a card finished
because the code compiles.

## WIP limits, including review

Work-in-progress limits cap how many cards can sit in `In Progress` at once.
For one developer the limit is usually one or two. Half-finished work doesn't
help users, context switching is expensive, and a board full of active cards
makes it hard to tell what's moving.

Agents break the usual intuition. Starting work costs them almost nothing, so
a team can have ten agent cards in progress by lunchtime. That looks like
throughput. It's really a queue, because every one of those changes has to be
reviewed by a person before it's worth anything.

So put a limit on `Review` and size it to reviewer capacity: roughly how many
changes your reviewers can examine carefully in a day. When `Review` is full,
nobody starts new agent work. Finishing reviews, or splitting oversized
changes, comes first.

This is the shift Kanban was built to handle: find the constraint and manage
the flow through it. With agents on the team, the constraint has moved from
writing code to checking it.

## A review gate before Done

The `Review` column is only useful if the gate behind it is real:

- **Independent review.** The reviewer isn't the author. For agent work that
  can be a person, or a different model or a fresh agent without the
  drafter's context, but the author never certifies its own work.
- **A named person approves.** Agents can draft and review. A person decides
  what merges.
- **Nothing bypasses the gate.** Automated checks only protect changes that go
  through them.

The board running this website's
[content overhaul](https://github.com/rustyeddy/rustyeddy.com/blob/master/knowledge/content-process.md) has
examples of the gate working and of what happens without it. During a rewrite
of the agent-instructions page, review caught that the repository's
`CLAUDE.md` didn't import its `AGENTS.md`, so Claude sessions had never loaded
the shared rules. The fix shipped as its own small change
([#215](https://github.com/rustyeddy/rustyeddy.com/pull/215)). A few days later
a change was pushed straight to the main branch, skipping review. It broke the
deploy build, and the fix went through a pull request anyway
([#217](https://github.com/rustyeddy/rustyeddy.com/pull/217)).

## One card, one branch, one writer

When two people edit the same branch, they coordinate in conversation. Two
agents don't. Give each card its own branch and exactly one writer, whether
that's a person or an agent, and keep it that way until the card leaves
`Review`.

If a second agent needs to help, make it a new card with its own branch, or
have it review instead of write. Some agent tools enforce this by giving every
card its own git worktree. The rule matters more than the tool.

## A live example: this site's overhaul

This website is being rewritten page by page on exactly this kind of board:

- **The board** is a tracker spreadsheet whose Status column runs
  `To do → In progress → In PR → Done`, with `Done - recheck` for pages that
  something outside the page can make stale.
- **Each card** is a GitHub issue, one per page, with a checklist as its exit
  criteria and a written brief for larger rewrites.
- **Agents draft** on a branch, **a different agent or model reviews** the pull
  request, and **a person merges**. Nothing auto-merges.
- **Exit criteria include runnable checks** (the site build, link and metadata
  checks) and **human judgments** (whether a page still fits the site's
  positioning).

The board was useful beyond tracking. When a page didn't justify a full
rewrite, that decision went on its card, so nobody picked it up again later.

## The backlog evolves

The backlog is an estimate, not a contract. Requirements clarify as users see
working software, and hidden complexity appears during implementation. Cards
get split, rewritten, added, removed, and reprioritized. That's normal.

A stale board is worse than no board, because it gives false confidence. Keep
cards current, move blocked work visibly, and delete cards that no longer
represent real work. On a mixed team, also re-check `Ready` cards before an
agent picks one up. A card written last month may point at code that has
since moved.

## Tool options

Any tool that shows cards moving through columns can work. Pick by team size,
existing tooling, and how tightly the board should connect to code changes.

- **GitHub Projects**: a good default for teams already on GitHub. Issues,
  pull requests and the board live in one place.
- **GitLab Boards**: the same idea for GitLab repositories.
- **Linear**: fast issue tracking for engineering-focused teams.
- **Trello**: simple and flexible for mixed technical and non-technical teams.
- **Jira**: powerful in larger organizations, often heavy for small teams.

A newer group of tools treats agents as the main workers. As of November
2026, [Cline Kanban](https://docs.cline.bot/kanban/overview) is a research
preview that gives each card its own git worktree and terminal so several
agents can run in parallel, and
[Kagan](https://github.com/kagan-sh/kagan) is a supervised board where
nothing an agent produces reaches `Done` until a person reviews it and decides
whether to merge. These tools
change quickly; judge them by whether they support a `Ready` state, a limited
`Review` column, and a human approval step.

The tool matters less than the discipline. A maintained board in a simple tool
beats an abandoned board in a powerful one.

## Common pitfalls

### Cards that are too large

Large cards hide risk and delay feedback, and for an agent they produce
changes too big to review well. Split them until each one has a clear outcome.

### No exit criteria, or exit criteria nobody can run

A card without exit criteria invites disagreement about whether it's done.
A card whose exit criteria are only prose invites an agent to declare victory
early. Write the checks down as commands.

### A WIP limit on work but none on review

The board looks productive while unreviewed changes pile up. Limit `Review`
and stop starting new work when it's full.

### Cards written only for people

Cards that rely on hallway context work for the developer who wrote them and
fail for everyone else, agents included. Apply the readiness test.

### Treating the board as reporting theater

A board should reflect reality. If cards only move before a meeting, the board
isn't helping the project.

## Where this fits

Kanban sits between planning and implementation:

- [Use Cases](/software/use-cases/) define user goals.
- [Use Cases to Tasks](/software/use-cases-to-tasks/) turns those goals into
  requirements, acceptance tests, and cards.
- [Test Driven Software Development](/software/test-driven-software-development/)
  turns card exit criteria into repeatable checks. That's the next step.
- [Peer Reviews](/software/peer-review/) covers the review that happens before
  a card reaches `Done`.
- [AGENTS.md and CLAUDE.md for Teams](/software/writing-agent-instructions/)
  covers the repository rules every agent follows, whichever card it picks up.
