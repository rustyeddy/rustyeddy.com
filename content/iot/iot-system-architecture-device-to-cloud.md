---
title: IoT System Architecture (Device to Cloud)
description: >
  A diagram-first overview of a practical IoT system architecture,
  covering devices, edge hubs, messaging, APIs, and user interfaces.
tags: [iot, architecture, edge-computing]
categories: [IoT, Software Architecture]
date: 2023-01-13
toc: true
---

# IoT System Architecture (Device to Cloud)

This page provides a **diagram-first overview** of the IoT architecture
used throughout the projects on this site.

The goal is not to present a single “correct” design, but to show a
**reasonable baseline architecture** that scales beyond demos and
remains flexible as requirements change.

If you want implementation details, those are covered in linked
articles. This page focuses on *structure*, *boundaries*, and *tradeoffs*.

---

## High-Level System Overview

At a high level, the system looks like this:

![High-level IoT system overview: device ↔ edge ↔ backend → UI](/diagrams/iot-architecture.svg)

This separation is intentional.

Each layer has a clear responsibility and communicates with the next
layer through well-defined interfaces.

---

## Devices: Sensors and Actuators

    +----------------------+
    |   IoT Device         |
    |----------------------|
    | - Sensor readings    |
    | - Actuator control   |
    | - Local logic        |
    | - Network client     |
    +----------------------+

Devices are responsible for:
- Interacting with the physical world
- Collecting data
- Executing commands
- Communicating with the edge or backend

They are **not** responsible for:
- Business logic
- Data persistence
- User interfaces

Keeping devices simple improves reliability and makes replacement
easier when hardware inevitably changes.

---

## Edge Hub: Aggregation and Control

    +--------------------------------+
    |          Edge Hub              |
    |--------------------------------|
    | - Device registry              |
    | - Protocol translation         |
    | - Message routing              |
    | - Local automation (optional)  |
    +--------------------------------+

The edge hub sits between devices and the cloud.

Typical responsibilities include:
- Aggregating multiple devices
- Translating protocols (GPIO, I2C, MQTT, HTTP)
- Acting as a control plane for local devices
- Handling intermittent connectivity

This layer is explored further in  
[Edge Device Architecture](/iot/edge-device-architecture/).

Not every system needs an edge hub—but when you do, adding it later is
far more painful than designing for it early.

---

## Messaging and APIs

        Telemetry            Commands
    Devices --------> MQTT <-------- Backend
                        |
                        v
                     Edge Hub

Two communication patterns dominate practical IoT systems:

### MQTT (Publish / Subscribe)

- Efficient for telemetry
- Decouples producers and consumers
- Tolerates intermittent connections

### REST APIs

- Better for configuration and control
- Explicit request/response semantics
- Easier to version and document

Treat messaging topics and APIs as **contracts**, not implementation
details. This is where many IoT systems quietly accumulate technical
debt.

Related reading:
- [IoT Device Management](/iot/iot-device-management/)
- [Building an IoT Device Manager in Go](/iot/building-iot-device-manager-in-go/)

---

## Backend Services

    +----------------------------------+
    |          Backend Services        |
    |----------------------------------|
    | - Device registry                |
    | - Telemetry ingestion            |
    | - Command dispatch               |
    | - Persistence                    |
    | - Auth / access control          |
    +----------------------------------+

The backend provides:
- A system of record
- Long-term data storage
- User and device authorization
- Integration points for other systems

Crucially, backend services should **not assume specific hardware**.
They interact with devices only through APIs and messages.

This is what enables simulation, testing, and gradual hardware
migration.

---

## User Interfaces

    +----------------------------+
    |      Web / Mobile UI       |
    |----------------------------|
    | - Dashboards               |
    | - Live telemetry           |
    | - Device control           |
    | - Configuration            |
    +----------------------------+

User interfaces sit at the edge of the system, not the center.

They:
- Consume backend APIs
- Visualize system state
- Trigger commands

They do **not** talk directly to devices.

This separation keeps the system secure and makes UI changes cheap
relative to hardware changes.

---

## Why This Architecture Matters

This structure:
- Encourages loose coupling
- Makes testing possible without hardware
- Allows devices to be replaced independently
- Supports incremental growth

Most failed IoT projects fail here—not due to sensors or radios, but
because architecture was treated as an afterthought.

---

## Common Architectural Pitfalls

    [ Device ] ---> [ Database ]

Yes, people really do this.

Common mistakes include:
- Hard-coding device behavior into backend logic
- Treating MQTT topics as unversioned APIs
- Letting UI assumptions leak into device firmware
- Designing for one device instead of a system

These shortcuts feel productive early on and become expensive later.

---

## Where to Go Next

If this architecture resonates, the following pages dive deeper:

- [Edge Device Architecture](/iot/edge-device-architecture/)
- [IoT Device Management](/iot/iot-device-management/)
- [Building an IoT Device Manager in Go](/iot/building-iot-device-manager-in-go/)
- [System Design Principles](/software/system-design-principles/)

Each builds on this diagrammatic foundation and explores the tradeoffs
in more detail.
