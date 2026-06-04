---
title: "OttO: A Go-Based IoT Edge Gateway Architecture"
date: 2022-01-13
description: >
  OttO is a Go-based IoT edge gateway that connects sensor stations,
  MQTT messages, REST APIs, WebSocket dashboards, and application logic
  at the boundary between devices and backend systems.
git: https://github.com/rustyeddy/otto
weight: 10
tags: ["IoT Architecture", "IoT Gateway", "Go", "MQTT", "REST"]
categories: ["IoT Systems", "Edge Computing"]
summary: "A practical architecture overview of OttO, the Go-based IoT edge gateway used by the Organic Gardener project."
---

[OttO](/projects/otto/) is the edge gateway for the Organic Gardener IoT project. It sits
between small device stations and the higher-level software that needs
their data: dashboards, REST clients, control logic, and eventually
backend services. It is the edge-runtime implementation behind the broader
[IoT System Architecture](/iot/iot-system-architecture-device-to-cloud/).

Older versions of this project used a few names interchangeably:
_IoT Hub_, _IoTe gateway_, _smart hub_, and _OttO_. In this article I
use **OttO** for the gateway implementation, **IoT Hub** for the role it
plays in the system, and **Organic Gardener** for the irrigation
application that uses it.

![IoT Hub service architecture showing MQTT input, REST API, WebSocket dashboard, and in-memory data cache](/img/iothub.png)

## What OttO Does

An IoT gateway has one main job: make a messy physical environment look
like a coherent software system.

Collection stations publish telemetry such as soil moisture,
temperature, and humidity. Control stations wait for commands that turn
physical equipment on or off. Applications need a stable way to read
state, inspect recent data, and issue control decisions without knowing
every device detail.

OttO provides that boundary. It:

- Subscribes to MQTT telemetry from collection stations.
- Parses station and sensor identifiers from message topics.
- Holds recent readings in an in-memory cache.
- Serves a REST API for clients that need current or historical values.
- Streams updates to browser dashboards with WebSockets.
- Provides a place for application logic that coordinates sensors and
  actuators.

That makes the gateway more than a protocol adapter. It is the edge
runtime where device data becomes useful application state.

## Why This Matters

Small IoT projects often start with one sensor, one script, and one
hard-coded destination. That works until the system needs a second
sensor type, a dashboard, a command path, a test harness, or a different
network layout.

A gateway gives the system a stable middle layer. Devices can stay
small. Applications can talk to a clean API. The project can change its
hardware, dashboard, storage, or backend without rewriting every other
piece at the same time.

For Organic Gardener, this matters because irrigation control should not
be buried inside a sensor node. The gateway can compare recent moisture
readings, apply zone rules, publish commands, and expose the result to a
human operator. The collection station remains responsible for sensing;
the control station remains responsible for switching equipment; OttO
coordinates the two.

## Runtime Architecture

OttO is written in Go and uses a small set of standard building blocks:

- Go's built-in HTTP server for the REST API and dashboard assets.
- MQTT subscriptions for telemetry and command channels.
- WebSockets for live dashboard updates.
- Go routines and channels for concurrent readers and writers.
- In-memory data structures for recent telemetry.

The gateway is intentionally light enough to run on Raspberry Pi-class
hardware while still using the same patterns that work in larger backend
systems.

![Raspberry Pi single-board computer suitable for running the IoT Hub](/img/rpi.jpg)

A typical flow looks like this:

1. A collection station samples a sensor.
2. The station publishes the reading to an MQTT topic.
3. OttO receives the message and extracts the station and sensor IDs.
4. OttO stores the reading in its local cache.
5. REST clients can request the current state.
6. Dashboard clients receive live updates over WebSockets.
7. Application logic can publish control messages when action is needed.

This keeps message ingestion, state access, and user-facing updates in
one edge process while preserving clear protocol boundaries.

## MQTT as the Device Boundary

MQTT is the device-facing side of the gateway. Collection stations can
publish readings without needing to know about dashboards, REST routes,
or storage implementation details.

The early project used topic paths shaped like this:

```text
ss/data/{stationid}/{sensorid}
```

A subscription such as this lets the gateway receive readings from many
stations and sensors:

```text
ss/data/+/+
```

That wildcard is convenient, but it should be treated carefully. MQTT
topics become an API whether or not they are documented as one. A topic
scheme needs naming rules, versioning rules, and clear ownership before
other devices and services depend on it.

