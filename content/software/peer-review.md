---
title: Peer Reviews
date: 2026-05-21
weight: 60
description: >
  How peer review catches bugs before users do, spreads knowledge across
  the team, and enforces standards — and how to run reviews that improve
  code without damaging the people who wrote it.
---

A peer review is the process of having one or more knowledgeable colleagues
examine your code before it merges into the main branch. It is one of the
highest-leverage practices in software development: bugs found in review cost
a fraction of what they cost after shipping.

Beyond bug catching, review serves two other purposes that are easy to
overlook. It spreads knowledge — the reviewer learns what changed and why,
reducing the bus-factor on any given piece of the codebase. And it enforces
consistency, keeping the code readable to everyone on the team, not just the
person who wrote it.

## Pull Requests

The standard mechanism for peer review is a _Pull Request_ (PR) — called a
_Merge Request_ in GitLab. When a developer finishes a feature branch, she
opens a PR against the main branch. The PR presents the exact diff, a
description of the change, and a thread where reviewers can comment on
specific lines.

A good PR description gives reviewers the context they need:
- What does this change do?
- Why was this approach chosen over alternatives?
- Are there any areas of particular concern or uncertainty?
- How can a reviewer test or verify it locally?

The description is not for the reviewers alone — it becomes part of the
project's permanent history. A well-written PR is worth more than a
well-written commit message because it captures the decision, not just the
outcome.

## What Reviewers Look For

A reviewer's job is not to find something wrong. It is to verify that the
change is correct, maintainable, and consistent with the rest of the system.
In practice that means checking:

- **Correctness** — Does the code do what the PR claims? Are there edge cases
  the author may not have considered? Do the tests cover the meaningful paths?
- **Readability** — Will the next person to touch this code understand it?
  Are names clear? Is the logic straightforward or is it trying to be too clever?
- **Consistency** — Does this follow the conventions already established in
  the codebase? A consistent codebase is easier to navigate than a correct
  one with ten different styles.
- **Test coverage** — New behavior should come with tests. If the tests are
  there, do they actually validate the behavior, or just exercise it?
- **Side effects** — Does this change anything it should not? Database schema,
  API contracts, shared config, performance-sensitive paths?

Not every review needs to check all of these with equal depth. A small bug
fix warrants less scrutiny than a refactor touching shared infrastructure.
Use judgment.

## Giving Feedback

How feedback is framed determines whether review improves the code or just
creates friction. A few principles that hold:

**Comment on the code, not the person.** "This loop will panic on an empty
slice" is useful. "You didn't handle the empty case" creates defensiveness
for no benefit.

**Be specific.** Vague feedback like "this seems off" leaves the author
guessing. Point to the exact line and explain the concern.

**Distinguish blocking issues from suggestions.** Make clear whether a
comment is a required change, a question, or an optional improvement. Mixing
them forces the author to treat everything as blocking or guess which is which.

**Explain the why.** "Use a map here" is less useful than "use a map here
because the current approach is O(n) per lookup and this is called in a
tight loop." The author may have information that changes the recommendation,
and the explanation gives them something to reason against.

**Acknowledge good work.** Review does not have to be a list of problems. If
an approach is clever or a tricky edge case was handled well, say so. It
reinforces good practice and makes the process less adversarial.

## Receiving Feedback

The goal of a review is to make the code better. That is easier to hold onto
when the feedback is well-framed, harder when it is not — but the goal
does not change either way.

Respond to every comment, even if only to acknowledge it. If you agree and
fixed it, say so. If you disagree, explain your reasoning. A reviewer may
have missed context; a short explanation often resolves the disagreement
without any code change. If you are not sure, ask.

Do not take review comments personally. The reviewer is looking at the code,
not evaluating your worth as a developer. The most experienced engineers on
any team still get significant review feedback — that is how it should work.

## Merging

Once all blocking comments are addressed and reviewers have approved, the PR
can be merged. At that point the new tests become part of the permanent test
suite, running on every future change, protecting the feature from regression
indefinitely.

The review thread stays attached to the commit history. Six months later,
when someone wonders why the code works a certain way, that discussion is
still there.
