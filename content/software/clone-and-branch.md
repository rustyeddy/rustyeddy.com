---
title: Clone and Branch
date: 2019-04-11
weight: 50
description: >
  Enough theory, let's talk code. Before making any changes to the
  code, a developer will clone then branch a local copy of
  the software's most recent code.
---

This is the beginning process a developer uses to create a _workspace_.
They will make changes to the source code, add tests and possibly make
other changes to the software eco-system.

In a nutshell, once a developer has a task to work on, she will
essentially follow these steps:

1. Get on her personal _workstation_
2. Make a copy of the source code she will work on
3. Create a _branch_ in _git_ such that her code does not effect
anyone elses code (yet).

Our developer is now free to make all the changes she desires, 
conduct small experiments, and make mistakes with this private copy of
code becuase it is only available to her, and does not effect anyone
else. 

That is, until she needs to put her bug fix back in the "main" branch of code
everyone else uses (Q&A, collegues, customers). Everybody! She better
make sure it is excellent!

She also must ensure that it does not break a previously working test,
the dreaded regression error.