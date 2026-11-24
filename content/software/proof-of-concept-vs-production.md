---
title: "Proof of Concept vs. Production: When AI Makes the Demo Free"
description: "AI coding agents make a proof of concept nearly free. Production is as hard as ever. How to tell them apart and promote a POC on purpose, not by default."
weight: 15
date: 2026-11-23
tags: ["Software Delivery", "AI Agents", "Prototyping", "Software Engineering", "Engineering Management"]
categories: ["Software Engineering"]
summary: "A proof of concept answers whether something can be done; production makes it something other people can rely on. AI agents made the first cheap. Promote on purpose, with a checklist, not by momentum."
---

## For leads

When someone shows you an impressive demo and asks whether you can ship it,
the useful first question is which of two things it is:

1. **A proof of concept (POC)** answers one question: can this be done, and
   roughly how? It's done when the question is answered.
2. **Production software** is something people other than its author can rely
   on: tested, operable, secure, owned.

AI coding agents have made the first nearly free and left the second as hard
as it ever was. So:

- **Name it up front.** Every POC gets a question it answers and an expiry
  date.
- **Make promotion a decision, not a default.** Moving to production is an
  explicit call, made against a checklist.
- **Budget for the second phase.** The speed of the demo tells you nothing
  about the cost of production.

## Two different jobs

A POC and a production system can look alike on screen, but they're built for
opposite reasons.

A **proof of concept** removes uncertainty. You start out not knowing what you
don't know, and you finish knowing what you need to do. Its value is the
answer: the approach works or it doesn't, the library can do what you need or
it can't, the latency is acceptable or it isn't. Everything that doesn't help
answer that question is waste in a POC, so a good one cuts every corner it
can.

**Production software** turns a known answer into something usable by people
who weren't in the room when it was built. That job is mostly the corners the
POC cut: the error cases, the data that doesn't look like the demo data, the
deploy, the rollback, the person paged at 2 a.m.

Neither one is a worse version of the other. Trouble starts when a team
can't say which one it's looking at.

## What AI changed

It used to take days or weeks to build a convincing demo, and the effort
itself was a signal: by the time something looked finished, a fair amount of
real engineering had usually gone into it.

That signal is gone. An agent can produce a working demo of a new feature in
an afternoon, with a clean UI, plausible data and a happy path that runs
every time. That's genuinely useful. Discovery is cheaper than it has ever
been, and a team can try three approaches in the time one used to take.

It also creates two new risks:

- **The demo hides what's missing.** A polished POC looks much closer to done
  than it is. The missing work (validation, failure handling, security,
  observability) is exactly the part nobody sees in a demo.
- **The demo creates pressure to ship.** "It already works, can't we just put
  it live?" is a reasonable question from someone who has just watched it
  work. The answer depends on work that isn't visible yet.

The production half hasn't sped up the same way. Agents help there too, by
writing tests, drafting error handling and running checks, but deciding what
production needs and verifying that it's there still takes people's judgment,
and review time doesn't shrink because the code was written faster.

## The promotion question

Promoting a POC means adding what production needs and the POC deliberately
skipped. For most small teams that list looks like this:

- **Behavior pinned by tests.** Not "it worked when I tried it", but tests
  that fail when the behavior changes.
- **Failure handling.** What happens when the network drops, the input is
  malformed, or the third-party API returns an error?
- **Data boundaries.** Validation at the edges, and nothing invented or
  silently dropped in between.
- **Security.** No secrets in the code, inputs treated as untrusted, access
  limited to what's needed.
- **Observability.** Logs and signals good enough to diagnose a problem
  without the author present.
- **A release path.** Versioned, reviewed, reversible. See
  [Software Release Process: A Checklist for Small Teams](/software/release-process/).
- **An owner.** Someone accountable for it after launch.

If a team can't check every item, the honest status is "still a POC",
however finished it looks.

## Throw it away, or promote it on purpose

Fred Brooks put the classic advice in *The Mythical Man-Month* (1975): plan to
throw one away, because you will anyway. The first version of a system
teaches you what the system should have been.

