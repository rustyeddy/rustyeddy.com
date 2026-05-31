---
title: "Release Process"
date: 2026-05-21
weight: 100
description: >
  How to ship software with versioning, CI/CD, release artifacts,
  changelogs, smoke tests, rollback planning, and a repeatable release
  checklist.
tags: ["Release Process", "CI/CD", "Software Engineering", "Deployment"]
categories: ["Software Engineering"]
summary: "A practical release process for turning reviewed and tested code into versioned, recoverable software artifacts."
---

A release is the moment development work becomes user value. Everything
before it, including use cases, tests, and peer review, is preparation.
The release process determines whether that preparation becomes a calm
handoff or a production incident.

The goal is to make releases routine. A release should be a repeatable
sequence of checks, artifacts, deployment steps, verification, and
rollback options. If a release depends on memory and luck, it is not yet
a process.

## Why This Matters

Shipping is part of engineering. A feature that works on a developer's
machine but cannot be built, versioned, deployed, verified, or rolled
back is not ready for users.

A good release process gives the team answers to practical questions:

- What version are we shipping?
- Which commit produced the release?
- Which tests passed?
- What artifact was deployed?
- What changed for users?
- How do we know the deployment worked?
- What do we do if it did not?

Those answers reduce release risk because they turn deployment from a
custom event into a controlled workflow.

## Versioning

Every release needs a version. Semantic versioning is the common
convention:

```text
MAJOR.MINOR.PATCH
```

For example, `v2.4.1` means:

- **PATCH**: a backward-compatible bug fix.
- **MINOR**: a backward-compatible feature addition.
- **MAJOR**: a breaking change.

The exact convention matters less than consistency, but semantic
versioning is useful because it communicates intent. A patch release
should be safe to take. A major release tells users to expect migration
work.

Git tags should anchor versions to exact commits:

```bash
git tag -a v2.4.1 -m "Release v2.4.1"
git push origin v2.4.1
```

Without tags, reproducing an old release becomes guesswork.

## CI/CD Pipeline

Continuous integration runs automated checks for every change. Continuous
delivery or deployment carries a verified build toward production.

A typical pipeline includes:

1. **Build**: compile code and produce an artifact.
2. **Unit tests**: verify small behavior quickly.
3. **Integration tests**: verify important boundaries.
4. **Static checks**: run formatting, linting, type checks, and security
   scans.
5. **Acceptance tests**: verify user-facing behavior against a real or
   realistic environment.
6. **Package**: create the deployable artifact.
7. **Deploy**: release to staging or production.
8. **Verify**: run smoke tests and health checks.

If a required stage fails, the release should stop. A pipeline is useful
because it creates a gate that is harder to bypass accidentally.

## Release Artifacts

A release artifact is the thing you actually ship. It might be a Docker
image, static site build, firmware image, package archive, mobile app
bundle, or binary.

Artifacts should be:

- Built by the pipeline, not by hand on a developer machine.
- Identified by version, commit SHA, and build metadata.
- Stored somewhere durable.
- Reproducible from source and configuration.
- Promoted between environments when possible instead of rebuilt for each
  environment.

That last point matters. If staging and production are built separately,
you have not proven that the production artifact is the one you tested.
Build once, promote the artifact, and keep environment-specific values in
configuration.

## Changelog

A changelog explains the release to humans. The commit log records how the
code changed; the changelog explains what changed for users and operators.

A useful changelog entry includes:

- New user-visible behavior.
- Fixed bugs.
- Breaking changes.
- Migration notes.
- Operational changes.
- Known limitations.

