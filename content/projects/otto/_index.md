---
title: "OttO — IoT Edge Runtime"
date: 2026-05-22
description: "OttO is an open-source Go runtime for IoT edge devices: typed sensors and actuators, MQTT topics per device, local rules, and mocks for laptop development."
github: https://github.com/rustyeddy/otto
project_status: Reference implementation
tags: ["Go", "IoT", "Edge Computing", "Device Management", "MQTT"]
categories: ["Projects", "IoT Systems"]
image: /img/iot-project-drawing.png
image_alt: "System illustration of the OttO IoT edge runtime connecting sensors, control nodes, and gateway services."
---

OttO is an open-source runtime, written in Go, for the software that runs
next to sensors and actuators on embedded Linux: a Raspberry Pi, an industrial
gateway, an ARM board. The same code runs on a developer's laptop with mock
devices. It is the reference implementation for the
[five-layer IoT architecture](/iot/iot-system-architecture-explained/), where
it fills the edge runtime layer, and for the
[device abstraction layer](/iot/building-iot-device-manager-in-go/). The
[OttO edge gateway](/iot/iot-edge-gateway/) article covers its MQTT and REST
boundaries in depth.

## Project Status

**Reference implementation, rebuilt in 2026.** In January 2026 OttO and its
`devices` library were rewritten around channel-based devices and a
per-device MQTT topic scheme. The original gateway's station server, REST data
API, WebSocket dashboard, and in-memory data store were archived in the repo
at that point. This page describes the code as of
[otto@09836d0](https://github.com/rustyeddy/otto/tree/09836d0) and
[devices@3a64fbc](https://github.com/rustyeddy/devices/tree/3a64fbc).

What works today:

- Typed sensor, actuator, and mock devices in the `devices` library.
- A registry that wires each device to its own MQTT topics, with JSON
  payloads and online/offline status.
- A rules package for edge automation.
- An `otto serve` command with structured logging and a log endpoint, plus
  systemd and container packaging.

Not in the current code: a REST data API, a WebSocket dashboard, and local
persistence. Those belonged to the original gateway and have not been rebuilt
yet.

## Why This Matters

OttO is the working example behind the site's IoT architecture. It shows how
device abstractions, MQTT messaging, and edge rules fit together in one
runtime instead of remaining separate examples, and it keeps each concern
behind a boundary that can be tested without hardware.

## The Problem

IoT device management compounds in complexity as a project scales. A
prototype with one sensor and one actuator becomes a different engineering
problem when the device count grows, hardware varies across platforms, and the
system needs to keep working when the network or broker goes away.

The typical approach is tight coupling: hardware drivers mixed into
application logic, everything specific to one board, tests that need physical
hardware on the bench. It works for the prototype and becomes expensive to
maintain.

OttO's goal is to break that coupling at the right boundaries.

## Architecture

The system spans three repositories.

**devices** is the hardware layer. Drivers wrap GPIO, I²C, analog input
through an ADS1115, serial, and an OLED display, behind Linux and ARM build
tags with stubs for other platforms. Device packages build on them: a BME280
environment sensor, a VH400 soil moisture sensor, buttons, LEDs, relays, and a
GT-U7 GPS. Every device follows one lifecycle contract and owns its own
goroutines and channels:

```go
type Device interface {
    Name() string
    Run(ctx context.Context) error
    Close() error
    Events() <-chan Event
}

// Source emits typed values: sensors, buttons, GPS fixes.
type Source[T any] interface {
    Device
    Out() <-chan T
}

// Sink consumes typed commands: relays, motors, LEDs.
type Sink[T any] interface {
    Device
    In() chan<- T
}
```

A soil sensor is a `Source[float64]`, a pump relay is a `Sink[bool]`, and the
BME280 is a `Source[Env]` with temperature, humidity, and pressure. The type
is fixed at compile time, so a relay can't be wired where a moisture reading
is expected.

**otto** is the runtime. Its `messenger` registry connects devices to MQTT,
its `rules` package runs edge automation, and `otto serve` provides the
process shell: structured logging and graceful shutdown.

**gardener** is the reference application (see below).

## Key Design Decisions

**Channels instead of get and set.** Devices push values out and take
commands in over channels rather than being polled by a central manager.
Polling sensors take an interval and a choice of what to do when the consumer
falls behind: drop the new sample, or block until it is delivered. That makes
backpressure a configured decision instead of an accident.

**One topic scheme per device.** The registry gives every device the same five
topics under a prefix:

```text
{prefix}/devices/{name}/state    latest value, JSON
{prefix}/devices/{name}/set      commands to the device
{prefix}/devices/{name}/event    lifecycle and error events
{prefix}/devices/{name}/status   online or offline, retained
{prefix}/devices/{name}/meta     kind, value type, access, unit, range
```

Status uses an MQTT last-will message, so a device that drops off the network
is reported offline without anyone polling it. A command on a `set` topic is
delivered to the device with a timeout, two seconds by default, so a stuck
device can't wedge the MQTT callback. On every reconnect the registry
reapplies its subscriptions.

Wiring a device is a few lines:

```go
soil := mock.NewSensor(mock.SensorConfig[float64]{
    Name:        "soil",
    Interval:    10 * time.Second,
    Initial:     25.0,
    EmitInitial: true,
})

client := ottomqtt.New(ottomqtt.Config{Broker: "tcp://localhost:1883"})
reg := messenger.NewRegistry(client, messenger.TopicScheme{Prefix: "gardener"})
reg.Add(soil)
messenger.WireSource(ctx, reg, soil, codec.JSON[float64]{})

client.SetOnConnect(func() { reg.ResubscribeAll(ctx) })
if err := client.Connect(ctx); err != nil {
    log.Fatal(err)
}
log.Fatal(reg.Run(ctx)) // starts the devices; blocks until ctx is done
```

That publishes the mock sensor's readings to `gardener/devices/soil/state`.
Swapping the mock for a real VH400 changes the constructor and nothing else.

**Mock-first development.** The `devices/mock` package provides interval
sensors, scripted sensors that replay a sequence, and switches, and the
drivers have mock modes, so control loops, thresholds, and MQTT publishing can
be developed and tested on a laptop. Deploying to a Raspberry Pi is a
cross-compile:

```bash
GOOS=linux GOARCH=arm64 go build -o otto-arm64 ./cmd/otto
```

**Rules as small runnable units.** A rule has a name and a `Run(ctx)` method,
and a runner starts them together. The current rules are `Follow`, which
copies one device's values into another, and `ToggleOnRisingEdge`, which flips
a relay when a button is pressed.

## Reference Application: Gardener

The [Gardener](https://github.com/rustyeddy/gardener) is the reference
application: automated irrigation for a succulent garden, the project that
motivated OttO.

It reads a VH400 soil moisture sensor and a BME280, and drives a pump relay,
two buttons, and an OLED display. A controller turns the pump on when moisture
drops below a dry threshold and off once it reaches a wet threshold (20% and
60% by default), so the pump doesn't chatter around a single set point. Sensor
state goes out on `gardener/devices/...` topics, the pump accepts commands on
its `set` topic, and a small web page subscribes to the sensor topics and offers manual pump
control over MQTT.
With `-mock`, every sensor and output is simulated. If the broker is
unreachable at startup, Gardener keeps watering on its local rules.

Gardener is being ported to the rebuilt OttO and `devices` APIs. The same
shape, sensor to edge runtime to actuator plus a control surface, applies to
any IoT control system, not just irrigation.

## Common Pitfalls

An edge runtime becomes hard to maintain when hardware drivers leak into
application logic, when every device has a bespoke code path and topic
layout, when the broker or cloud is assumed to be always reachable, or when
ordinary behavior can only be tested on real hardware. OttO pushes each of
those problems to an explicit boundary: the device contract, the topic scheme,
reconnect handling, and mocks.

## Where This Fits

OttO is the proof project for the IoT articles:

- [The Five Layers of a Practical IoT System](/iot/iot-system-architecture-explained/)
  is the architecture OttO implements.
- [OttO: A Go-Based IoT Edge Gateway Architecture](/iot/iot-edge-gateway/)
  covers the MQTT device boundary and the REST application boundary.
- [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/)
  explains the device boundary in Go.
- [Self-Watering Garden](/iot/self-watering-garden/) is the end-to-end case
  study.

## Repositories

- [rustyeddy/devices](https://github.com/rustyeddy/devices): device
  contracts, hardware drivers, device packages, and mocks
- [rustyeddy/otto](https://github.com/rustyeddy/otto): edge runtime, MQTT
  registry and topics, rules, and the `otto` command
- [rustyeddy/gardener](https://github.com/rustyeddy/gardener): reference
  irrigation application
