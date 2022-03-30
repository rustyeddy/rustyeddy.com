---
title: Clone and Branch
date: 2019-04-11
description: >
  Enough theory, let's talk code. Before making any changes to the
  code we are going to rely on git, our Version Control System to
  ensure that changes to code are meticulously vetted into the
  mainline with not a semi-colon out of place.
draft: true
---

Initial changes to software are always done to a **copy** of the
actual source code. This provides a local sandbox for the developer to
make changes, experiement with fixes and do really weird things
that will never be allowed in the final product (we will cover this in
the peer review section).

## Clone The Repo

Our actual "_Source Code_" resides in what's called a _Software
Repository_ which is a server in the cloud, however the work performed
by the developer is typically done on a local _computer_.

### Branch Mainline

The Repository maintains a _versioned history_ of all changes to the
source code. The entire history of the source code can be "played
back" so to speak.

To support parallel development efforts by many programmers, our
_Version Control System_ (git) provides a feature called
_branching_, where a developer can create a new _branch_ which
supports a new set of changes (history) that will not effect the main
source code.

The power of branching provides the developer a "sandbox" for making
changes to their local copy of the source code for experiementation
before the code is subsequently tested and _merged_ into the main
branch. 

### Trim Branches Quickly

Branches have been part of _VCS_ for decades, however, despite the
necessary benefits they provide, they can also contribute to
duplicated code and general confusion, like: which branch did I leave
that peach on? 

_Best Practices_ have identified short lived _feature_ or I like the
term _task_ based branches are a well supported practice.

A _feature branch_ is created by the developer for every new task they
work on. Once that task is complete, typically 1 to 2 days, the
_feature branch_ will then be deleted after the new code has been
_commited_ to the _main branch_. 

## Sandbox Freedom

Our developer is now free to make all the changes she desires, 
conduct small experiments, and make mistakes with this private copy of
code. This is becuase it's only available to her and does not effect anyone
else. 

That is, until she needs to put her bug fix back in the "main" branch of code
everyone else uses (Q&A, collegues, customers). Everybody! She better
make sure it is spot on!

She also must ensure that it does not break a previously working test,
the dreaded regression error.

This leads us to the next topic, my favorite: [testing](/software/testing)
