---
title: "Test-Driven Development When AI Agents Write the Code"
date: 2026-05-22
lastmod: 2026-11-23
weight: 40
description: "Test-driven development for teams using AI coding agents: who owns the acceptance tests, a red/green loop agents can run, and how to review agent-written tests."
tags: ["Testing", "TDD", "Software Engineering", "Acceptance Tests", "AI Agents"]
categories: ["Software Engineering"]
summary: "Test-driven development when AI agents write some of the code: unit, integration, system, and acceptance tests, who owns them, and how to keep an agent from making the code and its tests agree without being right."
---

## For leads

When AI agents write some of your code, tests become the contract they work
to, and the main evidence that their work is right. Require four things:

1. **A person owns the acceptance tests.** An agent can draft them, but if the
   same agent writes the code and the tests that judge it, they can agree with
   each other without either matching what users need.
2. **Evidence that each new test failed first.** It's the cheapest proof that
   a test can detect the behavior it's supposed to check.
3. **Tests get reviewed as carefully as code.** A change that weakens a test
   (a deleted assertion, a skipped case, an edited expected value) is a red
   flag, especially in an agent's pull request.
4. **One command runs the checks.** If the tests are hard to run, agents and
   people will both skip them.

What doesn't change: tests prove the behavior you described, not that you
described the right behavior.

## Tests as the contract

Testing is how a team proves that software still does what it promised
to do. Once a [Kanban card](/software/kanban/) has clear exit criteria, tests
turn that promise into repeatable evidence. Without tests, every release pushes
that responsibility onto the user.

Test-driven development makes that proof part of the design process. It
asks the team to describe the expected behavior before writing the code
that implements it. That discipline is useful because it forces vague
requirements to become observable checks.

## Why This Matters

Software gets harder to change when nobody trusts it. A small edit feels
risky because the team cannot tell whether it broke something in another
part of the system. Releases slow down, bugs reach users, and developers
start protecting fragile code instead of improving it.

A good test suite changes that dynamic. It gives developers a fast signal
while they work, reviewers a concrete way to check behavior, and the
release process a repeatable gate before software reaches users.

The goal is not tests for their own sake. The goal is confidence:
confidence that a requirement is understood, that a change behaves as
intended, and that existing behavior still works.

## The TDD Loop

The classic TDD loop is short:

1. Write a failing test for the behavior you want.
2. Write the smallest code that makes the test pass.
3. Refactor the code while keeping the test passing.

That first step is the important one. A failing test proves that the
behavior is not already present and that the test can detect the missing
behavior. If the test passes before the implementation exists, the test
is not proving what you think it is proving.

TDD is difficult less because of syntax and more because it requires
decision making up front. You have to define the behavior clearly enough
to test it.

### Running the loop with an agent

Agents can run this loop well, and fast, if you give them the command and
make the steps visible:

- **Ask for the failing run first.** Have the agent write the test, run it,
  and show the failure before it writes any implementation. A test that never
  failed hasn't proved anything.
- **Give it one command.** `go test ./...`, `make test`, or the project's
  equivalent, named on the card or in the repository's instruction file.
- **Keep the refactor step honest.** "Refactor while the tests stay green" is
  only safe if nobody edited the tests to stay green. Review test changes in a
  refactor commit with suspicion.

The loop also changes who does what. Writing the failing test is where the
behavior gets decided, so for anything user-facing, that step belongs to a
person, or at least gets a person's review before the agent implements
against it.

## From Use Cases to Tests

Tests should connect back to user value. The path usually looks like
this:

| Artifact | Question it answers |
| --- | --- |
| Use case | What does the user need to accomplish? |
| Requirement | What behavior must the system provide? |
| Acceptance test | How will we know the behavior works? |
| Task | What implementation step should a developer complete? |
| Unit/integration tests | What lower-level checks protect the implementation? |

For example, the garden use case might say:

> As a gardener, I want the system to water a zone when the soil is too
> dry and stop when the soil reaches the target moisture range.

That should become acceptance tests before it becomes a pile of tasks.
The acceptance tests define the observable behavior:

| Given | When | Then |
| --- | --- | --- |
| Soil moisture is above the dry threshold | A reading is processed | The pump remains off |
| Soil moisture falls below the dry threshold | A reading is processed | The pump turns on |
| The pump is on | Soil moisture reaches the damp threshold | The pump turns off |

Those tests create a contract for the implementation. Unit and
integration tests then support that contract at smaller boundaries.

On a mixed team, ownership follows that layering. A person owns the
acceptance tests, because they encode what the user asked for. An agent can
write most of the unit and integration tests beneath them, because those
check how the code does it, and a reviewer can judge them against the
acceptance tests.

See [Use Cases](/software/use-cases/) and
[Use Cases to Tasks](/software/use-cases-to-tasks/) for the planning
side of this workflow.

## Types of Tests

Different tests answer different questions. A healthy test strategy does
not treat every check as the same kind of thing.

### Unit Tests

Unit tests check a small piece of behavior in isolation: a function,
method, parser, validator, calculation, or policy object.

They should be fast, focused, and easy to run while developing. A unit
test should usually make it obvious what broke when it fails.

Good unit test targets include:

- Threshold calculations.
- Input validation.
- Topic parsing.
- Configuration defaults.
- State transitions.
- Error handling branches.

### Integration Tests

Integration tests check that two or more components work together. They
are useful where bugs often appear at boundaries: database access, HTTP
handlers, MQTT clients, file formats, queues, and external APIs.

