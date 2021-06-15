---
title: Testing Software
date: 2019-05-04
weight: 60
description: >
  Testing software is pretty self explanatory, it seems. The technical
  details are many, more important are the positive ramifications
  throughout the project as it evolves are profound. Let me explain why ...
---

## Testing Unit and Systems

Before our developers new code can be integrated into the existing
production code base it must be _tested_ and _vetted_.

Software Testing has been written about extensively so I won't spend
time here discussing testing directly as there are as many ways to
test software as there are technologies.

## Test Driven Development (TDD)

I do support the notion of _Test Driven Development (TDD)_ which I
frequently do _not_ adhere to out of laziness, haste or carelessness
(I know sad but I'm just being honest here).

> TODO Reference to TDD

Testing movements can be taken to far, for example spending a lot of
time writing tests that are effectively worthless just for the sake of
writing a test.

However, testing is critical and we *must* find a good
balance. Following are some general points that a good set of tests
provide: 

- Tests must cover all features and bug code changes
- Tests must be 100% repeatable
- Tests should automated 100% if possible
- Tests should combine _white_ and _black_ box testing
- Tests should be easy to run selectively
- Tests should produce nice reports

Faithfully writting tests for new features and regression test for bug
fixes contributes over time to a increasingly stable code base.

### Testing Builds Confidence

As the software project evolves overtime, the developers and users
gain two very important things, in addition to the obvious benefit of
working software, everybody gains:

1. Confidence to the point of taking the software for granted, they
begin to rely on the software without even realizing it.

2. Operational problems become rare because most issue are caught and
fixed in a lab or a _controlled_ system on the client site.

3. When problems do occur they are typically resolved very
quickly. One by product of stable, well tested software is how easy
they are to troubleshoot.

## Automated vs. Manual Tests

Tests are far more effective when the are clearly written down. Even
better, written down AND automated. 

It is inevitable that some tests, at least in certain industries may
have to be conducted manually. Like making sure a robot hand does not
break a glass bottle, for example.  Ideally however, you will try
automating tests as close to 100% of our tests as possible.

### Complete Test Runs ALL the Time

With automated tests it will be common to run a complete suite of
tests for every software change, every fix, every addition of new
code and even a complete test run after removing dead code.

Why not?

Nothing will give a developer more confidence than comprehensive
regression tests that are easy to run and easy to add new tests and
modify existing ones.

Automated tests will most likely provide the ability to run a subset
of test or even pick a single specific one to run.

_The key is_ a developer is free to run and re-run tests to her hearts
content until she is convinced the code is ready for everybody else.

## Whitebox vs. Blackbox Testing

### Whitebox Testing

_White Box_ testing means the _test function_ has _internal_ access to
the the actual code being tested. In otherwords, the code can directly
call any internal function or examing internal data structures.

> _Unit Testing_ is a standard form of _Whitebox Test_.

Other _whitebox_ tests may include performance and stress tests.

### Black Box Testing

Blackbox tests have _no access or knoweledge_ of any _internal_
functions or data structures, other than the applications "Public
Interface".

> _System Tests_ are a standard form of _Blackbox Testing_

Other _blackbox_ tests may also include performance and stress tests.

## Acceptance Tests ~ Pass without Fail

Acceptance test is the term we will use for our _final system tests_. 
The tests that validate the _delivery agreement_ between _development_
and _client_.

Before any _release_ passes to a customer, the entire suite of
_Acceptance Tests_ must **pass without fail**.

Acceptance tests are _System Tests_ in that they will often involved
co-ordination among two or more _sub-systems_ or _micro-services_ as
we like to call them now.  For example, a database and inputs from a
sensor are two _sub-systems_ that are frequently found in _embedded_
and _IoT_ style software projects.


## Acceptance Tests are Blackbox

The acceptance tests are by definition what the customer expects the
software to do, and has in effect agreed to be happy with, the software
once it passes acceptance tests.

