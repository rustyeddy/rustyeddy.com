---
title: Software Development
description: >
  Practical engineering practices for building software predictably —
  from capturing requirements through shipping and iterating.
tags: [ sdlc, software development ]
date: 2026-05-22
---

Software projects have a well-earned reputation for running late, costing
more than expected, and delivering the wrong thing. The root cause is almost
always the same: a breakdown in communication between the people who need
the software and the people building it.

The practices in this section exist to prevent that breakdown. They are not
bureaucratic overhead — each one is a communication tool that creates shared
understanding, makes progress visible, and catches divergence before it
becomes expensive to fix. Applied together, they make a software project
_predictable_.

The work falls into three phases that repeat iteratively throughout a
project's life.

## Design

Before writing code, establish what the software needs to do and why.

- [Software is Hard](/software/software-is-hard/) — why software projects
  go wrong and what separates the ones that don't
- [Use Cases](/software/use-cases/) — capturing requirements through
  customer discovery and user stories
- [Use Cases to Tasks](/software/use-cases-to-tasks/) — slicing use cases
  into testable requirements and Kanban backlog items
- [Wireframes and Storyboards](/software/wireframes-and-storyboards/) —
  visualizing the user experience before any code is written
- [Style Guide](/software/style-guide/) — defining reusable visual and
  interaction rules before implementation

## Development

Build incrementally, with visibility and quality checks at every step.

- [Version Control Systems](/software/version-control-systems/) — git,
  branching, and the commit history as the project's source of truth
- [Kanban](/software/kanban/) — keeping work visible and tasks small
- [Test Driven Development](/software/test-driven-software-development/) —
  writing tests first to force clear requirements and build confidence
- [Peer Review](/software/peer-review/) — catching bugs before users do
  and spreading knowledge across the team

## Delivery

Ship working software to users, get feedback, and iterate.

- [Release Process](/software/release-process/) — versioning, CI/CD
  pipelines, deployment strategies, and rollback