[Keep a Changelog](https://keepachangelog.com/) is a good format. The
important practice is to update the changelog as part of release work, not
after everyone has forgotten what changed.

## Deployment Strategies

Different systems need different deployment patterns.

### Web Services

Common web-service strategies include:

- **Rolling deploy**: replace instances gradually while the service stays
  available.
- **Blue-green deploy**: deploy to a parallel environment, then switch
  traffic once it is verified.
- **Canary release**: send a small percentage of traffic to the new version,
  monitor it, then expand.

### Static Sites

A static site release is usually a generated artifact deployed to a hosting
provider or object store. The key checks are build reproducibility, link
validity, sitemap/feed correctness, and cache behavior.

### Desktop and Mobile Apps

Desktop and mobile releases move through distribution channels where users
may update slowly. Backward compatibility, API versioning, and migration
planning matter because multiple versions can exist in the field.

### Embedded and IoT Firmware

Firmware releases need extra care because devices may be physically
inaccessible. Over-the-air updates should use signed artifacts, staged
rollouts, and rollback-capable bootloaders when possible.

## Smoke Tests

Smoke tests are quick post-deploy checks that prove the release is alive
and handling the most important paths.

They are not a replacement for the full test suite. They answer a smaller
question: did the deployed system come up correctly?

Good smoke tests check things like:

- The application responds to health checks.
- The deployed version matches the intended version.
- A key page or endpoint loads.
- Authentication works if required.
- A basic read/write or publish/subscribe path works.
- Logs and metrics are arriving.

For a static site, smoke tests might verify the homepage, RSS feed,
sitemap, canonical metadata, and a few important article URLs. For an IoT
gateway, they might publish a test MQTT message and read it through the
REST API.

## Rollback Planning

Rollback is not something to improvise during an incident. The team should
know the rollback path before the release starts.

Rollback options depend on the system:

- **Web service**: redeploy the previous artifact or shift traffic back to
  the previous environment.
- **Static site**: redeploy the previous generated site artifact.
- **Database**: run a tested backward-compatible migration strategy or avoid
  destructive migrations during the release.
- **Firmware**: boot from a known-good partition if the new image fails.
- **Mobile app**: stop rollout, submit a hotfix, or disable risky behavior
  with server-side configuration.

Database changes deserve special caution. A code rollback is easy only if
the data shape is still compatible with the old code.

## Release Checklist

A practical release checklist should be short enough to use every time:

- Version number chosen.
- Changelog updated.
- Release branch or tag points to the intended commit.
- CI checks passed.
- Acceptance tests passed.
- Artifact built by the pipeline.
- Artifact stored with version and commit metadata.
- Deployment plan understood.
- Rollback plan understood.
- Smoke tests defined.
- Monitoring/logging checked after deployment.
- Release notes or user communication prepared when needed.

The checklist should live with the project. If a step is repeated, it
should be documented or automated.

## Common Pitfalls

### Building by Hand

Hand-built artifacts are difficult to reproduce and easy to confuse. The
pipeline should build the thing that ships.

### Releasing Too Much at Once

Large releases combine many risks. Smaller releases are easier to review,
test, deploy, and roll back.

### Untested Rollbacks

A rollback plan that has never been tested is only a theory. Test the path
before the incident.

### Ignoring Database Compatibility

Schema changes can make rollback impossible if the old code cannot read the
new data shape. Plan migrations so old and new code can coexist during the
transition.

### No Smoke Tests

A release is not done when deployment finishes. It is done when the deployed
system has been verified.

### Changelogs Written Too Late

Trying to reconstruct user-facing changes after the release is error-prone.
Keep the changelog current as changes merge.

## Where This Fits

The release process depends on the practices that came before it:

- [Version Control Systems](/software/version-control-systems/) provides the
  branch, tag, and history discipline needed for reproducible releases.
- [Test Driven Software Development](/software/test-driven-software-development/)
  provides the automated checks that make release gates meaningful.
- [Peer Reviews](/software/peer-review/) catches design and behavior problems
  before code reaches the release pipeline.

A release is not a special event at the end of the project. It is the final
step in a continuous engineering loop: define the behavior, implement it,
review it, test it, package it, deploy it, verify it, and learn from it.
