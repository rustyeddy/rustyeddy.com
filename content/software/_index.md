---
title: The Process of Delivering Predictable Software
description: > 
  Software is hard to do correctly, and even harder to deliver on time
  and within budget. This page is dedicated to assembling some case
  studies and establish software development best practices.
date: 2020-04-05
---

This page is an attempt to document a complete, yet light weight
Software Development LifeCycle (SDLC) process / workflow. The
processes and tools used in this document are 100% free, however the
principals supported and studied can translate into many very
different eco-systems, free and paid.

## Why Is Software So Difficult?

- One reason is that you can't see it.
- There is no single right way to do software
- Software is a combination of Art, Science and Engineering
- It changes very fast

A couple having their _Dream House_ built does not have to have to
know much about construction to get a sense of how well progress is
moving along on their _dream_ house.

Software is much harder to track, by it's very nature. However, just
as construction projects can easily go off rails, _software projects_
can be perceived as even worse.

Software can be properly managed just like construction projects, if
the right processes and tools are established and enforced throughout
the product lifecycle.

## Establishing Goals and Tasks

There are a lot ways to track project progress with _Project
Management_ tools, we are going to make it really simple 
[Kanban Board](https://en.wikipedia.org/wiki/Kanban) type of card
list.

Before we can do anything we must establish our _goals_, this can take
on many forms, such as the _Minimum Viable Product (MVP)_ established
by Eric Reis in the excellent book _Lean Startup_.

### Goals are most effective when

- Communicated in normal people language (user stories)
- Everybody understands and agrees with the Goals
- Measurable and easy to determine when they are complete
- Tasks should be 1-3 days max if possible (the will always be exceptions)
- Prioritized to provide users (stakeholders) constant incremental value

### Github Projects

Github provides a relatively new (for me in 2020 anyway) feature that
allows you to define rows of tasks, for example "Todo", "Work In
Progress" and "Done". Cards are created with tasks and moved across
the board accordingly.

> TODO - Provide a screenshot

### Github Issues

Project cards represent a big picture wide array of tasks, it is the
"Github Issues" that track all of the actual coding work and changes
that take place.

_Github Projects_ allows a single click to convert a _Card_ into a
_Github Issue_ then allowing the issue to be tracked by the _Project
Card_ as the github issue does what it does tracking discussions and
changes through a new features lifetime.

> TODO - Screen shot github issues and project cards linkes.

### Github Clone and Branch

This is the beginning process a developer uses to create a _workspace_
they will make changes to the source code, add tests and possibly make
other changes to the software eco-system.

In a nutshell, once a developer has a task to work on, she will
essentially follow these steps:

1. Get on her personal _workstation_
2. Make a copy of the source code to be worked on
3. Create a _branch_ in _git_ such that her code does not effect
anybody elses code (yet).

Our developer is now free to make all the changes she desires, and
conduct small experiments, make mistakes with this private copy of
code becuase it is only available to her, and does not effect anybody
else. 

Until she needs to put her bug fix back in the "main" branch of code
everybody else uses, Q&A, collegues, customers, everybody! She better
make sure is excellent!

She also must ensure that it does not break a previously working test,
the dreaded regression error.

### Testing Unit and Systems

Before her new code can be integrated into the existing, heavily
trusted code base, we have to make **sure** it is of the same quality
as the existing codebase, by adding one or more adequate **tests** to
the systems tests.

#### Automated vs. Manual Tests

Tests are far more effective when the are clearly written down. Even
better written down and automated.

It is inevitable that some tests, at least in certain industries
some tests may have to be conducted manually. Ideally, however you
will try automating tests as close to 100% as possible.

With automated tests it will be common to run a complete suite of
tests for every software change, every fix, every addition of new
code and even a complete test run after removing dead code.

Why not?

Nothing will give a developer more confidence than comprehensive
regression tests that are easy to run and easy to add new tests and
modify existing tests.

Automated tests will most likely provide the ability to run a subset
of test or even pick a single specific test to run.

The key is that a developer is free to run and re-run tests to her
hearts content until she is convinced the code is ready to everybody
else.

But first, it must pass the peer review...

### Peer Review aka Pull Request 

Github has long since provided support for the concept of a _pull
request_. One way to think about it is a request to _pull your
changes_ into the main line.

One great benefit it provides is the platform for new and changed code
to be ~~scrutinized~~ reviewed. 

