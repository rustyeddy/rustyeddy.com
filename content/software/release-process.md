---
title: "Software Release Process: A Checklist for Small Teams"
date: 2026-05-21
weight: 100
description: >
  A repeatable release process for small teams: versioning, automated
  gates, independent review, smoke tests, and rollback, and why the gates
  matter more when AI writes the code.
tags: ["Release Process", "CI/CD", "Software Engineering", "AI Agents", "ADR"]
categories: ["Software Engineering"]
summary: "A practical release process for small teams, a real versioning decision that changed and why, and how release gates have to change when AI agents write much of the code."
---

A release is the moment development work becomes user value. Everything
before it, including [use cases](/software/use-cases/),
[tests](/software/test-driven-software-development/), and
[peer review](/software/peer-review/), is preparation. The release process
decides whether that preparation becomes a calm handoff or a production
incident.

The goal is to make releases routine: a repeatable sequence of gates,
artifacts, deployment, verification, and rollback. If a release depends on
memory and luck, it is not yet a process.

This article covers the essentials, then two things most checklists leave
out: how a real project changed its mind about versioning, and what has to
change when AI agents write a large share of the code.

## Why This Matters

AI tools have made code cheap to produce. They haven't made it cheap to
ship safely. When a team can open ten pull requests in the time it used to
take to write one, the release process is no longer paperwork at the end.
It's the main thing standing between fast output and broken production.

A good release process answers practical questions every time:

- What version are we shipping, and which commit produced it?
- Which checks passed, and who reviewed it?
- What artifact was deployed?
- How do we know the deployment worked?
- What do we do if it didn't?

## The Pipeline

![A pull request passes an automated gate and an independent review at an exact commit, a human merges, the commit is tagged, built once with the version from the tag, deployed, and smoke tested, with failures sent back to the pull request or rolled back to the previous artifact](/diagrams/release-pipeline-gates.svg)

Every stage is a gate. If a required stage fails, the release stops. A
pipeline is useful precisely because it is harder to bypass by accident
than a checklist in someone's head.

### Versioning

Every release needs a version. Semantic versioning (`MAJOR.MINOR.PATCH`)
is the common convention: a patch is a backward-compatible fix, a minor
release adds backward-compatible features, and a major release breaks
something. The exact convention matters less than consistency, but semver
is useful because it communicates intent.

Git tags anchor versions to exact commits:

```bash
git tag v2.4.1
git push origin v2.4.1
```

Without tags, reproducing an old release becomes guesswork.

### Artifacts

The artifact is the thing you actually ship: a binary, container image,
static site, firmware image, or app bundle. It should be:

- built by the pipeline, never by hand on a developer's machine;
- identified by version and commit;
- stored somewhere durable;
- **built once and promoted** between environments, with
  environment-specific values in configuration.

If staging and production are built separately, you haven't proven that
the production artifact is the one you tested.

### Smoke tests

Smoke tests are quick checks after deployment that prove the release is
alive: the health check responds, the reported version matches the one you
meant to ship, a key page or endpoint works, and logs and metrics are
arriving. They don't replace the test suite. They answer a smaller
question: did the deployed system come up correctly?

### Rollback

Rollback is not something to improvise during an incident. Know the path
before the release starts: redeploy the previous artifact, shift traffic
back, boot from a known-good firmware partition, or stop a staged rollout.

Database changes deserve special caution. A code rollback is easy only if
the old code can still read the new data. Plan migrations so old and new
code can run side by side during the transition.

## A Versioning Decision That Changed

Here is a real example of how even a "simple" release decision can turn
out to be wrong, and why writing the decision down made fixing it cheap.

[Trader](/projects/trader/), my FX backtesting engine, records its
architecture decisions as numbered ADRs.

**The first decision (ADR-046):** the version would live in a single Go
constant, bumped by hand in its own commit right before each release tag.
The ADR explicitly considered deriving the version from `git describe` at
build time, and rejected it, because that would make the current version
depend on local tag state rather than being reviewable in the source.
That's a reasonable position. A one-line diff is easy to review, and the
tagged commit can't disagree with the binary.

**What changed (ADR-064):** a later issue asked for exactly the opposite:
developers should not have to edit a version constant every time a release
is tagged, and no manual source-version bump should be needed just because
a tag was created. ADR-064 reversed the
decision and derives the version from the tag at build time:

```bash
git describe --tags --match 'v[0-9]*.[0-9]*.[0-9]*' --always --dirty
```

That produces `v0.3.0` at a clean tag, `v0.3.0-12-gabc1234` twelve commits
later, a `-dirty` suffix for uncommitted changes, and a bare commit hash
before the first release. Cutting a release became: tag the commit on `main`,
push the tag, and create the GitHub release from it.

Review caught two real problems before the change merged, and the ADR
records both:

