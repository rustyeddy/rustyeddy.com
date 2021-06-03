---
title: Clone and Branch
date: 2019-04-11
weight: 50
description: >
  Enough theory, let's talk code. Before making any changes to the
  code, a developer with clone then branch a local copy of
  the software last latest code.
---

This is the beginning process a developer uses to create a _workspace_
they will make changes to the source code, add tests and possibly make
other changes to the software eco-system.

In a nutshell, once a developer has a task to work on, she will
essentially follow these steps:

1. Get on her personal _workstation_
2. Make a copy of the source code to be worked on
3. Create a _branch_ in _git_ such that her code does not effect
anybody elses code (yet).

Our developer is now free to make all the changes she desires, and
conduct small experiments, make mistakes with this private copy of
code becuase it is only available to her, and does not effect anybody
else. 

Until she needs to put her bug fix back in the "main" branch of code
everybody else uses, Q&A, collegues, customers, everybody! She better
make sure is excellent!

She also must ensure that it does not break a previously working test,
the dreaded regression error.
