---
title: OttO — IoT Edge Runtime
date: 2026-05-22
description: >
  An open-source IoT edge runtime in Go that manages sensors and actuators
  across embedded Linux hardware with a type-safe device abstraction layer,
  offline-first behavior, and a mock-friendly design for laptop development.
github: https://github.com/rustyeddy/otto
tags: ["Go", "IoT", "Edge Computing", "Device Management"]
categories: ["Projects", "IoT Systems"]
image: /img/iot-project-drawing.png
---

OttO is an open-source IoT edge runtime written in Go, designed to manage
a fleet of sensors and actuators on embedded Linux hardware — Raspberry Pi,
industrial gateways, ARM SBCs — with the same codebase that runs cleanly
on a developer's laptop.

## Why This Matters

OttO is the reference implementation for the site's IoT architecture. It shows
how device abstractions, local persistence, MQTT, REST APIs, and dashboard
behavior fit together in an edge runtime instead of remaining separate examples.

The project spans three repositories following a strict layered architecture:
a hardware abstraction library, an edge runtime framework, and a reference
application that exercises the full stack.

## The Problem

IoT device management compounds in complexity as a project scales. A working
prototype with one sensor and one actuator becomes a different engineering
problem when the device count grows, hardware varies across platforms, and
the system needs to stay operational without a network connection.

The typical approach is tight coupling: hardware drivers mixed into
application logic, everything specific to one board, tests requiring physical
hardware on the bench. It works for the prototype. It becomes expensive to
maintain.

OttO's goal is to break that coupling at the right boundary.

## Architecture

The system is organized into three layers across two repositories.

**Drivers** — thin, hardware-specific wrappers around platform interfaces:
GPIO, I²C, SPI, UART, ADC. They know nothing about the application.

**Devices** — a hardware abstraction layer built on Go generics. The core
interface is `Device[T any]`:

```go
type Device[T any] interface {
    ID() string
    Open() error
    Close() error
    Get() (T, error)
    Set(v T) error
}
```

Each device declares its own data type. A `Button` produces `bool`. A
`Meter` produces `int`. An environmental sensor produces a struct:

```go
type Env struct {
    Temp, Humidity, Pressure float64
}
```

The constraint captures the type at compile time — you cannot pass a
`Device[bool]` where a `Device[Env]` is expected. The alternative (empty
interfaces or reflection) pushes those errors to runtime.

**OttO** — the edge runtime. A `DeviceManager` registers and polls devices
on configurable timers, routes telemetry via MQTT, exposes a REST and
WebSocket API, and persists data locally so automation continues working
without a cloud connection.

## Key Design Decisions

**Generics for the device interface.** The `Device[T any]` abstraction
unifies every sensor and actuator behind one interface without losing type
information. Writing a new driver means implementing four methods; the rest
of the framework picks it up automatically.

**Mock-first development.** Any device can be replaced with a mock
implementation:

```go
type MockMeter struct{ val int }

func (m *MockMeter) Get() (int, error) { return m.val, nil }
func (m *MockMeter) Set(v int) error   { m.val = v; return nil }
```

Application logic — control loops, thresholds, MQTT publishing, persistence
— is developed and tested entirely on a laptop. Deploying to a Raspberry Pi
is a cross-compile:

```bash
GOOS=linux GOARCH=arm64 go build -o otto-arm64
scp otto-arm64 pi@raspberrypi.local:/usr/local/bin/
```

**Offline-first edge behavior.** The runtime buffers telemetry locally using
BoltDB and continues running automation rules without internet access. Data
syncs when connectivity is restored. Assuming reliable cloud connectivity is
a common IoT design mistake; building around it instead of against it is not.

## Reference Application: Gardener

The [Gardener](https://github.com/rustyeddy/gardener) is the reference
application — an automated irrigation system for a succulent garden that
motivated the entire project.

Soil moisture sensors report readings via MQTT to the edge gateway. The
gateway evaluates moisture thresholds and sends pump commands to control
stations. A dashboard served by the gateway lets you monitor readings, adjust
thresholds, and trigger manual watering from any browser.

The Gardener exercises the full OttO stack: sensor drivers, the device
manager, MQTT pub/sub, the REST API, local persistence, and the web UI. The
same architecture — sensor → edge runtime → actuator + dashboard — applies
to any IoT control system, not just irrigation.

For the five-layer IoT architecture that OttO maps to, see
[IoT System Architecture](/iot/iot-system-architecture-explained/).

## Common Pitfalls

An edge runtime becomes hard to maintain when hardware drivers leak into
application logic, when every device has a bespoke code path, when cloud access
is assumed, or when tests require physical hardware for ordinary behavior. OttO
is structured to push those problems to explicit boundaries.

## Where This Fits

Read OttO alongside [IoT System Architecture](/iot/iot-system-architecture-device-to-cloud/)
and [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/).
The articles explain the architecture; this project shows the reference runtime.

## Repositories

- [rustyeddy/devices](https://github.com/rustyeddy/devices) — device
  interface, hardware drivers, and mock implementations
- [rustyeddy/otto](https://github.com/rustyeddy/otto) — edge runtime,
  DeviceManager, MQTT, HTTP/WebSocket API, persistence
- [rustyeddy/gardener](https://github.com/rustyeddy/gardener) — reference
  application and full-stack integration example
