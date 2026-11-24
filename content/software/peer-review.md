---
title: "Peer Review When AI Agents Write Some of the Code"
date: 2026-05-21
lastmod: 2026-11-23
weight: 60
description: "Code review for teams using AI coding agents: independent review, what to check in an agent's pull request, recorded approvals, and a human merge."
tags: ["Peer Review", "Pull Requests", "Software Engineering", "Code Review", "AI Agents"]
categories: ["Software Engineering"]
summary: "A practical guide to code review when AI agents write some of the code: what authors prepare, what reviewers check, how to review an agent's pull request, and why the review has to be independent and recorded."
---

## For leads

When AI agents write some of your code, review is the gate that decides what
reaches production. Require five things:

1. **Independent review.** The author never certifies its own work. That
   applies to an agent reviewing its own change, and to a person approving
   code they asked an agent to write without reading it.
2. **A named person approves the merge.** Agents can draft and review. A
   person decides what merges.
3. **Review capacity is the limit.** Agents produce changes faster than people
   can review them well. Cap the queue, not just the work in progress.
4. **Reviews are recorded and attributed.** A review that isn't written down
   looks the same, later, as no review at all.
5. **Comments are resolved before merge.** Turn on the branch-protection
   setting that blocks merging with unresolved conversations.

What doesn't change: review exists to catch mistakes while they're cheap, and
to spread context across the team.

## What peer review is

Peer review is the practice of having another engineer inspect a change
before it merges into the main branch. It comes after a focused task has been
implemented and [tested](/software/test-driven-software-development/), but
before the change becomes part of the release path. It is one of the
highest-leverage quality controls in software development because it catches
mistakes while they are still cheap to fix.

## Why This Matters

Peer review is one of the cheapest places to catch design, behavior, and
maintainability problems. It also spreads context so the codebase does not depend
on one person's memory.

A good review does more than find bugs. It spreads knowledge, keeps the
codebase consistent, and makes sure the change fits the system the team is
actually maintaining.

## Purpose

Peer review should answer a few concrete questions:

- Does the change solve the stated problem?
- Is the behavior covered by the right tests?
- Does it fit the existing architecture and style?
- Does it change public contracts, data, configuration, or operations?
- Can another engineer maintain this code later?
- Does it stay within the scope of the card it was written for?

Review is not a ceremony and it is not a personality test. It is a shared
engineering checkpoint before code becomes part of the permanent system.

## Pull Requests

The common review mechanism is a pull request. A pull request gives the
reviewer a diff, a description, test results, and a place to discuss
specific lines.

A good pull request description explains:

- What changed.
- Why the change was made.
- What alternatives were considered, if relevant.
- How the change was tested.
- Any risky areas the reviewer should inspect closely.
- Who or what drafted it: a person, an agent, or both.

That last line matters more than it looks. On a team where agents commit
under a person's account, the history can't otherwise tell which changes a
person wrote and which they only asked for.

The description matters because it becomes part of the project history.
Six months later, the pull request often explains the decision better than
the final code alone.

## Author Responsibilities

The author is responsible for making the review possible.

Before requesting review, the author should:

- Keep the pull request focused on one coherent change.
- Rebase or merge the target branch if the diff is stale.
- Run the relevant tests and checks locally.
- Explain the problem and the chosen solution.
- Call out tradeoffs, skipped work, or known limitations.
- Add tests for new behavior or explain why tests are not appropriate.
- Remove debugging output, temporary comments, and unrelated formatting
  churn.

A reviewer should not have to reverse-engineer the intent from the diff.
Context is part of the author's job.

When an agent drafts the change, the person who assigned the card is still
the accountable author. The agent should run the checks and report the
results in the description, including anything it couldn't verify. A good
agent pull request says "I couldn't reach X, so Y is unchecked" instead of
quietly guessing.

## Reviewer Responsibilities

The reviewer is responsible for judging the change, not rewriting it from
scratch.

A reviewer should check:

- **Correctness**: does the code do what the pull request claims?
- **Behavior**: are edge cases, errors, and user-visible outcomes handled?
- **Tests**: do the tests prove the important behavior?
- **Design**: does the change fit the existing architecture?
- **Maintainability**: will the next engineer understand this code?
- **Contracts**: does it alter APIs, schemas, config, files, or commands?
- **Operations**: does it affect deployment, performance, logging, or
  rollback?

The reviewer should separate blocking issues from questions and optional
suggestions. A small naming suggestion should not carry the same weight as
a data-loss bug.

## Reviewing a Change an Agent Wrote

Agent-written changes fail in recognizable ways. Check for these on top of
the usual list:

- **Scope drift.** The card asked for one function; the diff also refactors
  a neighbor "while it was there." Ask for the extra work as its own change.
- **Plausible but wrong.** The code reads well and compiles, but calls an API
  that doesn't exist, misreads a requirement, or handles the common case and
  silently skips the edge case the card named.
- **Tests that agree with the code instead of checking it.** Expected values
  computed the way the implementation computes them, or an existing test
  weakened to reach green. See
  [Test-Driven Development When AI Agents Write the Code](/software/test-driven-software-development/).