An integration test might verify that an MQTT message is converted into
a gateway reading or that a REST handler returns the expected JSON shape
from a cache.

These tests are usually slower than unit tests, but they catch failures
unit tests cannot see.

### System Tests

System tests exercise the application from the outside. They treat the
software as a running system and interact through public interfaces.

For an IoT gateway, a system test might publish a fake sensor reading
with `mosquitto_pub`, call the REST API with `curl`, and verify that the
reading appears in the response.

System tests are valuable because they check real wiring: processes,
configuration, protocols, and runtime behavior.

### Acceptance Tests

Acceptance tests define whether the work satisfies the user-facing
requirement. They are written from the outside, in language that a user,
product owner, reviewer, and developer can all understand.

Acceptance tests are the bridge between use cases and release readiness.
Before a feature ships, its acceptance tests should pass without special
manual interpretation.

They're also the tests an agent should be least free to change. If a card's
implementation needs an acceptance test changed, that's a requirements
conversation, not a code change.

## Automated and Manual Tests

Automated tests should do as much of the repeatable work as possible.
They are fast, consistent, and can run on every change.

Manual tests still have a place when the behavior involves physical
systems, unusual hardware, visual judgment, or safety checks. The key is
to make manual tests explicit instead of relying on memory.

A useful rule is:

- Automate checks that are deterministic and repeated often.
- Document manual checks that cannot yet be automated.
- Keep reducing the manual portion as the system matures.

Documented manual checks matter more with agents on the team. An agent can
run every automated check and report them green; it can't do the bench test
with the real pump. Listing the manual checks on the card (the "needs a
person" part) keeps "all tests pass" from being read as "done".

## What a Good Test Suite Provides

A good test suite should be:

- **Repeatable**: the same input produces the same result.
- **Fast enough**: developers can run the relevant tests frequently.
- **Selective**: one package, component, or scenario can be run alone.
- **Layered**: unit, integration, system, and acceptance tests each have
  a clear purpose.
- **Visible**: failures produce actionable output in local development
  and CI.
- **Connected to requirements**: acceptance tests trace back to use
  cases and release criteria.

Tests should make change easier. If tests are slow, brittle, vague, or
unrelated to real behavior, they become another maintenance burden.

## Common Pitfalls

### Testing Implementation Instead of Behavior

Tests that know too much about private implementation details fail every
time the code is refactored. Prefer testing observable behavior at the
right boundary.

### Writing Tests After the Code and Calling It TDD

Tests written afterward can still be valuable, but they do not provide
the same design pressure. TDD means the test shapes the implementation.

### Mocking Everything

Mocks are useful, but excessive mocking can create tests that only prove
that mocks were called. Use mocks at true external boundaries and keep
important behavior covered by real unit or integration tests.

### No Acceptance Tests

A project can have many unit tests and still fail the user. Acceptance
tests keep the team honest about the actual promise made by the use
case.

### Tests That Are Hard to Run

If tests require hidden setup, special machines, or tribal knowledge,
developers will run them less often, and agents may not run them at all.
Make the common path boring: `make test`, `go test ./...`, or the closest
equivalent for the project.

### Tests That Echo the Implementation

Agent-written tests sometimes restate the code instead of checking behavior:
they compute the expected value the same way the implementation does, so they
can't disagree with it. Check that a test's expected values come from the
requirement, such as a worked example or a known input and output, not from
the code under test.

### Changing the Test to Make It Pass

When a test fails, the right fix is usually in the code. An agent under
instruction to "make the tests pass" can sometimes reach green by weakening
the test instead: deleting an assertion, skipping a case, or editing the
expected value. Treat any test change in a pull request as something to read
closely, and say in the repository's instructions that existing tests may not
be weakened without a person's approval.

## TDD and Release Confidence

Testing is part of the release process, not a separate ritual. A release
pipeline should run the checks that prove the build is ready: unit tests,
integration tests, static checks, and acceptance tests appropriate to the
system.

When those checks are reliable, releases become less dramatic. The team
can ship smaller changes more often because each change passes through
the same evidence-producing path.

See [Release Process](/software/release-process/) for how tests fit into
versioning, CI/CD, deployment, and rollback planning, including the
[release gates for AI-written code](/software/release-process/#release-gates-when-ai-writes-the-code).
A passing suite is evidence about the behavior you tested; it doesn't decide
whether you built the right thing.

## Practical Checklist

Before implementing a feature, ask:

- What use case does this support?
- What observable behavior proves the requirement works?
- What acceptance test should pass before this ships?
- Which unit tests protect the core logic?
- Which integration tests protect the important boundaries?
- Which system test proves the pieces work together?
- Where will these tests run in CI before release?
- Who owns the acceptance tests, and has a person reviewed them?
- Did each new test fail before the implementation existed?
- Does the pull request change any existing test, and if so, why?

A good answer to those questions turns testing from an afterthought into
an engineering control system.

## Where This Fits

This page is the fourth step in the delivery series:

- Before: [Use Cases](/software/use-cases/) and
  [From Use Cases to Task Cards an AI Agent Can Execute](/software/use-cases-to-tasks/)
  define the behavior and slice it into cards.
- Previous: [Organizing Tasks with Kanban When AI Agents Do Some of the Work](/software/kanban/)
  runs those cards with checkable exit criteria.
- Next: [Version Control Systems](/software/version-control-systems/) keeps each
  change small and reviewable.
- Then: [Peer Reviews](/software/peer-review/) and the
  [Release Process](/software/release-process/) use these tests as evidence.
