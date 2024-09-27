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

1. The _soil sensor_ is a piece of hardware that she could place in
   dirt to measure the soil moisture and a small pump to water the dry
   soil.

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
stations and be able to control them from anywhere in the world!

There is a little bit of hardware to be built and a whole lot of
software to be written. I am not a hardware guy so I'm going to hack
together a prototype or two to get this project rolling.

However, I am a software professional (don't laugh it's true!), so why
not handle this like a real software project that I would do in my day
job.

The process goes a little like this:

## The Phases of the Software Development Lifecycle

We are going to break down this particular project, as well as all
software development project into three primary phases:

1. Design 
2. Development 
3. Delivery

These three phases are certainly linear but I want to make it really
clear, there are iterative cycles within each of these phases and
amoung the phases collectively. 

As matter of fact that the iterative nature of this development
process is at the heart of true _Agile Software Development_.

Let's jump into each of these phases just a little deeper.

---

## The Design Phase - Getting Started

I had Kelly describe to me in high level, non-technical detail the
various ways she wanted to use the product. She described the various
activities in a user story form.  For example:

> As a gardner I need to set different watering levels for different
> plants. The low soil moisture level turns the water pump on and the
> high moisture level turns the water pump off.

Todo: place a link to the various other user stories.

### Use Cases and Requirements

These user stories are typically refered to as _use cases_, which are
will establish the direction of the entire rest of the software
development project. These use cases allow us to start pulling out
the _requirements_ and start drafting up the _Software Architecture_
document.

### Wire Frames, Story Boards and the User Experience

Along with the use cases Mini, our _front-end_ developer was able to
start sketching out the user interface in the form of _Wireframes_
collected to together in _story boards_ that helped walk Kelly through
the _Use Cases_ giving Kelly (and us developers) a mutual, solid
understanding of what it would be like to use the software _visually_
not just by description providing a clear and complete _User
eXperience_.

> Why tell somebody when you can show them!

#### Design Guide, Manifest and Sitemap

Mini also created the _design guide_ that included colors, fonts and
spacing that defines the over-all aesthetic of the site. Finally a
_site map_ was created to identify the pages of the User Interface and
the hiearchial relationship of the pages to one another. 

A _manifest_ was also created as a list of all assets that occupy the
UI / Website such as images, pictures, PDF documents and so on. (This
project does not actually have any PDFs but you get the picture).

### Database Design - The Model

The Use Cases gives our Database Guru Melanie the ability to start
drafting the _Data Model_ which describes the various data chunks
the app needs, where the data is stored and the data chunks
relationship to one another. We will constantly be referring to our
_data model_ throughout the development of this application.

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

## What do we have so far?

From our _Use Cases_ we were able to derive:

- The applications requirements
- An Architecture Document
- Wireframes, Storyboards and Design Guide
- Our Data Model
- Validation Criteria and Acceptance Tests

By staying disciplined and doing our proper homework we have gathered
plenty of information to derive our initial _requirements_ enough that
we are now able form measurable _Test Cases_.

Wow we gotta lotta stuff to work with now! Certainly enough to get
started doing the actual development.

But before we get started doing the actual development we need to
prepare a couple tools to help keep us focused and provide visibility
into the progress we are making.

These tools are going to be:

1. Our Todo list aka Kanban board
2. Software Repository aka _Version Control System_
3. Test rig

---

## Preparing for Development

### The Kanban Board - The mighty driver

From the _requirements_ and _story boards_ we were able to create a
series of works items (or todo list) in the form of a _Kanban board_. 

The kanban board is a wonderful way to visually display what needs to
get done, what is being worked on and what has been accomplished.

OK. This has been a lot of work and we have made great progress
_planning_ the project. With out Kanban board in place, we need to
setup one more thing, our Version Control System (VCS) before we get
into the thick of actual development.

### The Version Control System (VCS)

In preparation to start developing the software the first important
task is getting the _Version Control System (VCS)_ ready to go. The
VCS in our case will be _git_ hosted by _github_.  The VCS will
provide the _single source of truth_ and keep a history of every
single change, who made that change and when.

### The Test Rig

We are going to setup a test environment to that allows us to easily,
thrououghly and painlessly test our software as we continue through
development. It is OK if the tests start out semi-manually, but we are
going to want to get as close to 100% thouroughly testing _all_ of the
software that gets _committed_ to our released product.

Our automated tests will become part of our delivery system, known in
the industry as our Continuous Integration/Continuos Delilvery (CI/CD)
Pipeline. In modern times the CI pipeline is tightly integrated into
our version control system.

We will go through some very specific examples as this project
unfolds.  

Excited right? I know, me too!!

---

## The Development Phase

Finally the fun part, time to get crackin!

### Pick a Task and Create a Branch

It is time for me to pick the top task from the _Todo_ (some people
like to call it the back log) column of _Kanban board_ and move it to
the _In Progress_ column, letting everybody know what I am working
on. It also gives everybody a quick visual into what current tasks,
and how many items are being actively worked on at any given moment.

With our first task at hand it is time to check out a fresh version of
the (empty) software from the VCS system. The first thing I am going
to do is create a _feature branch_ and start writing up a _test case_
or three depending on the complexity of the task.  

As we know, the test cases are going to be litmus that tells us wether
our coding effort has correctly implemented the associated
requirement.  It will serve two other purposes, first it will live
with the code forever more giving us confidence as the code base grows
larger and more complex that future changes are not going break
something that was working correctly does not break.

If done wisely, it can also act as a way to automate the _dev loop_
making our: edit, compile, test, debug cycle making it _sooooo_ much
more convinient to develop these features.

#### The Developers Loop

Let's speak about the _dev-loop_ a bit. Some people mistakenly
consider this tightly grouped activities the SDLC
itself. While this important set of actions are at the core of
software development we can clearly see (from the rest of this
article) these activities can be done in a vacuum and deliver the
correctly implemented software project in and of itself.


```
      +-----> Compile ------+
      |                     |
      |                     v
    Edit                  Test ==> Success! ==> Pull/Merge Request
      ^                     |
      |                     |
      +------- Debug <------+
```

Many developers, myself included will start creating code a bit at a
time, incrementally adding code that gets me closer and closer to
successfully completing my task at hand.

At first there will be incremental additions that get the task closer
to complete, but along the way there are many small mistakes that are
iteratively corrected as I code.  Until the ultimatel success!

Depending on the complexity of the task this loop can be iterated over
hundreds of times, that's why making it as efficient as possible will
be a huge win over the coarse of the development.

### The GUI Down

In the mean time the UI team consisting of Mini is cranking through the
user interface code with a mocked back end getting the whole UX flow
together. Iterating through screen designs, tweaking the Style Guide
all the while responding to the regular user feedback she is getting.

### Back to the Backend

Back to me: after a few iterations and expanded tests cases all
tests finally pass! 

At this point I will commit the code to my _feature branch_ and
_pushe_ the branch to the server where I will then create a
_pull request_ (also known as a _Merge Request_ in gitlab).

The _pull request_ become the opportunity to have all newly introduced
code scrutinized by our annoying peers.

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

### Merge on to Main

At long last, the peer review passes and the code is _Merged_ into the
_Main_ branch.  Victory. Let's move that card over to the _Done_ list
on the Kanban board!

To note: the tests Joan had written to validate this new feature will
become part of the automated tests from now forevermore ensuring this
feature does not get damaged during future modifications.

---

## Lifecycle Phase Delivery - Ship It

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

