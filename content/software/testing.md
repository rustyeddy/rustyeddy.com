---
title: Testing Software
date: 2019-05-04
weight: 60
description: >
  Testing software is pretty self explanatory, the technical details
  are many, but most important the positive ramifications throughout
  the evolving project are profound, let me explain why ...
---

## Monitor Production and Bug Issues

Once the applicaiton has been released into the wild, if it is to be
of any success, it will start collecting a set of _feature requests_
and _gasp_ even _bugs_.

Once again, github Issues will help us track both of these. We can use
Github _projects_ to _Kanban_ board the thing.


---

### Testing Unit and Systems

Before her new code can be integrated into the existing, heavily
trusted code base, we have to make **sure** it is of the same quality
as the existing codebase, by adding one or more adequate **tests** to
the systems tests.

#### Automated vs. Manual Tests

Tests are far more effective when the are clearly written down. Even
better written down and automated.

It is inevitable that some tests, at least in certain industries
some tests may have to be conducted manually. Ideally, however you
will try automating tests as close to 100% as possible.

With automated tests it will be common to run a complete suite of
tests for every software change, every fix, every addition of new
code and even a complete test run after removing dead code.

Why not?

Nothing will give a developer more confidence than comprehensive
regression tests that are easy to run and easy to add new tests and
modify existing tests.

Automated tests will most likely provide the ability to run a subset
of test or even pick a single specific test to run.

The key is that a developer is free to run and re-run tests to her
hearts content until she is convinced the code is ready to everybody
else.

But first, it must pass the peer review...


One of the first things that ought to be done, but seldom get the
attention it needs are the specific criteria that must be met to make
the customer/user happy. 

We are going to call this group of criteria the projects **Acceptance
Test**. Ideally all acceptance tests can be automated with software,
however they may be cases that manual intervention is required to
conduct an entire set of Acceptance tests.

## Whitebox vs. Blackbox Testing

My intention here's not to get into a dissertation on testing in test
methodologies. Rather I would like to point out a couple very
important and fundamental types of tests thatMust be conducted.

That includes both white box and blackbox tests. White box tests are
done with access to the internal details of the software, These are
typically represented by unit tests.

Blackbox tests on the other hand no access to the internal structure
of the software. Rather the tests are conducted from a systematic for
external point of view, just as an end user of the software we'll be
expecting this software to behave. 

## Acceptance Tests are Blackbox

The acceptance tests are by definition, what the customer expects the
software to do, and has in effect agreed to be happy with the software
once it passes acceptance tests.

