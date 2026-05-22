---
title: Release Process
date: 2026-05-21
weight: 100
description: >
  How to formalize the process of shipping software — versioning, CI/CD
  pipelines, deployment strategies, and what to do when a release goes wrong.
---

A release is the moment development work becomes user value. Everything up
to this point — use cases, tests, peer review — has been preparation. The
release process is what determines whether that preparation pays off cleanly
or turns into a crisis.

The goal is to make releases *boring*. A release that requires careful
coordination, manual steps, and nervous engineers is a process waiting to
fail. A release that is fully automated and runs dozens of times a week is
one nobody worries about.

## Versioning

Every release needs a version number. _Semantic versioning_ (semver) is the
widely adopted convention: `MAJOR.MINOR.PATCH` — for example, `v2.4.1`.

- **PATCH** — a backward-compatible bug fix (`v2.4.1` → `v2.4.2`)
- **MINOR** — a new backward-compatible feature (`v2.4.1` → `v2.5.0`)
- **MAJOR** — a breaking change (`v2.4.1` → `v3.0.0`)

The convention matters because it communicates intent to everyone who depends
on your software. A patch update is safe to take immediately. A major version
bump is a signal to read the changelog and plan for migration.

Git tags anchor version numbers to a specific commit, making it possible to
recreate any past release exactly. Tagging a release is a one-line operation;
skipping it means you lose the ability to reproduce what you shipped.

## CI/CD Pipeline

_Continuous Integration_ (CI) is the practice of automatically building and
testing every change as it merges into the main branch. _Continuous Delivery_
or _Continuous Deployment_ (CD) extends that to automatically deploying
verified builds to production or a staging environment.

A typical pipeline runs these stages in order:

1. **Build** — compile the code, resolve dependencies, produce an artifact
2. **Unit and integration tests** — run the full test suite against the artifact
3. **Static analysis** — linting, type checking, security scanning
4. **Acceptance tests** — end-to-end tests against a staging environment
5. **Deploy** — push the artifact to production (or flag it as release-ready)

If any stage fails, the pipeline stops and the change does not proceed. This
is the key property: a broken build cannot reach users. The team gets an
immediate signal, fixes the issue, and the pipeline runs again.

GitHub Actions, GitLab CI, and similar tools make it straightforward to
define a pipeline as a checked-in YAML file. The pipeline definition lives
in the repository alongside the code, is versioned with it, and applies to
every branch.

## Deployment Strategies

How you deploy depends heavily on what you are deploying. The pipeline is
consistent; the final step varies.

**SaaS / web services** — The most flexible deployment target. Common
strategies:

- _Rolling deploy_: replace instances one at a time, so the service stays
  up throughout the deployment.
- _Blue-green deploy_: run two identical environments; route traffic from
  the old (blue) to the new (green) once it is verified, then tear down blue.
- _Canary release_: route a small percentage of traffic to the new version
  first, monitor for errors, then gradually increase until fully rolled out.

**Desktop and mobile apps** — Releases are versioned artifacts pushed to
distribution channels (app stores, package managers, download servers). Users
update on their own schedule, so you may be supporting multiple versions
simultaneously. Backward-compatible API design becomes important.

**Embedded and IoT firmware** — The device cannot take downtime and may be
physically inaccessible. Over-the-air (OTA) update capability needs to be
designed in from the start. A failed firmware update on a remote device is
an expensive support problem; staged rollouts and rollback-capable bootloaders
are worth the upfront investment.

## Changelog

A changelog is a human-readable record of what changed between versions,
written for users rather than developers. The commit log is not a changelog
— it describes implementation, not impact.

A good changelog entry answers: *what can users do now that they could not
before, what was broken that is now fixed, and what changed in a way they
need to know about?*

[Keep a Changelog](https://keepachangelog.com) is a widely used format. At
minimum, maintain a `CHANGELOG.md` in the repository and update it as part
of the release process, not after.

## When a Release Goes Wrong

Plan for rollback before you need it, not after something breaks in
production. What rollback looks like depends on the deployment target:

- **Web services**: redeploy the previous version tag; the pipeline handles it.
- **Database migrations**: every migration needs a corresponding down
  migration. Untested rollback paths are not rollback paths.
- **Firmware**: a dual-partition scheme with a validated fallback image is the
  standard approach for devices that cannot be physically recovered.

The other half of incident response is communication. Users who know what
happened and what is being done tend to be far more patient than users who
are left guessing. A brief, honest status update is better than silence.

## Making Releases Routine

The teams with the fewest release incidents are usually the ones that release
most frequently. Frequent releases mean small changesets, small changesets
mean fewer things that can go wrong, and the team builds the muscle memory
to deploy confidently.

If releasing feels risky, the answer is almost never to release less often.
It is to invest in the pipeline, the test suite, and the rollback procedure
until releasing feels like the safest thing you do all day.
