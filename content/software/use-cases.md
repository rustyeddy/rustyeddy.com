---
title: Use Cases
date: 2024-09-27
description: >
  How to capture what users need through customer discovery and translate
  their stories into concrete, testable use cases that drive the entire
  development project.
weight: 20
---

## Why This Matters

Before writing a single line of code, we need to understand what we are
building — and more importantly, *why* someone would use it. Use cases give
us that foundation.

A use case is a single, focused story that describes one way a user achieves
a specific goal with the system. Keep them in plain language, from the user's
point of view, with no technical jargon. A good use case has a clear success
condition: you can observe or measure when it worked.

The technique was established by Swedish computer scientist Ivar Jacobson in
1987 and has been a cornerstone of requirements engineering ever since.

## Customer Discovery

_Customer Discovery_ is one or more sessions with the people who will
actually use the software. You ask them to tell you stories: how they
currently do something, what frustrates them, what would make their life
easier.

Every story stays in plain, non-technical language from the user's point of
view. No implementation details, no technology choices. The goal is to
surface the *value* the system needs to deliver, not the mechanism.

You then unravel each user story into a series of use cases — much like
breaking a complex novel into short stories, each with a single plot and a
clear conclusion.

### An Example

Kelly is an avid gardener with a few hundred succulents spread across her
property. Succulents are resilient but sensitive to overwatering, and each
variety has different moisture needs. Tracking watering schedules by hand is
error-prone and time-consuming.

She wants an automated watering system. Here is the story she told:

> I have a garden of a few hundred succulents of varying types. I need an
> irrigation system that automatically waters them when the soil becomes too
> dry without overwatering. I need to adjust moisture thresholds for different
> plant types. I'd also like to water manually, set schedules, track
> temperature and humidity, control lights, and monitor everything from my
> phone.

Notice two things: no technical language, and significant scope creep built
into a single conversation. That is normal. The job of use cases is to
untangle it.

## Breaking Out Use Cases

We take Kelly's story and break it into individual use cases — each focused
on one goal, one user, one observable outcome.

```
One objective per use case.
Focus on the specific value it provides the user.
```

#### Use Case 1: Water plants when the soil is too dry

> As a gardener, I want my system to periodically measure soil moisture and
> turn on a water pump when the soil is dry, then turn it off when it gets
> wet enough.

From this single use case we extract three concrete requirements:

1. Periodically measure soil moisture levels
2. Activate the water pump when moisture drops below a threshold
3. Deactivate the pump when moisture reaches the upper threshold

The key is staying in the user's language. Nothing yet about sensors,
microcontrollers, or databases. That comes later.

### The Acceptance Test

The requirements tell us *what* the system must do. The acceptance test
tells us *how we will know it worked*:

1. Pump is inactive when moisture is above the dry threshold
2. Pump activates when moisture crosses the dry threshold
3. Pump deactivates when moisture crosses the damp threshold

Every use case gets an acceptance test. Together they become the validation
criteria for the entire project.

## The Minimum Viable Product

Once you have a set of use cases, you need to decide which ones must ship
first. This is the _Minimum Viable Product_ — the smallest useful thing you
can put in front of real users.

The primary purpose of the MVP is to get working software into users' hands
as quickly as possible. That often means delivering something lacking
features, even a bit rough. That is intentional. A development team building
in isolation, disconnected from real users, is the most reliable way for a
software project to go wrong.

For Kelly's system, the MVP is one sensor wired to one pump, moisture levels
hard-coded, no app, no cloud. Just a pump that turns on when the soil is dry
and turns off when it is wet. Every other feature — configuration, scheduling,
remote access — is backlogged for future iterations.

## Common Pitfalls

Use cases stop helping when they become implementation notes instead of user
stories. Common mistakes include combining several goals into one use case,
writing from the developer's point of view, skipping the observable success
condition, and treating the first user story as the full product scope.

## Where This Fits

With use cases in hand, you have the inputs to everything else in the project:

- **Requirements** — derived directly from the use case narratives
- **Acceptance tests** — the measurable criteria that define done
- **Wireframes and storyboards** — the UI sketched from the user's journey
- **Kanban backlog** — tasks broken out from the requirements

The next step is slicing use cases into concrete development tasks, covered in
[Use Cases to Tasks](/software/use-cases-to-tasks/).
