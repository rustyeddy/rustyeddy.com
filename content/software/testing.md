---
title: Testing Software
date: 2019-05-04
weight: 60
description: >
  Testing software is pretty self explanatory, it seems. The technical
  details are many, more important are the positive ramifications
  throughout the project as it evolves are profound. Let me explain why ...
draft: true
---

### Testing Unit and Systems

Before her new code can be integrated into the existing, heavily
trusted code base, we have to make **sure** it is of the same quality
as the existing codebase, by adding one or more adequate **tests** to
the systems tests.

#### Automated vs. Manual Tests

Tests are far more effective when the are clearly written down. Even
better, written down AND automated.

It is inevitable that some tests, at least in certain industries,
may have to be conducted manually. Ideally however, you
will try automating tests as close to 100% as possible.

With automated tests it will be common to run a complete suite of
tests for every software change, every fix, every addition of new
code and even a complete test run after removing dead code.

Why not?

Nothing will give a developer more confidence than comprehensive
regression tests that are easy to run and easy to add new tests and
modify existing ones.

Automated tests will most likely provide the ability to run a subset
of test or even pick a single specific one to run.

The key is that a developer is free to run and re-run tests to her
hearts content until she is convinced the code is ready for everybody
else.

But first, it must pass the peer review...


One of the first things that ought to be done, but seldom gets the
attention it needs, is the specific criteria that must be met to make
the customer/user happy. 

We are going to call this group of criteria the projects **Acceptance
Test**. Ideally, all acceptance tests can be automated with software,
however, they may be cases that manual intervention is required to
conduct an entire set of acceptance tests.

## Whitebox vs. Blackbox Testing

My intention here is not to get into a dissertation on testing in test
methodologies. Rather, I would like to point out a couple very
important and fundamental types of tests that MUST be conducted.

This includes both white box and blackbox tests. White box tests are
done with access to the internal details of the software. These are
typically represented by unit tests.

Blackbox tests on the other hand. allow no access to the internal structure
of the software. Rather, the tests are conducted from a systematic or
external point of view, just as an end user of the software will be
expecting this software to behave. 

## Acceptance Tests are Blackbox

The acceptance tests are by definition what the customer expects the
software to do, and has in effect agreed to be happy with, the software
once it passes acceptance tests.

