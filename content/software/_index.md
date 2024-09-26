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

I had a great idea to help my wife maintain her massive succulent
collection by building a self watering garden. This project would
consist of three primary components: 

1. The _soil sensor_, a piece of hardware that she could place in dirt
   to measure the soil moisture and a small pump to water the dry soil.

2. The _controller_ that will collect moisture data from all the soil
   moisture sensors and provide a user interface to track moisture
   levels and manually control the pump.

3. The _cloud_ element such that the data could be accessed and pump
   controlled from anywhere.

Turns out my brilliant idea is not all that unique, a quick search on
google turns up a bunch of similar projects. Oh well, maybe not unique
but useful still. 

The thing that struck me about most of these projects is that they are
built as a single, self contained watering station. I am a little more
ambitious in that I want to control a whole yard full of watering
stations and control them from anywhere.

There is a little bit of hardware to be built and a whole lot of
software to be written. So why not handle this like a real software
project that I would do in my day job.

The process goes a little like this:

## The Design Phase - Getting Started

I had Kelly describe to me in high level, non-technical detail the
various ways she wanted to use the product. She described the various
activities in a user story form.  For example:

> As a gardner I need to set different watering levels for different
> plants. The low soil moisture level turns the water pump on and the
> high moisture level turns the water pump off.

Todo: place a link to the various other user stories.

### Use Cases and Requirements

These user stories are typically refered to as _use cases_, these use
cases are the foundation of the entire rest of the software
development phases. These use cases will allow us to start pulling out
the _requirements_ and start drafting up the _Software Architecture_
document.

### Wire Frames, Story Boards and the User Experience

Along with the use cases Mini, the _front-end_ lead was able to start
sketching out the user interface in the form of _Wireframes_ collected
to together in _story boards_ that walked Kelly through the _Use
Cases_ giving Kelly (and us developers) a mutual, solid understanding
of what it would be like to use the software, not just by description
but walking her through the usage visualy, providing the complete
_User eXperience_.

#### Design Guide, Manifest and Sitemap

Mini also created the _design guide_ that included colors, fonts and
spacing that defines the over-all aesthetic of the site. Finally a
_site map_ was created to identify the pages of the User Interface and
the hiearchial relationship of the pages to one another. The
_manifest_ was also created as a list of all assets that occupy the UI
/ Website such as images, pictures, PDF documents and so on.

### Database Design - The Model

The Use Cases gives our Database Guru Melanie the ability to start
drafting the _Data Model_ which will describe the various data chunks
the app will need, where the data is stored and the data chunks
relationship to one another. We will constantly be referring to our
_data model_ throughout the development of this application.

## What do we have so far?

From our _Use Cases_ we were able to derive:

- The applications requirements
- An Architecture Document
- Wireframes, Storyboards and Design Guide
- Our Data Model
- Validation Criteria and Acceptance Tests

So we got a lotta stuff to work with now! Enough to get started doing
the actual development.

But how do we know we get it right once we start building?

### Test Cases

By stating the _requirements_ in a way that tell us what tasks need to
be _validated_ in a way that is concrete, measurable and very
specific. We are going to call the _acceptance tests_.

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

