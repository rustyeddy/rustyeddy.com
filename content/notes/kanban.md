---
title: Organizing Software Projects with Kanban
description: >
  Tracking tasks does not have to be Rocket Science! Absurdly simple, profoundly liberating and insane to ignore! 
  
  We are going to look into Kanban.
date: 2021-03-03
---

Kanban is fantastically simple. We will create a board with 3 columns,
_Todo_, _Work In Progress_ and _Complete_.

Each column is populated with a single card for every task that must be
done. The cards are prioritized and move through the system as the
work progresses.

## Good Kanban Reference

My goal is NOT to describe Kanban itself. Instead, here is a good video
if you are not already familiar with it.

> TODO add a good reference video to how Kanban works

The important things to take-a-way from the idea of Kanban is already acting as if:

- the tasks have been written in a 1-2 day granularity
- the _board_ is being updated regulary

Then _everybody_ will know exactly what progress has been made since the
last reference.

### Task Lists Evolve 

We must embrace this fact: The tasks we began thinking about during
the _Customer Disovery_ session while defining the _MVP_ was probably
pretty accurate, but almost certainly _incomplete_.

> You can not know, what you do not yet know.

This is the most difficult aspects of building _novel_ software.

The reality is that unforeseen issues will pop up that must be added
to our _Todo_ list at any given time. We'll also find that many of our
original tasks were very high level and will necessarily need to be
broken down into smaller tasks.

### Assigning Todo Items

As a person with a particular skill becomes available they are
matched up with the next task on the to do list.

The task or the kanban card is then assigned to that particular
person and moved into the Work In Progress (WIP) list. 

### Tests Define the Exit Criteria

During this phase of the process, a deeper level of thought needs to
be put into the _tests_ that must be written to establish a successful
completion of this task.

These tests will become part of the software itself, continuing for
evermore ensure to be run everytime a change is committed to the
source base, the quality of software consistently gets better.

### Contstraints on the WIP

A _prioritized Todo list_ and a _WIP_ that allows only a single (or
two) item(s) per person, will help ensure that the progress of the project
is visible to everybody that cares to look.

## Stacking Small Victories

Keep the tasks small. A developer should be able to complete a task in
a day or two max. If tasks become three or four days they most likely
can and should be broken into smaller tasks.

This is important because the development team needs to see victories
and needs to have successes. Likewise, management needs to see
progress, and  customers need to experience new features and
improvements. 

Eventually, the task is moved into the *Complete* column and the
software is delivered to the customer. (More on the software release
process later).

### Github Projects

Github provides a relatively new (2020) feature called projects,
that allow one to easily create a Kanban board. Github projects allow
users to create cards and track the github issues.

Your development team has access to this wonderfully integrated tool,
all for free right now.

Subscribe below if you would like help getting your team started.

> TODO - Provide a screenshot

### Github Issues

Project cards represent a big picture/high level view of the project
and how it progresses, whereas the _github issues_ are the place to
keep the details of the the change requests, actions to recreate bugs
and support for new feature requests.

_Github Projects_ allow a single click to convert a _Card_ into a
_Github Issue_ which then keeps the _Project Cards_ and _Issues_ in
sync. 

The integration of a Github Project board with the Github Issues is a
perfect combination of the right balance between communicating with
_non-technical_ project stake holders and the more technical details
developers need to program by.

> TODO - Screen shot github issues and project cards links.
