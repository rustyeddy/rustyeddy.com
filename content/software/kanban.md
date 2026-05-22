---
title: Organizing Software Projects with Kanban
description: >
  How Kanban boards make work visible, keep tasks small, and give everyone
  on the project — developers, managers, and customers — a shared view of
  progress without meetings or status reports.
weight: 30
date: 2026-05-22
---

Kanban is a visual task management system built around one principle: make
the work visible. When every task has a card and every card has a status,
anyone who looks at the board knows exactly where the project stands.

The mechanics are intentionally minimal. A board has three columns — _Todo_,
_In Progress_, and _Done_. Cards representing tasks move left to right as
work advances. That is the entire system. Its power comes from discipline in
how tasks are written and how the board is maintained, not from the tool
itself.

## Task Sizing

The most important practice in Kanban is keeping tasks small. A task should
be completable by one person in one to two days. If a task is running to
three or four days it almost certainly can — and should — be broken into
smaller pieces.

Small tasks matter for several reasons. They keep the board accurate: a
two-day task that slips is visible immediately, whereas a two-week task can
look fine right up until the deadline. They let the team stack small
victories, which matters for morale over the course of a long project.
And they force a level of specificity that surfaces hidden complexity early,
when it is still cheap to address.

Tasks that arrive from [use cases](/software/use-cases-to-tasks/) are often
too coarse at first. Breaking them down is part of the work, not a sign
something was planned badly.

## WIP Limits

_Work In Progress_ (WIP) limits constrain how many tasks a person can have
in the _In Progress_ column at once — typically one, occasionally two.

The instinct to start multiple things simultaneously is counterproductive.
Partially completed work delivers no value. Context switching has a real
cost. And a board full of in-progress cards obscures whether the project is
actually moving.

A strict WIP limit forces a simple discipline: finish what you started
before picking up something new. Teams that apply it consistently find that
throughput goes up, not down.

## The Backlog Evolves

The task list at the start of a project is an estimate, not a contract.
Unforeseen complexity will surface during development. Requirements will
clarify as users see working software. New tasks will be added; original
tasks will be split or reprioritized.

> You cannot know what you do not yet know.

Embrace this rather than resist it. The board is a live document. The
discipline is in keeping it current — adding new cards as work surfaces,
updating estimates, and not letting stale tasks linger in _In Progress_ past
their actual state.

## Exit Criteria

Every task card should include a clear definition of done: what test must
pass, what behavior must be demonstrated, what acceptance criterion must be
met before the card moves to _Done_.

This is the connection between Kanban and [test-driven
development](/software/test-driven-software-development/). Writing the exit
criterion when the card is created forces the developer to understand
precisely what is being built before starting, and gives the reviewer
something concrete to verify.

## Tool Options

Any tool that shows cards moving through columns works. The right choice
depends on team size, existing tooling, and how tightly you want the board
integrated with code changes.

**GitHub Projects** — integrated directly with the repository. Cards link to
issues and pull requests; closing a PR can automatically move a card to
_Done_. Good default choice for teams already on GitHub.

**GitLab Boards** — equivalent to GitHub Projects for teams on GitLab, with
similar issue integration.

**Linear** — purpose-built issue tracker with strong keyboard navigation and
good GitHub/GitLab integration. Popular with engineering-focused teams.

**Trello** — flexible and simple, works well for teams with mixed technical
and non-technical members. No native code integration.

**Jira** — feature-rich and widely used in larger organizations. Can become
process overhead for small teams; use it if the organization already has it,
not as a first choice for a small project.

The tool matters less than the discipline. A well-maintained board in any of
these is more useful than a poorly maintained one in the theoretically
perfect tool.
