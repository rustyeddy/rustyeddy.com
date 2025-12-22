---
title: Internet of Things (IoT)
description: >
  A software-first approach to building IoT systems. This site focuses on
  real-world architecture, APIs, messaging, and embedded-to-cloud
  integration—not just hardware hacks.
tags: [iot, maker, software-architecture]
date: 2023-01-13
---

## Overview

Building DIY electronic projects is fun—and more accessible than ever.
You no longer need to be a rocket scientist or a millionaire to build
useful IoT systems.

What *is* still rare is content that treats IoT as a **serious software
engineering problem** rather than a collection of disconnected hardware
demos.

That’s the focus here.

This site documents the design and implementation of IoT projects with
an emphasis on **software architecture**, **system integration**, and
sound **engineering practices**. The goal is not just to make devices
work, but to build systems that scale, evolve, and remain maintainable.

If you’re looking for step-by-step wiring guides, this probably isn’t
the right place. If you care about system boundaries, APIs, messaging,
and long-term maintainability, you’re in the right spot.

## Why IoT?

IoT projects sit at the intersection of multiple disciplines:

> IoT software combines embedded systems, backend services, APIs,
> messaging, and user-facing applications.

Few domains force you to think simultaneously about:
- Resource-constrained devices
- Unreliable networks
- Distributed systems
- Real-time data
- Long-lived software deployed in the field

That combination makes IoT an excellent proving ground for applying
professional software engineering principles in environments that are
far less forgiving than typical web applications.

## Diversity of Technology

These projects intentionally span a wide range of technologies:

- **Embedded devices**  
  Code running on small, real-time systems such as ESP32s and Raspberry
  Pi Pico devices, using C++ and Python.

- **Edge and hub systems**  
  Device aggregation, protocol translation, and orchestration using
  Raspberry Pi-class hardware and Go.

- **User interfaces**  
  Web-based and mobile-friendly interfaces built with JavaScript and
  React.

The point is not to master every tool, but to understand how these
pieces fit together into a coherent system with clear responsibilities
and boundaries.

## Building Extensible Systems with APIs

A recurring theme throughout these projects is **extensibility**.

Rather than tightly coupling devices to specific implementations, we
design around:
- Public REST APIs
- MQTT-based publish/subscribe messaging
- Cloud-backed services accessible from anywhere

This allows devices to be added, replaced, or simulated without
rewriting the entire system.

If you’re interested in this approach, see:
- [IoT Device Management](/iot/iot-device-management/)
- [Building an IoT Device Manager in Go](/iot/building-iot-device-manager-in-go/)

From a technical perspective, IoT systems are interesting precisely
because they require many disparate components to work together
reliably over time—often under less-than-ideal conditions.

## Project Overview

The initial project documented here focuses on a simple but
representative system:

- A physical device that collects temperature and humidity data
- A backend service that ingests and stores telemetry
- A web interface that displays live and historical readings
- A relay-controlled switch to remotely control a physical device

While modest in scope, this project lays the foundation for building
more complex IoT systems without changing the underlying architecture.

## Architecture

The system is designed to be **loosely coupled** and interchangeable.

While an initial implementation might use a Raspberry Pi or ESP32, the
architecture allows entirely different devices to be integrated by
conforming to the same APIs and messaging contracts.

This approach is explored in more detail here:
- [Edge Device Architecture](/iot/edge-device-architecture/)

Designing for loose coupling:
- Reduces vendor lock-in
- Encourages experimentation
- Makes systems easier to test and extend
- Lowers the cost of change over time

The goal is not just to build *a* device, but to build a platform that
can grow as requirements change.

## Common Pitfalls in IoT Projects

Many IoT projects fail—not because the hardware is difficult—but
because the software architecture is an afterthought.

Common mistakes include:
- Hard-coding device assumptions into backend services
- Treating MQTT topics as an API contract without versioning
- Ignoring updates, failures, and observability
- Building one-off solutions that can’t be extended

These are architectural problems, not hardware ones.

## IoT Articles and Deep Dives

The articles below expand on specific aspects of the system and are
intended to be read independently or as part of a larger whole.

### Architecture & System Design
- [Edge Device Architecture](/iot/edge-device-architecture/)
- [IoT Device Management](/iot/iot-device-management/)
- [Building an IoT Device Manager in Go](/iot/building-iot-device-manager-in-go/)

### Software Engineering Foundations
- [System Design Principles](/software/system-design-principles/)
- [SDLC for Small Teams](/software/sdlc-for-small-teams/)

Each article focuses on *why* a design choice was made, not just *how*
it was implemented.
