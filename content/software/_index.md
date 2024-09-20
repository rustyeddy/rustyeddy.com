---
title: Software Development Lifecycle Phases
description: >
  This series of articles breaks down the Software Development
  Lifecycle Phases which is basically a series of best practice
  processes used to efficiently build software in a cost effective and
  highly visible manner. By highly visible, I mean a manner in which
  non-software developers such as product owners, users and managers
  can understand and track the progress of a software project they have
  a vested interest in.
tags: [ sdlc, software development lifecycle phases  ]
date: 2023-01-13
---

## Process is Important

Software like building a house or designing a car is hard. Much like
the design and construction of a house or car, software development
must be planned, organized and thought through to a great extent
before the actual development or building can start.

Once the construction or development starts a series of well defined
steps must be adhered to in order to achieve the goal the project
originally set out to accomplish. Yet the process needs to be flexible
enough to adapt to changes discovered during the course of
development, testing and feedback from users. The planning phase all
the way through delivery will be best benefited if well defined
processes are followed from the planning phase all the way through
development. 

### Well defined yet flexible

Fortunately our industry has some well defined processes and
Best Practices that are understood and practiced by many in the
industry. However, unlike building a house, the nature of software
allows a lot greater flexibility around on how each of the phases are
applied providing a great degree of flexibility and customization
according the project and the organizations needs.

### Software is an Iterative process

Before we get into the distinct phases of the SDLC It must be noted
that the phases of the Software Development Lifecyle documented below
are iterative. That is unlike building plans from an architect pretty
much set in stone how the dwelling will be constructed, unless
expensive and time consuming approvals are made.

## Software Development Lifecycle Phases

The process and design phase of software development will establish
the requirements and desires of the owners and users of the software,
it will also give the software team a high level understanding of the
major components of the software project.

This phase starts getting everybody involved in the project on the
same page, both the people running and paying for the project, the
users, if they are a different group of people and finally the
developers that will be using the project.

This phase happens before any actual development happens.

## Design

### Use Cases 

#### Establish Requirements

#### Acceptance Test Criteria

#### UX / Sitemaps, Mockups and Storyboards

Provide the users and developers what the particular screens will look
like making sure all information is captured and understood by both
parties. 

### Kanban Board

The Kanban board will become the daily driver of the project. All
tasks should be recorded in a card to keep track of what needs to be
done, what work is currently in process and finally what has been
accomplished. 

The Kanban board creates a nice visual into the state of the project. 

## Architecture

This phase starts translating high level design, use cases and
requirements and transforming them into technical details.

Start identifying the primary components and how they will relate to
one another.

### Development and Testing

The time has come to roll up our sleeves and get started writing code. 

#### Version Control System (VCS)

Version Control Systems (VCS) is the work hourse for the development
team. The 800lb Gorilla of VCS is _git_ originally created by the
author of Linux, Linus Torvalds for the development of the Linux
kernel itself.

#### Test Driven Development (TDD)

#### Let the Coding Begin!

This is where fun and frustration will begin as well as visible
progress. 

1. Pick a task from the Kanban board, typically a day or two to
   develop.
2. Checkout source code and create a branch
2. Develop a test to validate the new feature
3. Start coding, debug iteration until all tests pass
4. Create a Merge Request (Pull Request)
5. Peer review changes
6. Merge code and tests into repository
7. Add tests to CI/CD pipeline

### Deploy and Manage

### Fix Bugs and Add Features



