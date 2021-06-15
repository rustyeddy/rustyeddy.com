---
title: Clone and Branch
date: 2019-04-11
weight: 50
description: >
  Enough theory, let's talk code. Before making any changes to the
  code we are going to rely on git, our Version Control System to
  ensure that changes to code are meticulously vetted into the
  mainline with not a semi-colon out of place.
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
source code. Such that the entire history of the source code can be
"played back" so to speak.

To support parallel development efforts by many programmers VC systems
support _branching_, where a developer can create a new _history_ of
source changes.

The power part of branching is that they isolate new early changes of
code from high quality production code, while still providing a
complete history of the _divergent_ or _branched_ software.

### Trim Branches Quickly

Branches have been part of VC systems for decades, despite their
necessary benefits. They can contribute to bulk, duplication and
confusion (what branch did I leave that peach on?)

_Best Practices_ have identified short lived _feature_ or I like the
term _task_ based branches are a well supported practice.

The idea is that every new task gets a _feature branch_. Since a given
task should only take 1 or 2 days to complete, the code in the branch
is vetted, tested and comitted to mainline in a day or so.

Once the branched code has been commited to the _mainline_ the feature
branch can be deleted forever.

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
