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

## An Tale of Software Development

Kelly got ahold of me wanting some software developed for a self
watering garden system that Mark had designed. The hardware is composed
of a soil moisture and temperature sensor with a chip that has a wifi
to communicate with an external _controllor_. It also has a pump that
can be controlled by dry soil or manually from an app on a phone.

The process went a little like this:

## The Design Phase - Getting Started

I had Kelly tell me how the product was meant to do. She describe all
the various ways the software was going to be used, case by case in
high level (non-technical) detail. These _user stories_ Kelly told
we were able to break out all the ___use cases___ into
individual descriptions on the various ways the product was going to be
used. 

### Use Cases and Requirements

From the use-cases we were able to derive the initial set of
_requirements_ and the begin drafting the _Software Architecture
Document_. 

### Wire Frames, Story Boards and the User Experience

Along with the use cases Mini, the _front-end_ lead was able able to
start sketching out the user interface in the form of _Wireframes_
collected to together in _story boards_ that walked Kelly through the
_Use Cases_ giving Kelly and the develop a mutaul, solid understanding
of what it would be like to use the software, not just by description
but walking her through the usage visualy, providing the complete
_User eXperience_.

#### Design Guide, Manifest and Sitemap

Mini also created the _design guide_ that included colors, fonts and
spacing that defines the over-all aesthetic of the site. Finally a
_site map_ was created to identify the pages of the User Interface and
the hiearchial relationship to one another. The _manifest_ was also
created as a list of all assets that occupy the UI / Website such as
images, pictures, PDF documents and so on.

### Database Design - The Model

Also from the Use Cases Melanie our Database Guru is able to start
drafting what the Database will contain and how the different chunks
of data are going to relate to one another. This is referred to as the
_Data Model_ used through out the application.

### Test Cases

From the _Use Cases_ we were able to derive:

- Requirements
- Architecture Document
- Wireframes, Storyboards and Design Guide
- Preliminary Data Model
- Validation Criteria and Acceptance Tests

The _requirements_ in a way that tell us what tasks need to be done in
a way that is concrete, measurable that can be _validated_ by specific
_acceptance tests_.

The _Acceptance Tests_ will be our guiding light, every feature or
change we make to the software needs to be validated by a specific
test or two.

As the Use cases and hence requirements change due to user
interaction, _which they surely will_, our tests will also change
accordingly.

### The Kanban Board - The mighty driver

From the _requirements_ and _story boards_ we were able to create a
series of works items (or todo list) in the form of a _Kanban board_. 

The kanban board is a wonderful way to visually display what needs to
get done, what is being worked on and what has been accomplished.

OK. This has been a lot of work and we have made great progress
_planning_ the project. With out Kanban board in place, we need to
setup one more thing, our Version Control System (VCS) before we get
into the thick of actual development.

## The Development Phase

### Getting Ready to go - Version Control System (VCS) - 

In preparation to start developing the software the first important
task is getting the _Version Control System (VCS)_ ready to go. The
VCS in our case will be _git_ hosted by _github_.  The VCS will
provide the _single source of truth_ and keep a history of every
single change, who made that change and when.

### Pick a Task and Create a Branch

Joan takes the first item from the Kanban board and moves it from the
_Todo_ column over to the _In Progress_ column, letting everybody know
what she is currently working on, I do the same.

Joan checks out a fresh version of the (empty) software from the VCS
system, creates a _feature branch_ and starts writing up some
_tests_ to validate the task she is going to start working on before
she starts writing code for the actual feature she is going to
develop. 

#### The Developers Loop

Joan then starts writing code with the goal of passing the tests, she
then gets into what I like to call the _dev-loop_:

```
 +-> Edit -> Compile -> Test -> Debug -+
 |                                     |
 +<------------------------------------+
```

### The GUI Down

In the mean time the UI team consisting of Mini is cranking through the
user interface code with a mocked back end getting the whole UX flow
together. Iterating through screen designs, tweaking the Style Guide
all the while responding to the regular user feedback she is getting.

### Back to the Backend

Back to Joan: after a few iterations and expanded tests cases all
tests finally pass! 

At this point Joan commits the code to her _feature branch_ and
_pushes_ the branch to the server where she will create a
_pull request_ (also known as a _Merge Request_ in gitlab) that will
allow Joans new code to be scrutinized by peers.

### Pull Requests and Peer Reviews

The _Pull Request_ sets off an automatic / automated series of systems
tests that when they pass will grant the code the ability to be
merged into main, provided Joan's changes pass _peer review_. 

Joan's code will also need to be _Peer Reviewed_ by a couple colleges.
Bob and Brenda also sharp developers will scrutinize Joans code, if
they see things that do not adhere to coding standards, or create
potential future problems Bob and Brenda can make comments on the code
and that Joan will have to address, either defending her given code or
making appropriate changes sending her back to the "Edit -> Debug"
cycle above.


### The Main Merge

At long last, the peer review passes and the code is _Merged_ into the
_Main_ branch.  Victory. Let's move that card over to the _Done_ list
on the Kanban board!

To note: the tests Joan had written to validate this new feature will
become part of the automated tests from now forevermore ensuring this
feature does not get damaged during future modifications.

## Lifecycle Phase Release - Ship It

The code in the main branch is either released automatically via an
automated CI/CD Pipeline or is acculmulated with other changes until
it has been completed and married up with the User Interface complete by
Mini's team.

We now have a real live application _Minimum Viable Product_ or
_Minimum Viable Feature (MVF)_ is ready to hit the streets.

The project is now in the hands of real users doing real work, or at
lease it is ready to be...

### Feedback - Features Requests and Bugs Reports

New features are being requested, tweaks to existing features and an
occaisonal bug is found. All of this feedback is collected in a bug
tracking system and added to back to the Kanban board where this whole
process continues.

Did we say that software development is an _iterative process_.

## Want More?

This was a real quick overview of a software development project
_inspired_ by real events. Much detail and nuance were left out to
keep the story flowing and not become a novel.

However, if pratical application of software develop practices is
something you are interested in, would like to start doing better. I
have started creating and will continue to add a lot more content
diving into more _practical detail_ on each one of these topics.

If so, continue on to my "Phases of the Software Development
Lifecycle" and we will jump into each of these topics in more detail
including some very explicit examples of each phase.

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



