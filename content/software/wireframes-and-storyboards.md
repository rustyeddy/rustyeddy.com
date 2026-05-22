---
title: Wireframes and Storyboards
date: 2026-05-21
description: >
  Visualizing the user experience before writing code — how storyboards
  walk through use cases and wireframes nail down the UI, giving users
  something concrete to react to before anything is built.
weight: 80
---

[Use cases](/software/use-cases/) define *what* users need. Wireframes and
storyboards show *how* they will interact with it. Done before any code is
written, they are among the cheapest ways to discover what you got wrong.

## Storyboards

A storyboard is a sequence of rough sketches — one frame per step in a use
case — that walks a user through the experience of using the system. Think
of it as a comic strip version of your use case.

The key word is *rough*. High-fidelity mockups discourage honest feedback:
users hesitate to suggest changes when they think significant work went into
something. A storyboard drawn with boxes and arrows on a whiteboard gets
candid reactions. That is the point.

### One Storyboard per Use Case

For Kelly's watering system, Use Case 1 — *water plants when the soil is
too dry* — maps to a storyboard with frames something like:

1. System idle, current moisture level displayed
2. Moisture drops below threshold — alert state shown
3. Pump activates — status indicator changes
4. Moisture rises past damp threshold — pump deactivates, system returns to idle

Walk Kelly through those four frames and you learn quickly whether the flow
matches her mental model. Does she want a confirmation step before the pump
activates? Does she want a history chart instead of a single moisture
reading? Does she expect to see which station triggered the event?

Discoveries like that cost a whiteboard marker, not a week of development.

### Storyboards Surface Decisions

As you sketch each frame, questions emerge that the use case left unanswered:
what happens if the sensor loses contact? What does the UI show when the
system is offline? What if two stations report conflicting moisture levels?

Capture those questions as notes on the storyboard. They become requirements,
edge cases in acceptance tests, or decisions to consciously defer to a later
iteration. Either way you have surfaced them early, when they are cheap to
address.

## Wireframes

Once the storyboard is stable — users have walked through it and the flow
makes sense — wireframes nail down the details of each screen.

A wireframe is a low-fidelity layout that specifies:

1. What content appears on each page or screen
2. Where it is positioned and how much space it occupies
3. What actions are available — buttons, forms, navigation
4. What data or media is displayed — charts, status indicators, images

Wireframes are still not visual design. No colors, no fonts, no icons — just
structure. The goal is to resolve every layout question before the front-end
developer starts writing markup.

A complete set of wireframes, one per storyboard frame, gives the UI
developer an unambiguous spec and gives the user another review checkpoint
before any code exists to change.

## Style Guide

After wireframes are approved, the visual design layer can begin. A style
guide captures the decisions that will make the application look coherent:

- **Color palette** — primary, secondary, and accent colors; semantic colors
  for states like error, warning, and success
- **Typography** — typeface choices, scale (heading sizes, body, captions),
  and line-height rules
- **Spacing and layout** — grid, gutters, padding conventions
- **Component patterns** — how buttons, forms, cards, and modals behave
  consistently across screens

The wireframes feed the style guide: if every screen has a status indicator,
the style guide defines what it looks like in each state. If every screen
has a data table, the style guide defines the table's visual treatment.

*Refactoring UI* by Adam Wathan and Steve Schoger is the most practical
reference for this work — it approaches visual design the way engineers
think about it, from constraints and patterns rather than aesthetics.

## Why Bother Before Coding?

The storyboard → wireframe → style guide sequence is a front-loaded
investment. It feels like overhead when you want to start building. The math
is straightforward: changes at the storyboard stage cost minutes, changes at
the wireframe stage cost hours, changes at the code stage cost days. The
later a wrong assumption surfaces, the more expensive it is to fix.

For a small project with tight user access, even rough storyboards done in a
thirty-minute session catch the most expensive misunderstandings before they
compound. The deliverable is not the artifact — it is the conversation the
artifact forces.
