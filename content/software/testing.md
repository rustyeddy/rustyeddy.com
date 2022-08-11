---
title: Improving Quality by Testing Software
date: 2019-05-04
weight: 60
description: >
  Developers when programming use VCS to create a temporary private
  branch to work from to avoid negatively effecting others while
  changing code. The developer and rest of the team rely on Software
  Testing to ensure new and changed code does what is required of it,
  and the new code MUST NOT break existing functionality. Getting
  testing right has many profound positive effects on the project, let
  me explain.
---

## Testing Unit and Systems

Before any developers new code can be integrated into the _mainline_ 
production code base, it must be _tested_, _vetted_ and _peer
reviewed_. 

Software Testing has been written about extensively, so I won't spend
time here discussing testing directly, as there are as many ways to
test software as there are technologies.

### Test Driven Development

_Test Driven Development (TDD)_ a _principal_ for which I agree is necessary, but I don't _always_ adhere to in practice. This is  usually out of
laziness, haste or carelessness (I know sad but I'm just being honest
here). However, it is worth paying attention to...

Anyways, the basic rules are:

1. Write your test **before** writing the code
2. The test **will fail** initially
3. It is the _programmers_ job to write code such that the test will pass.

Brilliant!

That is hard to argue with. However, taking the upfront time to build
the tests before just hammering out the code, is much harder to do than
say.

## TDD is hard, not technically, but emotionally

The hard part about writing _tests_ upfront is that it forces us to
_really_ define what we are building.  You have to _drill down_ a
level or two.

> When defining tests, ask the "Five whys?"

Once you have done the hard brain work and exposed the applications,
**true requirements** implementing the test becomes striaght forward.

> TODO Reference to TDD

Testing movements can be taken too far, for example spending a lot of
time writing tests that are effectively worthless just for the sake of
writing a test.

However, testing is critical and we *must* find a good
balance. The following are some general points that a good set of tests
provide: 

- Tests must cover all features and bug code changes
- Tests must be 100% repeatable
- Tests should be automated 100%, if possible
- Tests should combine _white_ and _black_ box testing
- Tests should be easy to run selectively
- Tests should produce nice reports

Faithfully writing tests along with new code contributes over time to
a increasingly stable code base.  

### Testing Builds Confidence

As software projects evolve over time, developers and users gain
benefits beyond just _stable software_ including:

1. Confidence to the point of taking the software for granted. They then
begin to rely on the software without even realizing it.

2. Operational problems become rare because most issue are caught and
fixed in a lab or a _controlled_ system on the client site.

3. When problems do occur they are typically resolved very
quickly. Stable products tend to be well documented, as well as having meaningful
logs and great support tools.

4. Software Development Becomes Faster

The test environment creates a _factory_ for producing well machined
software.

> High quality code can be developed and released quickly, with little
  risk of new failures.

A good test rig will allow the developer to easily run selective tests
from the _developers development process (REPL)_. The result is a much
higher rate of software delivery without an increase in error rates.

## Automated vs. Manual Tests

Tests are far more effective when they are clearly written down. Even
better, written down AND automated. 

It is inevitable that some tests, at least in certain industries, may
have to be conducted manually. For example, making sure a robot hand does not
break a glass bottle.  Ideally however, you will try
automating tests as close to 100% as possible.

### Complete Test Runs ALL the Time

With automated tests it is easy to run a complete suite of
tests for every software change and addition of new code.

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
call any internal function or examine internal data structures.

> _Unit Testing_ is a standard form of _Whitebox Test_.

Other _whitebox_ tests may include performance and stress tests.

### Black Box Testing

Blackbox tests have _no access or knoweledge_ of any _internal_
functions or data structures, other than the applications "Application
Programming Interface".

> _System Tests_ are a standard form of _Blackbox Testing_

Other _blackbox_ tests may also include performance and stress tests.

## Acceptance Tests ~ Pass without Fail

Acceptance test is the term we will use for our _final system tests_. 
The tests that validate the _delivery agreement_ between _development_
and _client_.

Before any _release_ passes to a customer, the entire suite of
_Acceptance Tests_ must **pass without fail**.

Acceptance tests are _System Tests_ in that they will often involve
co-ordination among two or more _sub-systems_ or _micro-services_, as
we like to call them now.  For example, a database and inputs from a
sensor are two _sub-systems_ that are frequently found in _embedded_
and _IoT_ style software projects.

