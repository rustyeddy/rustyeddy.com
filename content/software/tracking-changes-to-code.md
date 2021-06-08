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

It frightens me to be introduced to a software project that has a single
copy in the developers folder, or worse developers and users are
manually copying folders of complex gathers of code.

If you are working like this STOP!

> Start using Version Control NOW!

Done correctly, your VC will track _every change_ to your source code
with clear well written summaries (logs) of the problem that was
solved.

Version Control (VC) have been around since the 1970's at least. These included RCS,
CVS, SVN and lot's of clunky and lame pay versions. Now we have
GIT. 

### Git for Version Control

Like a majority of the world today (2021) we will use the version
control system (git)[http://git-scm.org] invented by _Linus Torvalds_
to help with development of the widely distributed Open Source
software [Linux](http://kernel.org).

I am not going to write a git tutorial here, mostly because great ones
already exist. Rather I'll just point to a couple references:


### Github for Services and Workflow

In this series we are going to focus on (Github)[https://github.com]
(the 800lb Gorilla of Github of _social programming_ services).

For this article we are going to use Github, Which is a pretty
standard part of my workflow.

As many of you may know git is a software version control system. 
Github wraps a lot of very useful features around the source control tool
like:

1. Git soure control
2. Github issues for tracking features, requests and bugs
3. Kanban board to visually track and manage
4. Actions: Automated debugs
5. Pull requests for code review before committing
6. Static HTTP server for web page documentation
7. Release packages

With these capabilities built into github, we have pretty
much everything that we need to run our entire software development
process. 

During the process of identifying the MVP, we can use the github
*Projects Board* to list and track task items, as well as prioritize. 
There is not one correct way to go through this process. This is just one way
that I find pretty natural.

As the MVP is broken down into tasks, the tasks are then placed in the
backlog of the Kanban board. They will then be ordered according to
priority. In other words, the first task on the list, is the next task
that will be worked on.

When somebody becomes available, that next task is assigned to the
available person and is moved over into the *Work In Progress (WIP)*
list.
