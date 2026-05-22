---
title: Use Cases to Tasks
date: 2024-12-26
description: >
  Taking use cases and slicing them into concrete development tasks,
  acceptance tests, and Kanban backlog items ready for the dev team.
weight: 21
---

In [Use Cases](/software/use-cases/) we broke Kelly's watering system story
into a first use case and derived an initial set of requirements and
acceptance tests. Now we turn those into actual development work items.

## Slicing Use Cases

A single use case is often too large to implement in one sprint. We slice
it into thinner, independently deliverable use cases.

Starting from Use Case 1:

> Use Case 1: As a gardener, I want my system to periodically measure soil
> moisture and turn on a water pump when the soil is dry, then turn it off
> when it gets wet enough.

Two natural slices emerge:

> Use Case 1.1: As a gardener, I want to configure how frequently soil
> moisture is checked.

This introduces a configuration variable and a timer.

> Use Case 1.2: As a gardener, I want my system to record historic soil
> moisture data.

This introduces a data model and storage.

## Requirements

From Use Case 1 and its slices:

1. Periodically measure soil moisture levels
2. Activate the water pump when moisture drops below the dry threshold
3. Deactivate the pump when moisture reaches the damp threshold
4. Configurable measurement frequency and thresholds
5. Historic data storage

## Acceptance Tests

| # | Test |
|---|------|
| 1 | Pump is inactive when moisture is above the dry threshold |
| 2 | Pump activates when moisture crosses the dry threshold |
| 3 | Pump deactivates when moisture crosses the damp threshold |
| 4 | Measurement interval is configurable at runtime |

## Busting Out the Tasks

Here we shift from user language to developer language. We are now asking:
*what do we actually need to build?*

We stay technology-neutral at this level — no specific libraries or languages
yet. These tasks apply equally to a Go service, a Python script, or C++
firmware.

### Soil Moisture Sensor

{{% requirement "Periodically measure soil moisture levels" %}}
We need a sensor to stick in the soil that reports moisture to the
controller. For this project we use Adafruit's I2C Capacitive Moisture
Sensor. Wiring and driver details are in the
[Soil Moisture Sensor](/notes/soil-moisture-adafruit/) note.
{{% /requirement %}}

### Water Pump Control

{{% requirement "Activate and deactivate the pump" %}}
The pump is switched via a GPIO pin on the controller board. The controller
needs a module that accepts a simple on/off command and drives the pin
accordingly.
{{% /requirement %}}

### Periodic Measurement Timer

{{% requirement "Configurable measurement frequency" %}}
A timer fires at a configurable interval and triggers a moisture read. See
[Go Timers](/notes/go-timers/) for the implementation approach.
{{% /requirement %}}

### Data Broadcast via MQTT

{{% requirement "Publish sensor readings" %}}
Readings are published over MQTT so any subscriber — the pump controller,
a logger, a future UI — can consume them independently. See
[MQTT Communication](/notes/mqtt-comm/) for broker setup and channel
conventions.
{{% /requirement %}}

### Local Data Storage

{{% requirement "Historic data storage" %}}
Readings are cached locally in a time-series store so the system functions
without network access and the UI can display history. Minimum fields:
timestamp, station ID, moisture level, pump state.
{{% /requirement %}}

### Configuration Variables

{{% requirement "Configurable thresholds and intervals" %}}
The following values must be configurable at runtime, not hard-coded:

1. Measurement interval (seconds)
2. Dry threshold — moisture level that triggers pump on
3. Damp threshold — moisture level that triggers pump off
4. Local data storage path
5. MQTT channel name
{{% /requirement %}}

## Adding Tasks to the Kanban Board

With requirements, acceptance tests, and implementation tasks defined, we
are ready to populate the Kanban board. Each task above becomes a card.
Each acceptance test becomes the exit criterion for its card.

That is the bridge from design to development. The mechanics of running the
board — WIP limits, task sizing, moving cards through columns — are covered
in [Kanban](/software/kanban/).
