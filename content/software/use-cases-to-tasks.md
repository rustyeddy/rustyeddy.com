---
title: Use Cases to Tasks
date: 2024-12-26
description: >
  How to turn use cases into requirements, acceptance tests, and small Kanban
  cards that are ready for implementation.
weight: 21
tags: ["Use Cases", "Tasks", "Acceptance Tests", "Kanban", "Software Engineering"]
categories: ["Software Engineering"]
---

A use case describes value from the user's point of view. A task describes a
piece of work a developer can finish. Confusing those two is one of the
fastest ways to turn a software plan into a vague backlog.

## Why This Matters

Use cases are useful only if they turn into work the team can plan, build, and
verify. Translating them into small tasks keeps the connection between user
value and implementation visible.

In [Use Cases](/software/use-cases/) we turned Kelly's watering-system story
into a focused use case:

> As a gardener, I want my system to periodically measure soil moisture and
> turn on a water pump when the soil is dry, then turn it off when it gets
> wet enough.

That is a good use case, but it is not a development task. It contains sensor
work, pump control, timing, thresholds, and testable behavior. The next step
is to slice it into requirements, acceptance tests, and small cards that can
move across a [Kanban board](/software/kanban/).

## Why Use Cases Are Not Tasks

A use case answers a product question: what does the user need the system to
do?

A task answers an implementation question: what small piece of work should a
developer complete next?

The translation matters because each artifact has a different audience:

| Artifact | Audience | Purpose |
| --- | --- | --- |
| Use case | User, product owner, team | Describe user value |
| Requirement | Team | State required behavior |
| Acceptance test | User, reviewer, team | Define observable success |
| Task card | Developer | Describe a small implementation step |

If a Kanban card is just a copied use case, it is usually too large. If a use
case is written as a technical task, it loses the user's intent.

## Extract Requirements from One Use Case

Start by pulling out the system behaviors implied by the use case. Stay close
to the user's language, but make each behavior specific enough to test.

From the watering use case, the first requirements are:

1. The system periodically measures soil moisture.
2. The system turns the pump on when moisture is below the dry threshold.
3. The system turns the pump off when moisture reaches the damp threshold.
4. The measurement interval can be configured.
5. The dry and damp thresholds can be configured.
6. Each measurement is recorded with time, station, moisture level, and pump
   state.

These are not yet tasks. They are behavioral commitments. They describe what
must be true when the system is working.

## Write Acceptance Tests Before Tasks

Acceptance tests define done from the outside. They should be understandable
without reading the code.

For the first slice, we can write these tests:

| # | Given | When | Then |
| --- | --- | --- | --- |
| 1 | Soil moisture is above the dry threshold | The station takes a reading | The pump remains off |
| 2 | Soil moisture falls below the dry threshold | The station takes a reading | The pump turns on |
| 3 | The pump is on | Soil moisture reaches the damp threshold | The pump turns off |
| 4 | The interval is set to 60 seconds | The station starts | A reading is attempted every 60 seconds |
| 5 | A reading is taken | The reading is accepted | The timestamp, station ID, moisture value, and pump state are recorded |

These tests give the developer and reviewer a shared target. They also make
it obvious when a requirement is too vague. For example, "record historic
moisture data" is not testable until we name the minimum fields that must be
recorded.

## Slice the Work into Task Cards

Now shift from user behavior to implementation work. Each task should be small
enough to finish in one to two days and specific enough to review.

### Soil Moisture Reading

{{% requirement "Measure soil moisture" %}}
Build a sensor reader that returns a normalized soil moisture value and an
error when the sensor cannot be read. For the garden project, the hardware
notes are in [Adafruit Soil Moisture Sensor Notes for IoT Projects](/notes/soil-moisture-adafruit/).
{{% /requirement %}}

Good task card:

> Implement soil moisture reader interface for the collection station.
>
> Done when a fake reader can return dry, damp, and read-error states in unit
> tests.

### Pump Control

