---
title: Tracking Changes to Code
date: 2020-06-12
weight: 30
description: >
  All the planning has now come to this, it is time to change code!
  What happens now? The clearest evidence of a rookie team, is the lack
  of a Version Control (VC) system. Your VC will keep your code in a
  single place where EVERYBODY CAN FIND a complete
  documented history of all changes.
---

It frightens me everytime I am introduced to a new software project
where the "latest" source code is somebodies folder somewhere and
copies are being _zipped_ and _copied_ via email or thumbdrive.

This process is confusing from the get go, and just goes downhill from
there. 

> If you are working like this STOP! Start using Version Control NOW!

Done correctly, your VC will track _every change_ to your source code
with clear well written summaries (logs) of the problem that was
solved.

## Git and Version Control

Version Control (VC) has been around since at least the 1970's . These
included RCS, CVS, SVN and lot's of clunky and lame pay versions. Now
we have GIT.

Git was development by the famous _Linus Torvalds_ author of Linux to
handle the distributed nature of the [_Linux Kernel_](http://kernel.org).
Development and the thousands of software developers that continuously
contribute to the code base. 

### Github is Git as a Service

Github revolutionized software development by taking the widely
popular _Git_ version control system and wrapping online services
around them, such as an _Issue Tracker_, _Project Kanban Board_ and a
whole social infrastructure allowing developers to easily share Open
Source software projects.

### Github for Services and Workflow

In this series we are going to focus on (Github)[https://github.com]
(the 800lb Gorilla of Github of _social programming_ services).

For this article we are going to use Github, which is an standard and
essential part of my workflow. The following services we will be able to
start using as part of our workflow from github:

1. Git soure control
2. Github issues for tracking features, requests and bugs
3. Kanban board to visually track and manage
4. Actions: Automated debugs
5. Pull requests for code review before committing
6. Static HTTP server for web page documentation
7. Release packages

With these capabilities built into github, we pretty
much have everything that we need to run our entire software development
process. 

During the process of identifying the MVP, we can use the github
*Projects Board* to list and track task items, as well as prioritize. 
There is not one correct way to go through this process, this is just one way
that I find pretty natural.

As the MVP is broken down into tasks, the tasks are then placed in the
backlog of the Kanban board. They will then be ordered according to
priority. In other words, the first task on the list, is the next task
that will be worked on.

When somebody becomes available, that next task is assigned to the
available person and is moved over into the *Work In Progress (WIP)*
list then that task becomes a github issue to be tracked until the
project is committed.