- **Claims about outside systems.** Documentation, library behavior, version
  numbers. Check them against the primary source, not against what sounds
  right.

That last check cuts both ways. While this site was being rewritten, a
reviewer flagged a claim about how Claude Code reads `AGENTS.md` as wrong. A
second reviewer said it was right. The official documentation settled it: the
drafter had been right all along, and the first reviewer had checked against
an outdated copy of the page. The lesson isn't "trust the reviewer" or "trust
the author." It's that disagreements get settled by the source, and a
reviewer can be wrong too.

## Independent Review

"Independent" means the reviewer didn't write the change and isn't simply
trusting the author's account of it.

- **A person** is the strongest independent reviewer for anything that
  matters, and a person approves every merge.
- **A different model, or a fresh agent without the drafter's context,** is a
  useful additional reviewer. It's fast and it catches a different set of
  mistakes. Agents from the same model family can share blind spots, so for
  high-stakes changes, mix models or add a person.
- **The drafting agent reviewing its own work** isn't review. Self-checks are
  useful before asking for review; they don't replace it.

## Giving Useful Feedback

Good review feedback is specific and actionable.

Prefer this:

> This handler returns `200` even when validation fails. Should this return
> `400` so clients can distinguish bad input from success?

Over this:

> This seems wrong.

Useful comments usually include the concern, the impact, and the requested
change or question. If the issue is blocking, say so clearly. If it is a
minor suggestion, label it that way.

Feedback should focus on the code and the system. The goal is to improve the
change, not to score points in the review thread.

## Responding to Review

The author should respond to every review comment. That response can be a
code change, a clarification, or a reasoned disagreement.

Good responses are short and explicit:

- `Fixed in the latest push.`
- `Added a regression test for this path.`
- `Good catch, this should return 400.`
- `I left this as-is because the caller already normalizes the value here.`

If a disagreement reveals a larger design question, move the discussion out
of line comments and resolve the decision directly. Review threads are good
for focused comments, but they are a poor place for open-ended design debate.

Make the review visible, too. On GitHub an author can't approve their own pull
request, so if agents open pull requests under your account, your review can
only be recorded as a comment. Leave one anyway, even a single line, so the
history shows the change was checked and by whom.

## Pull Request Checklist

Before merge, a practical checklist should be boring:

- The pull request has a clear description.
- The change is scoped to one problem.
- Required tests pass.
- New behavior has tests or documented manual verification.
- Public API, schema, configuration, or command changes are called out.
- Documentation or examples are updated when behavior changes.
- The release or rollback impact is understood.
- Blocking review comments are resolved, and the branch settings enforce it.
- At least one independent reviewer has approved, and the review is recorded.
- The description says who or what drafted the change.
- A person made the merge decision.

The checklist is not a substitute for judgment. It is a guardrail against
forgetting common failure modes.

## Common Pitfalls

### Review as Gatekeeping

Review should protect the codebase, not establish dominance. If every review
feels adversarial, authors will hide risk and reviewers will focus on winning
arguments instead of improving the software.

### Giant Pull Requests

Large pull requests are slow to review and easy to misunderstand. They also
encourage shallow approval because reviewing them properly is exhausting.
Slice work into smaller changes whenever possible.

### Style Bikeshedding

Style consistency matters, but style debates should be automated or settled
in a project convention. Review time is better spent on correctness,
behavior, design, and risk.

### Vague Comments

Comments like `clean this up` or `this feels weird` do not give the author a
clear path forward. Explain the specific concern and what would resolve it.

### Approving Without Running or Reading

Approval means the reviewer has done enough work to stand behind the change.
For risky code, that may include pulling the branch, running tests, or trying
the workflow manually.

### Approving Because the Tests Pass

Green checks are evidence about the behavior the tests cover, nothing more.
For an agent's change in particular, read the diff, including any changes to
the tests.

### Merging With Unresolved Comments

It's easy to approve, merge, and forget that a review comment asked for a
change. On this site a pull request once merged with two inline comments
unapplied, and the fix had to follow in a second pull request
([#232](https://github.com/rustyeddy/rustyeddy.com/pull/232)). GitHub's
"require conversation resolution before merging" setting prevents it.

### Unrecorded Reviews

A review done in your head, or in a chat with the author, leaves no trace.
Six months later nobody can tell a reviewed change from an unreviewed one.

## Where This Fits

This page is the sixth step in the delivery series. Peer review sits between
implementation and release.

- Previous: [Version Control Systems](/software/version-control-systems/)
  explains the branch and history practices that make review possible.
- Earlier: [Test-Driven Development When AI Agents Write the Code](/software/test-driven-software-development/)
  explains how tests give reviewers something concrete to verify, and
  [Organizing Tasks with Kanban When AI Agents Do Some of the Work](/software/kanban/)
  puts a review gate on the board.
- Next: [Software Release Process](/software/release-process/) explains how
  reviewed and tested changes become a shipped artifact.