{{% requirement "Turn the pump on and off" %}}
Build a pump controller that accepts explicit `on` and `off` commands without
knowing why the command was issued. That keeps the control logic separate from
the hardware driver.
{{% /requirement %}}

Good task card:

> Implement pump controller interface with GPIO-backed and fake implementations.
>
> Done when tests prove `On` and `Off` call the expected driver behavior.

### Moisture Decision Logic

{{% requirement "Apply dry and damp thresholds" %}}
Build the rule that compares the latest moisture reading against configured
thresholds and decides whether the pump should be on or off.
{{% /requirement %}}

Good task card:

> Implement moisture threshold decision function.
>
> Done when table-driven tests cover above dry threshold, below dry threshold,
> and damp threshold shutoff behavior.

### Periodic Measurement

{{% requirement "Measure on a configurable interval" %}}
A timer triggers moisture measurement at a configurable interval. The
implementation should keep timing separate from the sensor and pump logic so
it can be tested without waiting on real time. See [Go Timers](/notes/go-timers/)
for related implementation notes.
{{% /requirement %}}

Good task card:

> Add periodic measurement loop using configurable interval.
>
> Done when a fake ticker can trigger two readings without sleeping in the
> test.

### Measurement Record

{{% requirement "Record each measurement" %}}
Each accepted reading needs a durable record with timestamp, station ID,
moisture level, and pump state. Storage can start simple, but the data shape
should be stable.
{{% /requirement %}}

Good task card:

> Define measurement record type and local storage writer.
>
> Done when a reading can be written and read back with timestamp, station ID,
> moisture value, and pump state intact.

### MQTT Publication

{{% requirement "Publish readings for other components" %}}
The station publishes readings over MQTT so the gateway, logger, and future UI
can consume telemetry without being coupled to the sensor code. See
[MQTT Communication](/notes/mqtt-comm/) for the broader message-bus model.
{{% /requirement %}}

Good task card:

> Publish accepted measurement records to the station MQTT topic.
>
> Done when a test subscriber receives the expected JSON payload for one
> reading.

## Example Kanban Card

A finished card should make the work and exit criteria obvious. Here is one
card that is small enough to pull into `In Progress`:

```text
Title: Implement moisture threshold decision function

Requirement:
The system turns the pump on when moisture is below the dry threshold and
turns it off when moisture reaches the damp threshold.

Implementation notes:
- Inputs: current moisture, dry threshold, damp threshold, current pump state
- Output: desired pump state
- No hardware calls in this function

Acceptance criteria:
- Above dry threshold keeps pump off
- Below dry threshold turns pump on
- Damp threshold turns pump off when pump is already running
- Invalid threshold configuration returns an error

Links:
- Use case: Water plants when soil is too dry
- Tests: table-driven unit tests for threshold decisions
```

That card is not the whole watering system. It is one piece of the watering
system. When it is done, the board moves forward and the next card can build
on a tested decision boundary.

## Common Pitfalls

- Turning one use case into one giant task. The result is a card that sits in
  progress for days with no useful signal.
- Writing tasks before acceptance tests. Without exit criteria, the team
  argues about done after the work is already in motion.
- Mixing hardware drivers with decision logic. That makes the code harder to
  test and harder to replace.
- Hiding configuration inside code. Thresholds and intervals are part of the
  system behavior and need explicit tests.
- Creating cards that name technologies but not outcomes, such as "add MQTT"
  without saying what message must be published and how it will be verified.

## Ready for the Backlog

A task is ready for the Kanban board when it has:

- One clear behavior or implementation boundary.
- A direct link back to a requirement or use case.
- Acceptance criteria that can be tested or demonstrated.
- Enough detail for a developer to start without rediscovering the whole
  design.
- A size small enough for one person to complete in one or two days.

This is the bridge from design to development: use cases explain value,
requirements define behavior, acceptance tests define done, and task cards
make the work visible.

## Where This Fits

This page sits between [Use Cases](/software/use-cases/) and [Kanban](/software/kanban/).
Use cases define the user goal; task slicing turns that goal into work small
enough to track, test, review, and release.