For the implementation details, see
[Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/).

## REST as the Application Boundary

REST is the client-facing control and query boundary. Dashboards,
experiments, tests, and backend services should not need direct access
to the gateway's internal Go structs. They need a stable API.

The gateway can expose routes such as:

```text
GET    /stations
GET    /station/{stationid}
GET    /data?stationid={stationid}&sensor={sensorid}&start={start}&end={end}
DELETE /data?stationid={stationid}&sensor={sensorid}&start={start}&end={end}
```

These routes make the data visible without forcing every consumer to
subscribe to MQTT. They also create a natural place to add validation,
authentication, filtering, and response versioning as the project grows.

For the implementation details, see
[Adding the REST API to IoT Gateway](/iot/iot-gateway-rest/).

## WebSockets for Live Dashboards

REST works well for request and response workflows. Dashboards often
need something different: live updates as new readings arrive.

OttO uses WebSockets to push new telemetry to connected browser clients.
That lets the dashboard update without polling the REST API repeatedly.
It also keeps the dashboard separate from the MQTT broker. Browser code
connects to the gateway, and the gateway remains responsible for the
messaging system behind it.

In Organic Gardener, this gives a user a live view of moisture readings,
zone state, and control behavior while the gateway continues to process
MQTT traffic in the background.

## Current State and Boundaries

The current OttO architecture is best understood as an edge gateway and
reference runtime, not as a complete cloud platform.

It is responsible for:

- Receiving telemetry from device stations.
- Keeping recent state close to the devices.
- Exposing that state through HTTP and WebSockets.
- Coordinating simple application behavior at the edge.
- Providing a practical foundation for the Organic Gardener system.

It is not trying to be every layer of an IoT product. Long-term storage,
fleet management, user accounts, alerting, analytics, and remote update
infrastructure belong in surrounding services once the project needs
them.

That separation matters. A gateway should be strong enough to run the
local system, but bounded enough that it does not become a monolith at
the edge.

## Common Pitfalls

### The Gateway Does Too Much

It is tempting to put every new feature in the gateway because the
gateway sees every message. That turns a useful edge runtime into a
large, fragile application.

A better rule is to keep the gateway focused on ingestion, local state,
protocol translation, and edge decisions that must happen near the
devices. Reporting, account management, large analytics jobs, and
business workflows usually belong elsewhere.

### Unbounded In-Memory Caches

The early gateway keeps readings in RAM. That is a reasonable starting
point for live dashboards and short experiments, but it needs limits.

Without retention limits, backpressure, or persistence boundaries, a
healthy sensor network can eventually exhaust memory. Production systems
need explicit cache windows, durable storage, or both.

### MQTT Topics Become Accidental APIs

An MQTT topic is easy to change when only one script publishes to it. It
is much harder to change after sensors, dashboards, tests, and control
logic all rely on the same shape.

Topic naming should be treated as interface design. Document the topic
scheme, version it when needed, and avoid encoding too much hidden
meaning into positional path segments.

### Missing Observability

A gateway is difficult to debug when it only fails silently. It should
make message rates, subscription status, parse failures, queue depth,
cache size, connected clients, and command outcomes visible.

Logs are useful, but they are not enough by themselves. Metrics and
health endpoints become important once the gateway runs unattended.

## Where OttO Fits in the Larger System

OttO is the edge layer in the broader Organic Gardener architecture:

| Layer | Responsibility | OttO's role |
| --- | --- | --- |
| Device stations | Sense and actuate | Publish telemetry and receive commands |
| MQTT broker | Route device messages | Carries telemetry and command topics |
| OttO gateway | Coordinate edge state | Ingests, caches, exposes APIs, streams updates |
| Application | Decide what should happen | Organic Gardener uses gateway state and commands |
| Backend services | Store, analyze, manage | Optional services beyond the edge runtime |

This is the same layered model described in
[The Five Layers of a Practical IoT System](/iot/iot-system-architecture-explained/),
with OttO occupying the edge runtime layer.

## Related Articles

- [Building an IoT Device Manager in Go](/iot/building-iot-device-manager-in-go/)
- [Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/)
- [Adding the REST API to IoT Gateway](/iot/iot-gateway-rest/)
- [Self-Watering Garden](/iot/self-watering-garden/)
- [IoT System Architecture: Device to Cloud](/iot/iot-system-architecture-device-to-cloud/)
