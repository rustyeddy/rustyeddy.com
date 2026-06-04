---
title: "Organizing Software Projects with Kanban"
description: >
  How Kanban boards make work visible, keep tasks small, and give developers,
  managers, and customers a shared view of project progress.
weight: 30
date: 2026-05-22
tags: ["Kanban", "Project Management", "Software Engineering", "Tasks"]
categories: ["Software Engineering"]
summary: "A practical guide to using Kanban cards, WIP limits, task sizing, and exit criteria to keep software projects visible and predictable."
---

Kanban is a visual task management system built around one principle: make
the work visible. After [use cases become task cards](/software/use-cases-to-tasks/),
the board is where the team tracks those cards through implementation. When
every task has a card and every card has a status, anyone looking at the board
can see where the project stands.

The mechanics are intentionally small. A basic board has three columns:
`Todo`, `In Progress`, and `Done`. Cards move left to right as work advances.
The value comes from how clearly the cards are written and how honestly the
board reflects reality.

## Why This Matters

Software work becomes hard to manage when it is invisible. A developer may
be busy for days, but if the work is hidden inside a vague task, nobody can
see whether the project is moving, blocked, or drifting away from the user
need.

Kanban turns hidden work into explicit cards. It helps the team see:

- What work is waiting.
- What work is active.
- What is blocked.
- What is finished.
- Which tasks are too large or too vague.

A useful board is not a status-reporting tool. It is a shared operating view
of the project.

## From Use Cases to Cards

Kanban cards should come from real user value. A use case explains what the
user needs. A card describes a small piece of implementation work that moves
that use case forward.

This translation is covered in [Use Cases to Tasks](/software/use-cases-to-tasks/).
The important distinction is simple:

- A use case describes a user goal.
- A card describes a small piece of work a developer can finish.

If a card is just a copied use case, it is probably too large.

## Bad Task vs. Good Task

A vague card hides risk:

```text
Build watering dashboard
```

That card is too large. It could include layout, API integration, charts,
manual controls, thresholds, error states, and tests.

A better card is smaller and testable:

```text
Show current soil moisture for one watering zone

Given a zone has a latest soil moisture reading,
when the dashboard loads,
then it displays the zone name, moisture value, unit, and reading time.
```

The better card has a clear boundary and a clear exit condition. It can be
implemented, reviewed, and tested without pretending the whole dashboard is
finished.

## Example Card from the Garden Project

For the self-watering garden, a useful Kanban card might be:

```text
Stop pump when soil reaches damp threshold

Context:
The gateway receives soil moisture readings from a collection station and
knows whether the pump is currently running.

Acceptance criteria:
- Given the pump is running
- And the latest moisture reading is at or above the damp threshold
- When the reading is processed
- Then the gateway publishes a stop command to the control station
- And records the pump state change

Verification:
- Unit test threshold decision logic
- Integration test reading-to-command path
- Manual test with a simulated MQTT reading
```

That card connects user value, implementation scope, and test expectations.
It also gives a reviewer something concrete to verify.

## Task Sizing

A Kanban task should usually be small enough for one person to finish in one
or two days. If a task takes longer, it may need to be split.

Small tasks matter because they:

- Keep progress visible.
- Surface blockers quickly.
- Make review easier.
- Reduce merge conflicts.
- Create clearer test boundaries.
- Let users see working increments sooner.

Splitting tasks is not a sign that planning failed. It is part of turning an
idea into deliverable work.

## WIP Limits

Work in progress limits constrain how many cards can sit in `In Progress` at
once. For an individual developer, the limit is usually one or two.

This feels restrictive, but it improves flow. Half-finished work does not
help users. Context switching is expensive. A board full of active cards
makes it hard to tell what is actually moving.

A WIP limit creates a simple rule: finish or unblock the current card before
starting another one.

## The Backlog Evolves

The backlog is an estimate, not a contract. As users see working software,
requirements clarify. As developers implement, hidden complexity appears.
Cards will be split, rewritten, added, removed, and reprioritized.

That is normal. The board should reflect what the team knows now.

A stale board is worse than no board because it gives false confidence. Keep
cards current, move blocked work visibly, and delete cards that no longer
represent real work.

## Exit Criteria

Every card needs a definition of done. That definition should describe what
must be true before the card moves to `Done`.

Good exit criteria may include:

- A user-visible behavior works.
- A unit test covers the core logic.
- An integration test covers a boundary.
- A manual hardware check was completed.
- Documentation or examples were updated.
- A reviewer approved the pull request.

This is the connection between Kanban and
[Test Driven Software Development](/software/test-driven-software-development/).
Writing the exit criteria when the card is created forces the team to define
observable behavior before implementation starts.

## Tool Options

Any tool that shows cards moving through columns can work. The right choice
depends on team size, existing tooling, and how tightly the board should
connect to code changes.

- **GitHub Projects**: a good default for teams already using GitHub.
- **GitLab Boards**: similar integration for GitLab repositories.
- **Linear**: fast issue tracking for engineering-focused teams.
- **Trello**: simple and flexible for mixed technical and non-technical teams.
- **Jira**: powerful in larger organizations, but often heavy for small teams.

The tool matters less than the discipline. A maintained board in a simple
tool is better than an abandoned board in a powerful one.

## Common Pitfalls

### Cards That Are Too Large

Large cards hide risk and delay feedback. Split them until each card has a
clear outcome.

### No Exit Criteria

A card without exit criteria invites disagreement about whether it is done.
Define done before starting.

### Too Much Work in Progress

Many active cards can make a team look busy while slowing delivery. Limit
active work and finish smaller pieces.

### Treating the Board as Reporting Theater

A board should reflect reality. If people move cards only before a meeting,
the board is not helping the project.

## Where This Fits

Kanban sits between planning and implementation:

- [Use Cases](/software/use-cases/) define user goals.
- [Use Cases to Tasks](/software/use-cases-to-tasks/) turns those goals into
  requirements, acceptance tests, and cards.
- [Test Driven Software Development](/software/test-driven-software-development/)
  turns card exit criteria into repeatable checks.
- [Peer Reviews](/software/peer-review/) verifies completed cards before they
  merge.
