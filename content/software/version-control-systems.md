---
title: Version Control Systems
date: 2026-05-22
weight: 30
description: >
  Git, branching strategies, and commit discipline — how a version control
  system becomes the single source of truth and the permanent record of
  every decision made during a project's life.
---

The first sign of an undisciplined software project is source code managed
as a folder of files, with copies passed around by email or shared drives.
The inevitable question — *which copy has your changes?* — is a symptom of
a deeper problem: there is no authoritative record of what the software is,
what changed, or why.

A version control system solves this. Every change is recorded with who made
it, when, and a description of why. The full history of the project lives in
the repository, reproducible at any point in time.

## Git

Git is the de facto standard for version control. It was created by Linus
Torvalds to manage the Linux kernel — a project with thousands of
contributors making changes simultaneously — and its distributed architecture
scales equally well to a solo project.

The core concepts are simple:

- **Repository** — the database of all changes, stored in the project directory
- **Commit** — a snapshot of the codebase at a point in time, with a message
  describing the change
- **Branch** — a parallel line of development that diverges from the main history
- **Merge** — integrating one branch back into another

## Hosting Services

A remote hosting service adds collaboration, backup, and CI/CD integration
on top of git.

**GitHub** and **GitLab** are the dominant options. Both offer issue
tracking, pull/merge requests, CI/CD pipelines, and project boards. GitHub
has a larger open source community; GitLab's CI/CD is more fully integrated
out of the box. Both offer free tiers that include unlimited private
repositories.

**Bitbucket** is a solid alternative, particularly for teams already using
Atlassian tools (Jira, Confluence).

## Commits

A commit is the atomic unit of change. Every commit should represent one
logical change — a bug fix, a feature addition, a refactor — not a dump of
a week's work.

Commit message discipline matters more than most teams acknowledge. The
subject line should complete the sentence *"If applied, this commit will..."*
A good message is:

```
Add soil moisture threshold configuration

Previously the dry and damp thresholds were hard-coded constants.
This commit reads them from the config file at startup, allowing
per-station tuning without a recompile.
```

The first line is the summary — keep it under 72 characters. The body
explains *why* the change was made, not *what* it does (the diff shows
what). Six months later, when someone needs to understand why the code works
a certain way, that explanation is what matters.

A repository with well-written commit messages is a project diary. A
repository full of "fix", "wip", and "update stuff" is archaeology.

## Branching

The main branch (typically `main` or `master`) should always be in a
releasable state. Work happens on branches.

**Feature branches** are the standard pattern: create a branch for each
task, develop on it, open a pull request when done, merge after review and
CI passes. The branch name should reflect the work: `add-moisture-threshold-config`
is more useful than `feature-1`.

**Trunk-based development** is an alternative where developers integrate to
main frequently — daily or more — using short-lived branches or feature
flags to keep unfinished work inert. It requires strong CI discipline but
reduces the integration pain that accumulates on long-running branches.

For small teams, feature branches with short lifetimes (one to three days)
capture most of the benefit of both approaches.

## Tags

A tag marks a specific commit as significant — typically a release. Unlike
a branch, a tag does not move.

```
git tag v1.2.0
git push origin v1.2.0
```

Tagging every release means any past version can be checked out and
reproduced exactly. It also provides a clean anchor for changelogs and
release notes. Skipping tags is a habit that feels harmless until you need
to reproduce a build from eight months ago.

## The Commit History as Documentation

Used well, the commit history is the most accurate documentation a project
has — more current than any wiki, more honest than any architecture document.
When you need to understand why a piece of code exists, `git log` and
`git blame` are the first tools to reach for.

This only holds if commits are small, frequent, and well-described. A
disciplined commit history is a communication tool for everyone who will
ever work on the project — including yourself, six months from now.
