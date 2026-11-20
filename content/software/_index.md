---
title: "Software Delivery for Small Teams: Using AI with Guardrails"
description: "Practical software delivery for small teams using AI: define the work, keep changes reviewable, test behavior, and release with a clear recovery plan."
tags: [sdlc, software development]
date: 2026-05-22
lastmod: 2026-11-20
show_articles: false
image: "/img/small-teams.jpeg"
image_alt: "Illustrated software delivery path for a small team using AI, with review gates, behavior tests, and a recovery plan."
---

Writing code is one part of delivering software. Someone still has to
decide what users need, protect the system's boundaries, verify
behavior, and deal with what happens after release. AI can help
with the work; but the team still owns the outcome.

This section is for engineering managers, tech leads, and technical founders
who need a software delivery process their small team can actually use.
Start with the decision that is holding up your work, or follow the reading
path from user goals through release.

## Why this matters

A feature can be implemented and still be hard to ship: the acceptance
criteria are vague, the change is too large to review, or nobody knows how
to recover from a failed deployment. More code doesn't resolve those gaps.

Keep each change small enough to carry through the whole loop. Tests and
review feed corrections back into implementation; production behavior and
user feedback inform the next piece of work.

![Delivery loop: define a user goal and acceptance criteria, implement and test a small change, review it independently, then release and observe. Review can return the change for correction; production and user feedback inform the next goal.](/diagrams/software-delivery-loop.svg)

## Where AI helps, and where it needs gates

AI can speed up several stages of the loop. It can draft acceptance
criteria from a user goal, implement a bounded task, and write tests for
behavior you have already described. Each of those outputs still needs a
person to check it against what the team actually intends.

Give an agent a bounded task, acceptance criteria, and a way to run the
project's checks. Have someone other than the author review the resulting
change. Keep a person accountable for the merge and release decision.

The [release gates for AI-written code](/software/release-process/#release-gates-when-ai-writes-the-code)
show how this works: run the same checks locally and in CI, review the exact
commit being merged, and keep changes small enough to inspect. A passing
suite is evidence about tested behavior; it doesn't decide whether you built
the right thing. For a worked example of giving an AI tool a defined,
testable interface, see
[Build an MCP Server in Go](/notes/mcp-claude-tools/).

Most of the articles below predate this AI guidance and describe the
practices themselves, not how to apply them with an agent.

## Choose a starting point

### Agree on the work

- [Software is Hard](/software/software-is-hard/) explains how projects drift
  and where feedback helps. Start here if the team is busy but delivery is
  unpredictable.
- [Use Cases](/software/use-cases/) captures user goals before the team
  commits to a design.
- [Wireframes and Storyboards](/software/wireframes-and-storyboards/) makes
  user flows and failure states visible before implementation.

### Make changes small and verifiable

- [Use Cases to Tasks](/software/use-cases-to-tasks/) turns a user goal into
  acceptance tests and focused implementation work.
- [Organizing Software Projects with Kanban](/software/kanban/) helps you
  limit work in progress and expose stalled tasks.
- [Test Driven Software Development](/software/test-driven-software-development/)
  connects expected behavior to repeatable checks.

### Review, release, and recover

- [Peer Reviews](/software/peer-review/) defines what authors should provide
  and what reviewers should inspect before a change merges.
- [Version Control Systems](/software/version-control-systems/) covers the
  commits, branches, and tags that make changes traceable.
- [Software Release Process](/software/release-process/) connects automated
  checks, independent review, versioned artifacts, smoke tests, and rollback.
  Start here if finished code keeps getting stuck before production.

## Architecture behind the workflow

Delivery also depends on design choices that make behavior easier to test
and changes easier to contain. These articles use
[Trader](/projects/trader/) as an engineering case study:

- [Money in Go: Fixed-Point Types for Financial Software](/software/numeric-types-financial-software/)
  examines numeric types, rounding, and validation at system boundaries.
- [The Strategy Pattern in a Backtesting Engine](/software/strategy-pattern-backtesting/)
  examines interfaces that separate strategy decisions from execution and
  make strategies testable in isolation.

For device, edge, and backend boundaries, continue with
[IoT systems architecture](/iot/). For smaller experiments and implementation
references, browse the [engineering notes](/notes/).
