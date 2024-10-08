---
title: Extra
date: 2021-04-06
draft: true
---


## The Delivery Phase - Putting the creation to work!

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

The design phase happens before any coding begins and is primarily an
interaction with the non-technical users and development team with
discussions and activities on a non-technical level.

The whole point of the design phase is to get the users and developers
on the same page.

### Use Cases 

The first step in the process is to establish the _use-cases_ to get
the users to describe what the software needs to do and how they will
go about using it.

Use cases in short are the tasks the software will be required to
perform. Uses cases are non-technical best stated in _story
form_. They should be totally understandable by non-technical
non-programmers as a way to communicate what is required of the
software. 

TODO: reference the Ivar Jacobson use case web page

Use cases will result in the following artifacts of this software
development process:

1. Requirements
2. Major components of the software system
3. Acceptance tests can be derived from the requirements resulting
   from the use case.

#### Establish Requirements

From the usecases we can start deriving the requirements. The
requirements can then be turned into specific tasks with measurable
goals. 

#### Acceptance Test Criteria

The acceptance criteria will be the ultimate list of items the
software needs to accomplish.  In otherwords it will be the set of
requirements defined by what precisely needs to happen in order to
consider that portion of a use case to have been successfully
resolved. 

Acceptance tests must be stated in very specific and measurable
quantities. 

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

Tasks ultimately should be broke down to increments that will take a
day or two. Tasks that take a week or more can usually be broke down
into multiple sub-tasks.

We want to keep the tasks small-ish keeping with the agile philosophy. 

## Architecture

This phase starts translating high level design, use cases and
requirements and transforming them into technical details.

Start identifying the primary components and how they will relate to
one another.

### Development and Testing

The time has come to roll up our sleeves and get started writing code. 

#### Version Control System (VCS)

TODO: change this up such that we describe more of what the version
control system does.

Version Control Systems (VCS) is the work hourse for the development
team. The 800lb Gorilla of VCS is _git_ originally created by the
author of Linux, Linus Torvalds for the development of the Linux
kernel itself.

These days all in one systems have been built around git, such as the
ever popular github.com or gitlab.com. Not only do they incorporate
the elements of _Version Control_ proper but also have bug/issue
tracking, CI/CD pipelines and other tools to make these powerful
systems to guide our software through the entire development and
delivery process.

We will get into much detail about these systems using Github.com and
it's tools that are almost all mostly free.

Before coding officially begins one or more repositories will be
created for our development tasks.

#### Test Driven Development (TDD)

In an ideal world all development tasks will begin with a well defined
test that will verify the requirements being developed pass as
required. 

We will get into the variety of different test types and what the
objective of different tests. But suffice it to say, all great
software projects are pretty thouroughly tested.

#### Let the Coding Begin!

This is where fun and frustration will begin as well as visible
progress. 

1. Pick a task from the Kanban board
2. Checkout source code and create a feature branch for the task
2. Develop a test to validate the new feature
3. Start coding, debug iteration until all tests pass
4. Create a Merge Request (Pull Request)
5. Peer review changes
6. Merge code and tests into repository
7. Add tests to CI/CD pipeline
9. CI/CD pipeline must then pass

##### Select Task from Kanban

##### Checkout Source Code 