- **The `--match` filter.** A bare `--tags` considers every tag in the
  repository, so an unrelated future tag like `research-2026-09` could have
  become Trader's reported version.
- **Package placement.** The first implementation put the version package
  under `internal/`, which made it unimportable by the rest of the codebase
  and contradicted the ADR's own goal of a reusable version API.

Two lessons carry over to any team:

1. **Both decisions were defensible.** The first one wasn't a mistake; it
   optimized for reviewability. The second optimized for zero manual steps.
   What changed was the evidence, not the competence.
2. **The written record made the reversal cheap.** ADR-064 could name
   exactly which parts of ADR-046 it replaced and why. The original was
   marked *superseded* but left intact, so the history still explains how
   the project got here.

The full records are in
[ADR-046](https://github.com/rustyeddy/trader/blob/f9917940d4e18b38f15607443f1793f1f06bd736/docs/arch/adr-046-semantic-versioning-release-process.org)
and
[ADR-064](https://github.com/rustyeddy/trader/blob/f9917940d4e18b38f15607443f1793f1f06bd736/docs/arch/adr-064-git-describe-version-metadata.org).

## Release Gates When AI Writes the Code

When agents write a large share of the code, the volume and speed of
changes go up and the author can no longer be the main safeguard. The gates
have to carry more of the load. Four practices matter most.

### One gate, run everywhere

Trader has a single `make check` target that runs the same steps in the
same order as CI: module tidiness, formatting, `go vet`, lint, tests, and
the race detector. The linter version is pinned so every contributor, human
or agent, gets identical results. An agent can run the exact gate locally
before it ever opens a pull request, and "it passed for me" means the same
thing it means in CI.

### Independent review, at an exact commit

Trader's [review workflow](https://github.com/rustyeddy/trader/blob/f9917940d4e18b38f15607443f1793f1f06bd736/docs/review-automation.org)
separates the roles: one agent implements, an independent reviewer checks
the plan and then the pull request, and I make the final human decision.
Two rules from that workflow are worth stealing:

- **The agent that wrote the change is never its only reviewer.**
- **Approval is tied to the exact commit.** An approval of an older commit
  never authorizes a newer one. Agents push follow-up commits quickly, and
  a stale approval is an easy way to ship something nobody reviewed.

### Humans keep merge authority

Agents can draft, test, and respond to review comments. The decision to
merge, and therefore to release, stays with a person who is accountable
for the outcome.

### Keep releases small

Agents make it easy to bundle a lot of change into one pull request. Small
changes are easier to review, test, and roll back, and that's even more
true when the reviewer is also reading machine-written code.

### A gate only protects branches that run it

This website is a small example of the failure mode. An unquoted colon in
a draft article's front matter broke the site's build. The fix was to run
the site's checks (links, front matter, content rules) in CI on every pull
request. Then a pull request that had been branched *before* those checks
existed merged without ever running them, and the deploy failed on the
check it had skipped.

Nothing was lost; the gate stopped the bad deploy. But it was caught after
merge instead of before. When you add or tighten a gate, rebase or re-run
open pull requests so they're held to it too.

## Release Checklist

Short enough to use every time:

- [ ] The automated gate passed on the exact commit being released.
- [ ] An independent reviewer approved that commit; a human approved the
      merge.
- [ ] The tag points to the intended commit.
- [ ] The artifact was built by the pipeline and records its version and
      commit.
- [ ] User-facing changes are summarized (changelog or release notes).
- [ ] The rollback path is known, and data changes are compatible with it.
- [ ] Smoke tests ran after deployment, and the reported version matches.
- [ ] Logs and metrics are arriving.

The checklist should live with the project. If a step repeats, document it
or automate it.

## Common Pitfalls

**Building by hand.** Hand-built artifacts are hard to reproduce and easy
to confuse. The pipeline builds the thing that ships.

**Approving a moving target.** Re-review after new commits, especially
when an agent is pushing fixes.

**Gates that differ between laptop and CI.** If the local check and the CI
check aren't the same command, they will drift.

**Untested rollbacks.** A rollback plan that has never been exercised is
only a theory.

**Ignoring data compatibility.** Schema changes can make rollback
impossible if old code can't read new data.

**Undocumented decisions.** If nobody wrote down why the release process
works the way it does, nobody can safely change it.

## Where This Fits

- [Version Control Systems](/software/version-control-systems/) provides
  the branch, tag, and history discipline that releases depend on.
- [Test Driven Software Development](/software/test-driven-software-development/)
  provides the automated checks that make the gates meaningful.
- [Peer Reviews](/software/peer-review/) covers review practices before
  code reaches the pipeline.
- [Writing Agent Instructions for a New Software Project](/software/writing-agent-instructions/)
  covers telling agents how your project works, including how to run its
  gate.

A release is not a special event at the end of a project. It's the last
step in a continuous loop: define the behavior, implement it, review it,
test it, ship it, verify it, and learn from it.
