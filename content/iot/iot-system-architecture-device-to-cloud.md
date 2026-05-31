---
title: IoT System Architecture (Device to Cloud)
description: >
  A diagram-first overview of a practical IoT system architecture,
  covering devices, edge hubs, messaging, APIs, backends, and user interfaces.
tags: [iot, architecture, edge-computing]
categories: [IoT, Software Architecture]
date: 2023-01-13
toc: true
---

This page is a diagram-first overview of the IoT architecture used throughout
the projects on this site. It is for engineers who need to decide where device
logic ends, where edge coordination begins, and how telemetry, control, APIs,
storage, and user interfaces fit together.

The goal is not to present a single correct design. The goal is to show a
reasonable baseline that can grow beyond demos without locking the system to
one board, one sensor, one database, or one user interface.

For concrete implementations, see the [OttO project](/projects/otto/), the
[IoT device abstraction layer in Go](/iot/building-iot-device-manager-in-go/),
[MQTT gateway notes](/iot/iot-gateway-mqtt/), and
[REST gateway notes](/iot/iot-gateway-rest/).

## High-Level System Overview

At a high level, the system looks like this:

![High-level IoT system overview showing devices connected to an edge hub, backend services, and user interfaces](/diagrams/iot-architecture.svg)

Each layer has a clear responsibility and communicates with the next layer
through explicit interfaces. That separation is what lets a system replace
hardware, add dashboards, test logic without devices, and survive intermittent
network connections.

## Architecture Decision Table

| Component | Use it when | Avoid or defer it when |
| --- | --- | --- |
| Device firmware | The device must sense, actuate, or perform minimal local safety behavior | Business rules, dashboards, and storage can live elsewhere |
| Edge hub | Multiple devices need local coordination, protocol translation, buffering, or offline behavior | A single device can safely talk directly to a backend |
| MQTT | Telemetry or events need publish/subscribe decoupling | You need explicit request/response semantics or human-facing APIs |
| REST API | Configuration, control, or external integrations need stable endpoints | High-frequency telemetry is the main workload |
| Backend service | You need long-term storage, auth, fleet state, or integration with other systems | The system must operate entirely offline and local-only |
| Dashboard/UI | Humans need monitoring, configuration, or manual control | The system is fully autonomous and observable elsewhere |
| Cloud service | Fleet-wide storage, remote access, or multi-site coordination is required | Local operation and privacy are more important than remote access |

The table is not a checklist. It is a way to keep responsibilities explicit.
Small systems may start with fewer pieces, but the boundaries should still be
clear.

## Devices: Sensors and Actuators

```text
+----------------------+
|   IoT Device         |
|----------------------|
| - Sensor readings    |
| - Actuator control   |
| - Minimal local logic|
| - Network client     |
+----------------------+
```

Devices interact with the physical world. They collect readings, execute
commands, and communicate with the edge hub or backend.

They should not own the whole product. Business logic, persistence, dashboards,
and user workflows become expensive to maintain when they are buried in device
firmware.

Keeping devices small improves reliability and makes replacement easier when
hardware changes. In the [self-watering garden](/iot/self-watering-garden/),
that means a collection station can focus on reading moisture and controlling
hardware while the gateway handles coordination and UI-facing behavior.

## Edge Hub: Aggregation and Control

```text
+--------------------------------+
|          Edge Hub              |
|--------------------------------|
| - Device registry              |
| - Protocol translation         |
| - Message routing              |
| - Local automation             |
| - Offline buffering            |
+--------------------------------+
```

The edge hub sits between devices and backend services. It is where local
coordination belongs when devices need to keep working without a reliable
internet connection.

Typical responsibilities include:

- Aggregating multiple devices.
- Translating protocols such as GPIO, I2C, MQTT, and HTTP.
- Running local automation rules.
- Buffering telemetry during network outages.
- Exposing local REST or WebSocket APIs for dashboards.

Not every system needs an edge hub, but adding one later is often painful if
devices and backend services were designed as a tightly coupled pair. OttO is
my Go-based version of this edge runtime; see [OttO: IoT Edge Runtime](/projects/otto/)
and the older [IoT edge gateway notes](/iot/iot-edge-gateway/) for project
context.

## Messaging and APIs

```text
        Telemetry            Commands
    Devices --------> MQTT <-------- Backend
                        |
                        v
                     Edge Hub
```

Two communication patterns dominate practical IoT systems.

### MQTT (Publish / Subscribe)

MQTT works well for telemetry and event distribution. It decouples producers
from consumers, tolerates intermittent connections, and lets multiple
subscribers react to the same reading without changing device code.

MQTT topics should be treated as API contracts. Topic names, payload shapes,
and versioning matter. Accidental topic design becomes technical debt quickly.

### REST APIs

REST APIs work better for configuration, control, and external integrations.
They provide explicit request/response semantics and are easier to document,
version, and secure for user-facing operations.

A common pattern is MQTT for telemetry and REST for configuration/control.
That split keeps high-volume readings out of request/response APIs while
preserving clear control boundaries.

## Backend Services

```text
+----------------------------------+
|          Backend Services        |
|----------------------------------|
| - Device registry                |
| - Telemetry ingestion            |
| - Command dispatch               |
| - Persistence                    |
| - Auth / access control          |
+----------------------------------+
```

Backend services provide the system of record: long-term storage, device and
user authorization, fleet state, analytics, and integration points for other
systems.

The backend should not assume specific hardware. It should interact with
devices through messages and APIs. That is what allows simulation, testing,
hardware migration, and multiple device generations to coexist.

## User Interfaces

```text
+----------------------------+
|      Web / Mobile UI       |
|----------------------------|
| - Dashboards               |
| - Live telemetry           |
| - Device control           |
| - Configuration            |
+----------------------------+
```

User interfaces sit at the edge of the system, not the center. They visualize
state, trigger commands, and expose configuration.

They should not talk directly to physical devices. UI-to-device shortcuts are
usually convenient during a demo and expensive later. Keeping the UI behind
APIs makes interface changes cheaper than hardware changes.

## Why This Architecture Matters

This structure keeps system responsibilities clear:

- Devices stay focused on sensing and actuation.
- Edge hubs coordinate local behavior and tolerate outages.
- MQTT and REST define communication contracts.
- Backends provide durable state and integration points.
- UIs present state and collect user intent.

Most failed IoT projects do not fail because the sensor was impossible to
read. They fail because architecture was treated as an afterthought: device
behavior leaks into the backend, UI assumptions leak into firmware, MQTT
topics become accidental APIs, and everything becomes hard to replace.

## Common Architectural Pitfalls

```text
[ Device ] ---> [ Database ]
```

Yes, people really do this.

Common mistakes include:

- Hard-coding device behavior into backend logic.
- Treating MQTT topics as unversioned implementation details.
- Letting UI assumptions leak into device firmware.
- Designing for one device instead of a system.
- Assuming the cloud connection is always available.
- Treating the edge hub as a dumping ground for unrelated responsibilities.

These shortcuts feel productive early on and become expensive later.

## Where to Go Next

The following pages dive into specific parts of this architecture:

- [OttO: IoT Edge Runtime](/projects/otto/)
- [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/)
- [Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/)
- [Adding the REST API to IoT Gateway](/iot/iot-gateway-rest/)
- [Self-Watering Garden](/iot/self-watering-garden/)
