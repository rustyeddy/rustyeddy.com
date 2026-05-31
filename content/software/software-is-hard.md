---
title: "Software is Hard"
date: 2026-05-22
weight: 10
description: >
  Why software projects become unpredictable when user expectations and
  developer assumptions diverge, and how lightweight engineering practices
  make projects easier to steer.
tags: ["Software Engineering", "Project Management", "Use Cases", "Process"]
categories: ["Software Engineering"]
summary: "A section opener explaining why software projects drift and how use cases, Kanban, testing, review, and release discipline make them predictable."
---

Software is hard because it turns vague human expectations into precise
machine behavior. The difficult part is not only writing code. The difficult
part is keeping users, developers, managers, and reviewers aligned on what
the code is supposed to do.

When that alignment breaks, projects become unpredictable. Users think they
asked for one thing. Developers build something technically reasonable but
not quite what the user meant. Everyone can be acting in good faith, and the
project can still drift.

## Why This Matters

Most software failures start as communication failures.

A user asks for a dashboard, report, workflow, database, mobile app, or
integration. The request sounds clear because the user has a mental picture
of the finished result. The developer hears the same words through a different
lens: data models, APIs, file formats, queues, screens, permissions, and edge
cases.

Both interpretations may be reasonable. That is the problem.

Predictable projects make those assumptions visible early. They turn vague
requests into use cases, use cases into requirements, requirements into
acceptance tests, and implementation work into small reviewed changes that
can be released safely.

## The Database of Shoes Problem

Imagine a user asks for a "database of shoes."

The user may expect a complete application:

- A form for adding shoes.
- Search and filters.
- Photos.
- Categories.
- Reports.
- User accounts.
- Export tools.

A developer may interpret the request literally:

- A schema.
- A table.
- A JSON file.
- A seed dataset.
- A basic API endpoint.

Neither interpretation is absurd. They are just different levels of the same
idea. If the team does not uncover the difference, the project will look busy
while moving away from what the user actually wanted.

## Predictability Comes from Feedback

A predictable project is not one where every detail is known up front. That
is rarely realistic. A predictable project is one where divergence is found
quickly and corrected while it is still cheap.

That requires frequent feedback:

- Users see working software early.
- Developers show small increments instead of hiding large batches of work.
- Requirements are written in observable language.
- Tests describe expected behavior.
- Reviewers inspect changes before they become permanent.
- Releases are small enough to verify and roll back.

The longer the gap between assumption and feedback, the more expensive the
correction becomes.

## Just Enough Process

Software does not need heavyweight ceremony to become predictable. It needs
just enough process to keep everyone looking at the same target.

The useful practices are communication tools:

- [Use Cases](/software/use-cases/) capture what users need in plain language.
- [Use Cases to Tasks](/software/use-cases-to-tasks/) turns user value into
  requirements, acceptance tests, and implementation cards.
- [Kanban](/software/kanban/) makes work visible and limits hidden queues.
- [Test Driven Software Development](/software/test-driven-software-development/)
  makes expected behavior repeatable.
- [Peer Reviews](/software/peer-review/) catches mistakes and spreads context.
- [Release Process](/software/release-process/) turns finished work into
  versioned, verified user value.

None of these practices exists to satisfy a process checklist. They exist to
reduce surprise.

## Warning Signs

A project is becoming unpredictable when:

- Users cannot see working software for long stretches of time.
- Developers are building from assumptions instead of confirmed use cases.
- Tasks are large, vague, or impossible to test.
- Nobody can explain what must be true before a feature is done.
- Reviews focus on style because behavior is unclear.
- Releases are rare, stressful, or hard to roll back.
- Bugs reveal misunderstood requirements rather than isolated mistakes.

These signs do not mean the project is doomed. They mean the feedback loop is
too slow or too vague.

## Checklist for Predictable Projects

A predictable project should be able to answer these questions:

- What user goal does this work support?
- What observable behavior proves the goal was met?
- What acceptance tests define done?
- What is the smallest useful task we can complete next?
- Who needs to review the change?
- How will the change be tested automatically?
- How will users see and respond to the change?
- How will the release be verified?
- How can the change be rolled back if needed?

If the team cannot answer those questions, writing more code is unlikely to
make the project clearer.

## The Real Goal

The goal is not to make software easy. Software will still involve ambiguity,
tradeoffs, bugs, changing requirements, and technical constraints.

The goal is to make software steerable.

A steerable project can absorb new information without chaos. It can change
direction because the work is visible, the behavior is tested, the code is
reviewed, and releases are routine. That is what lightweight engineering
practice is for.
