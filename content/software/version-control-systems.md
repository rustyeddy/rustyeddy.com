---
title: "Version Control Systems"
date: 2026-05-22
weight: 30
description: >
  Git, branching strategies, tags, pull requests, and commit discipline:
  how a version control system becomes the source of truth for a software
  project.
tags: ["Git", "Version Control", "Software Engineering", "Pull Requests"]
categories: ["Software Engineering"]
summary: "A practical guide to using Git history, branches, pull requests, and tags as the permanent record of a software project."
---

The first sign of an undisciplined software project is source code managed
as a folder of files, with copies passed around by email or shared drives.
The inevitable question, "which copy has your changes?", points to a deeper
problem: there is no authoritative record of what the software is, what
changed, or why.

## Why This Matters

Version control is the permanent record of a software project. It explains what
changed, why it changed, who reviewed it, and which version shipped. Without
that history, testing, review, release, and rollback all get weaker.

A version control system solves that. Every meaningful change is recorded
with who made it, when it happened, and why it happened. The repository
becomes the permanent history of the project.

## Git

Git is the de facto standard for version control. It was created by Linus
Torvalds to manage the Linux kernel, a project with thousands of contributors
making changes at the same time. The same distributed model works well for a
solo project, a small team, or a large organization.

The core concepts are:

- **Repository**: the database of project history.
- **Commit**: a snapshot of the codebase at a point in time.
- **Branch**: a line of development that can move independently.
- **Merge**: integrating one branch into another.
- **Tag**: a fixed name for a specific commit, usually a release.

Used well, Git is more than backup. It is the project memory.

## Hosting Services

A remote hosting service adds collaboration, backup, review, and automation
on top of Git.

GitHub and GitLab are the dominant options. Both provide remote repositories,
issues, pull or merge requests, CI/CD pipelines, and project boards. Bitbucket
is also common, especially in teams already using Atlassian tools.

The hosting service is where version control connects to the rest of the
engineering workflow: review, test automation, release tags, and deployment.

## Commits

A commit is the atomic unit of change. It should represent one logical edit:
a bug fix, feature addition, refactor, documentation update, or configuration
change.

Good commits are small enough to review and specific enough to understand.
The message should explain intent, not repeat the diff.

A useful commit message looks like this:

```text
Add soil moisture threshold configuration

Previously the dry and damp thresholds were hard-coded constants.
This commit reads them from the config file at startup, allowing
per-station tuning without a recompile.
```

The first line summarizes the change. The body explains why it was made and
what decision it records. Six months later, that context matters more than
the mechanics of the diff.

A repository with well-written commits is a project diary. A repository full
of `fix`, `wip`, and `update stuff` is hard to trust.

## Branches

The main branch, usually `main` or `master`, should stay releasable. Work
should happen on short-lived branches and merge back after review and checks
pass.

Feature branches are the common pattern:

1. Create a branch for one focused task.
2. Make small commits while developing.
3. Push the branch to the remote.
4. Open a pull request.
5. Let CI run.
6. Address review comments.
7. Merge after approval.
8. Delete the branch.

Branch names should describe the work. `add-moisture-threshold-config` is
more useful than `feature-1`.

Trunk-based development is another option. Developers integrate into main
frequently, often using feature flags to keep incomplete work inactive. It
requires strong CI discipline, but it reduces the integration pain created by
long-lived branches.

For many small teams, short-lived feature branches are a practical middle
ground.

## Pull Requests

A pull request connects version control to peer review. It gives reviewers a
diff, a description, test results, and a discussion thread.

A good pull request should answer:

- What changed?
- Why did it change?
- How was it tested?
- What should reviewers inspect closely?
- Does it affect APIs, data, configuration, or deployment?

The pull request becomes part of the project history. It explains the
conversation around the change, while the commit records the final result.

See [Peer Reviews](/software/peer-review/) for the review process around pull
requests.

## Tags

A tag marks a specific commit as significant. Releases should be tagged.
Unlike a branch, a tag does not move.

```bash
git tag -a v1.2.0 -m "Release v1.2.0"
git push origin v1.2.0
```

Tagging every release means a past version can be checked out and reproduced.
It also gives changelogs, release notes, deployment artifacts, and rollback
procedures a stable anchor.

See [Release Process](/software/release-process/) for how tags fit into
versioning and deployment.

## Branch and PR Checklist

A small team can keep the workflow simple:

- Create one branch per coherent task.
- Keep the branch short-lived.
- Commit small logical changes.
- Write commit messages with intent.
- Push the branch and open a pull request.
- Include a clear PR description and test notes.
- Wait for CI to pass.
- Resolve blocking review comments.
- Merge with a clean history.
- Tag releases from known-good commits.

The exact Git commands matter less than the discipline: small changes,
visible review, passing checks, and reproducible releases.

## Common Pitfalls

### Huge Commits

Huge commits are hard to review, hard to revert, and hard to understand
later. Split work into logical changes that tell a clear story.

### Long-Lived Branches

A branch that lives for weeks drifts away from main. The longer it lives, the
harder it is to merge and the more likely it is to hide integration problems.

### No Tags

Skipping release tags makes rollback and reproduction harder. If a version
was shipped, the commit should be named.

### Commit Messages Without Intent

Messages like `fix`, `changes`, and `stuff` do not help future maintainers.
The message should explain why the change exists.

### Mixing Unrelated Work

A formatting cleanup, feature change, and bug fix in the same commit make the
history noisy. Keep unrelated edits separate.

## The Commit History as Documentation

Used well, commit history is the most accurate documentation a project has.
When you need to understand why a piece of code exists, `git log` and
`git blame` are often the first tools to use.

That only works if the history is readable. Small commits, clear messages,
short-lived branches, pull requests, and release tags turn version control
into a communication system for everyone who will work on the project later.

## Where This Fits

Version control supports the whole delivery workflow. It gives [Kanban](/software/kanban/)
work a durable history, gives [Peer Reviews](/software/peer-review/) something
specific to inspect, and gives the [Release Process](/software/release-process/)
a reproducible source of truth.