Brooks later qualified that. In the book's 20th-anniversary edition he
argued the advice assumed a build-everything-then-ship process, and that
incremental development, growing a system in small working steps, is often
the better path. Both halves are useful here, because they describe the two
honest ways to get from a POC to production:

![A proof of concept with one question and an expiry date leads to an explicit decision against the checklist. The decision leads to one of three outcomes: rebuild from a smaller design, harden in place, or stop because the answer was no. Rebuild and harden both lead to production: tested, operable, owned.](/diagrams/poc-to-production.svg)

- **Rebuild.** Keep the POC as a reference and write the production system
  from a smaller, deliberate design. This is the right call when the POC's
  structure was shaped by exploration (most of the code exists because of
  approaches you abandoned), or when an agent generated more than anyone has
  read.
- **Harden in place.** Keep the POC's code and add the production checklist
  to it, step by step. This works when the POC is small, its structure is
  sound, and someone understands all of it.

A third outcome is just as valid: **stop**, because the answer was no. A POC
that kills a bad idea cheaply has done its job.

The path to avoid is the one that skips the decision: shipping the POC as it
is because it works, and finding out later which corners it cut.

## Two rebuilds in practice

Two of my own projects went through this in 2026.

**Trader**, a Go framework for FX strategy research, had grown broad: a
backtest engine, several strategies, an MCP server and more. In November
2026 it was restarted. Its
[README](https://github.com/rustyeddy/trader/blob/6f4c276/README.md)
describes the approach: the repository was restarted from a small, executable
design, and the earlier, broader code now lives in `_archive/` "as a donor"
that is ported one layer at a time, market data first. The README is also
blunt about status: backtesting is available, paper trading is planned, and
real-money execution is unavailable and not scheduled. The earlier code
answered a lot of questions. The restart is the promotion path, done on
purpose, with each layer re-earned. See the
[Trader project page](/projects/trader/).

**OttO**, an IoT edge runtime, went through the same thing in January 2026.
The original gateway's station server, REST data API, WebSocket dashboard and
in-memory store were archived, and OttO was rewritten around a smaller device
contract and topic scheme. See the [OttO project page](/projects/otto/).

In both cases the archived code wasn't wasted. It was the POC: it proved what
the system needed to do. The rebuild decided which parts deserved to become
production.

## Running POCs on a team that ships

POC work and production work can share a team and a board, as long as nobody
confuses them:

- **Label it.** A POC card says so, and states the question it answers and
  its expiry date.
- **Keep it apart.** A separate branch or repository, so POC shortcuts don't
  leak into the main line through an innocent-looking merge.
- **End it on purpose.** When the question is answered, the card closes with
  the answer, and any promotion becomes new cards with production exit
  criteria.

[Organizing Tasks with Kanban When AI Agents Do Some of the Work](/software/kanban/)
covers the board side of this: cards an agent can execute, checkable exit
criteria, and a review gate before Done.

## Common pitfalls

### The demo becomes the product

Nobody decided to ship the POC; it just never stopped running. Give every POC
an expiry date and a decision at the end of it.

### POC shortcuts survive into production

Hard-coded secrets, no tests, sample data baked in, errors swallowed. These
are fine in a POC and dangerous after it. The promotion checklist exists to
catch them.

### Estimating production from POC speed

"The demo took an afternoon, so production will take a week." The demo's
speed measures the cheap half. Estimate the production checklist, not the
demo.

### A POC with no question

Without a question to answer, a POC never finishes. It just keeps growing
until it's an unplanned production system. Write the question down first.

## Where this fits

- [Software Delivery for Small Teams: Using AI with Guardrails](/software/)
  is the overview this article belongs to.
- [Software Release Process: A Checklist for Small Teams](/software/release-process/)
  covers the release gates a promoted POC has to pass.
- [AGENTS.md and CLAUDE.md for Teams](/software/writing-agent-instructions/)
  covers the repository rules that keep agent-written code reviewable.
