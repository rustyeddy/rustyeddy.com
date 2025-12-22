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

## Why IoT?

IoT projects sit at the intersection of multiple disciplines:

> IoT software combines embedded systems, backend services, APIs,
> messaging, and user-facing applications.

Few domains force you to think simultaneously about:
- Resource-constrained devices
- Unreliable networks
- Distributed systems
- Real-time data
- Long-lived software in the field

That makes IoT an excellent proving ground for professional software
engineering principles.

## Diversity of Technology

These projects intentionally span a wide range of technologies:

- **Embedded devices**  
  Code running on small, real-time systems such as ESP32s and Raspberry
  Pi Pico devices, using C++, Python and my favorite Go.

- **Edge and hub systems**  
  Device aggregation and integration using Raspberry Pi and Go.

- **User interfaces**  
  Web and mobile interfaces built with JavaScript and React.

The emphasis is not on mastering every tool, but on understanding how
these pieces fit together into a coherent system.

## Building Extensible Systems with APIs

A recurring theme throughout these projects is **extensibility**.

We build:
- Public REST APIs
- MQTT-based publish/subscribe messaging
- Cloud-backed services accessible from anywhere

From a technical perspective, IoT systems are interesting precisely
because they require many disparate components to work together
reliably over time.

They also demand coordination between:
- Users
- Software developers
- Electrical and mechanical designers
- Operators and maintainers

This is not accidental complexity—it’s the nature of real IoT systems.

## Project Overview

The initial project focuses on a simple but representative system:

- A physical device that collects temperature and humidity data
- A backend service that processes and stores that data
- A web interface that displays live readings from anywhere
- A relay-controlled switch to remotely control a physical device

This foundation is intentionally generic so it can be extended into
other IoT projects without rewriting the system from scratch.

## Architecture

The system is designed to be **loosely coupled** and interchangeable.

While an initial implementation might use a Raspberry Pi or ESP32, the
architecture allows entirely different devices to be integrated by
conforming to the same APIs and messaging contracts.

This approach:
- Reduces vendor lock-in
- Encourages experimentation
- Makes systems easier to extend and maintain

The goal is not just to build *a* device, but to build a platform that
can grow.

## What Comes Next

Below you’ll find articles that dive deeper into specific parts of the
system—architecture decisions, messaging patterns, device abstractions,
and operational considerations.

Each article focuses on *why* a design choice was made, not just *how*
it was implemented.

