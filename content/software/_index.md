---
title: Software Development
description: >
  Practical engineering practices for building software predictably, from use cases and task slicing through testing, review, and release.
tags: [sdlc, software development]
date: 2026-05-22
show_articles: false
---

This section is for people who need software projects to become more
predictable without burying the team in process.

The core idea is simple: software goes wrong when users, developers, reviewers,
and operators stop sharing the same picture of what is being built. These
practices keep that picture visible from first conversation through release.

## Start With the Workflow

Read these in order if you want the main software delivery path:

- [Software is Hard](/software/software-is-hard/) explains why projects drift and why feedback loops matter.
- [Use Cases](/software/use-cases/) captures user goals in plain language.
- [Use Cases to Tasks](/software/use-cases-to-tasks/) turns user value into testable implementation work.
- [Organizing Software Projects with Kanban](/software/kanban/) keeps work visible and limited.
- [Test Driven Software Development](/software/test-driven-software-development/) makes expected behavior repeatable.
- [Peer Reviews](/software/peer-review/) catches design and behavior problems before they ship.
- [Release Process](/software/release-process/) turns finished work into versioned, recoverable user value.

## Supporting Practices

These articles support the workflow without being the main sequence:

- [Version Control Systems](/software/version-control-systems/) treats history, branches, reviews, and tags as project infrastructure.
- [Wireframes and Storyboards](/software/wireframes-and-storyboards/) helps teams reason about user flows before implementation.
- [Fixed-Point Numeric Types in Go Financial Software](/software/numeric-types-financial-software/) shows domain modeling and correctness in a narrow technical area.
- [The Strategy Pattern in a Backtesting Engine](/software/strategy-pattern-backtesting/) shows how interface design keeps simulation and production logic aligned.

## How to Use This Section

The software articles are the canonical guidance for delivery practices. Project
pages show those ideas inside larger systems. Notes are smaller observations or
historical references that may not be as polished as these articles.
