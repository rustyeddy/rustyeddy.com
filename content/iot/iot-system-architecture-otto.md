---
title: "The Five Layers of a Practical IoT System"
subtitle: "How OttO maps to device, protocol, edge, backend, and application layers"
date: 2025-11-15
description: "A practical five-layer IoT architecture: devices, protocols, edge runtime, backend, and applications, with when to add each layer and where OttO fits."
tags: ["IoT Architecture", "IoT System Design", "Edge Computing", "OttO", "Device Management"]
categories: ["IoT Systems", "Edge Computing"]
author: "Rusty Eddy"
slug: "iot-system-architecture-explained"
summary: "A practical five-layer model for IoT architecture, grounded in the OttO edge runtime and the Gardener reference application."
aliases:
  - /iot/iot-system-architecture-device-to-cloud/
---

A useful IoT architecture separates the physical system from the software that
coordinates it. Devices sense and actuate. Protocols move data. Edge runtimes
coordinate local behavior. Backend services provide durable state.
Applications turn the system into something people can inspect and control.

This page is for engineers and leads who need to decide where device logic
ends, where edge coordination begins, and how telemetry, control, APIs,
storage, and user interfaces fit together. It is the baseline architecture
behind the IoT projects on this site, with [OttO](/projects/otto/) as the
reference edge runtime. It is not the one correct design. It is a starting
point that can grow beyond a demo without locking the system to one board, one
sensor, one database, or one user interface.

## The System at a Glance

![High-level IoT system overview showing devices connected to an edge hub, backend services, and user interfaces](/diagrams/iot-architecture.svg)

The diagram reads left to right: physical devices connect to an edge hub, the
hub bridges messaging and APIs, backend services keep durable state, and user
interfaces consume those stable boundaries. Each layer talks to the next
through an explicit interface. That separation is what lets a system replace
hardware, add dashboards, test logic without devices, and survive intermittent
network connections.

## Why This Matters

Most IoT projects that fail do not fail because the sensor was impossible to
read. They fail because architecture was an afterthought: device behavior
leaks into the backend, UI assumptions leak into firmware, MQTT topics become
accidental APIs, and every piece becomes hard to replace.

Clear layers make it cheaper to swap hardware, test behavior on a laptop, add
user interfaces, and keep local automation working when the network is
unreliable. For a team, they also make ownership clear: each layer has a
contract that can be reviewed and tested on its own.

## Layer 1: Devices and Sensors

The device layer touches the physical world:

- Soil moisture sensors.
- Temperature, humidity, and pressure sensors.
- Buttons and switches.
- Pumps, relays, motors, and lights.
- Displays and local indicators.

This layer should own sensing, actuation, and minimal local safety behavior.
It should not own product workflows, long-term storage, or UI assumptions.
Business logic buried in firmware is expensive to change, and small devices
are easier to replace when the hardware changes. In the
[self-watering garden](/iot/self-watering-garden/), a collection station reads
moisture and drives hardware while the gateway handles coordination.

In the OttO ecosystem, the companion `devices` library is the hardware
abstraction boundary. A sensor or actuator exposes a small typed interface,
and application code stays independent of the GPIO, I2C, UART, or ADC details.
See [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/).

## Layer 2: Protocols and Communication

Real IoT systems rarely use one protocol. A single deployment can include:

- GPIO for switches and relays.
- I2C for sensors and ADC chips.
- SPI for displays or high-speed peripherals.
- UART or serial links for GPS and industrial devices.
- MQTT or HTTP for network communication.
- Vendor-specific protocols that have to be wrapped.

The protocol layer should isolate those differences. Application logic should
not care whether a moisture reading came from an analog input, an I2C SeeSaw
sensor, or a mock.

On the network side, two patterns dominate, and most systems want both:

```text
        Telemetry            Commands
    Devices --------> MQTT <-------- Backend
                        |
                        v
                     Edge Hub
```

- **MQTT (publish/subscribe)** for telemetry and events. It decouples
  producers from consumers, tolerates intermittent connections, and lets
  several subscribers react to one reading without changing device code.
  Its topics and payloads are API contracts and need naming and versioning
  rules.
- **REST** for configuration, control, and external integrations. It gives
  explicit request/response semantics and is easier to document, version, and
  secure for user-facing operations.

MQTT for telemetry and REST for configuration and control keeps high-volume
readings out of request/response APIs while preserving clear control
boundaries. The [OttO edge gateway](/iot/iot-edge-gateway/) page covers both
boundaries in detail, with code.

## Layer 3: Edge Runtime

The edge runtime is the local coordination layer. It usually runs on a
Raspberry Pi, an industrial Linux gateway, an embedded router, or a small
server near the devices. It is where coordination belongs when devices must
keep working without a reliable internet connection.

Typical edge responsibilities:

- Registering devices.
- Translating between device protocols, MQTT, and HTTP.
- Running local automation rules.
- Publishing telemetry and accepting commands.
- Buffering data when the network is unavailable.
- Exposing local REST or WebSocket APIs for dashboards.
- Reporting device errors and health.

Not every system needs an edge hub. A single device can sometimes talk
directly to a backend. But adding a hub later is painful if devices and
backend were designed as a tightly coupled pair.

This is where OttO sits. In its current form
([otto@09836d0](https://github.com/rustyeddy/otto/tree/09836d0)), OttO wires
typed devices to MQTT through a registry: each device publishes its state and
accepts commands on its own topics, the registry keeps each device's latest
state, and a rules package runs edge automation such as making one device
follow another. The same code runs on a Raspberry Pi or on a laptop with mock
devices. The earlier gateway also served REST and WebSocket APIs to the
dashboard; that server code is archived while the runtime is rebuilt.

The [Gardener](https://github.com/rustyeddy/gardener) reference application
uses this shape for irrigation: a soil moisture sensor and a pump relay are
wired through OttO's registry, a controller starts the pump below a dry
threshold and stops it above a wet one, and a small web page shows state and
offers manual control.

## Layer 4: Backend and Control Plane

The backend is the durable system of record. It may run locally, in the
cloud, or both. Typical responsibilities:

- Long-term telemetry storage.
- Device identity and metadata.
- User authentication and authorization.
- Remote command dispatch.
- Configuration management.
- Diagnostics and health reporting.
- Fleet-level analytics.

An edge runtime can integrate with a backend over MQTT, REST, or WebSockets,
but it does not remove the need to design one. The backend still needs clear
ownership of identity, authorization, history, and integration with other
systems.

The key boundary: backend services talk to devices through messages and APIs,
never through hardware assumptions. That is what lets simulation, testing,
hardware migration, and several device generations coexist.

## Layer 5: Applications and Integrations

The application layer is where people and external systems interact with the
deployment:

- Dashboards and mobile-friendly control pages.
- Alerting and notifications.
- Reports and historical charts.
- Third-party integrations.
- Administrative tools.

Applications sit at the edge of the system, not the center. They present
state and collect user intent. They should not reach around the edge runtime
to control physical devices directly. UI-to-device shortcuts are convenient in
a demo and expensive in production.

In the Gardener example, the web page shows readings and sends manual pump
commands through MQTT topics, with no assumptions about GPIO pins or sensor
buses.

## Which Pieces You Actually Need

The five layers describe responsibilities, not mandatory components. Small
systems can start with fewer pieces as long as the boundaries stay clear.

| Component | Use it when | Avoid or defer it when |
| --- | --- | --- |
| Device firmware | The device must sense, actuate, or perform minimal local safety behavior | Business rules, dashboards, and storage can live elsewhere |
| Edge hub | Several devices need local coordination, protocol translation, buffering, or offline behavior | A single device can safely talk directly to a backend |
| MQTT | Telemetry or events need publish/subscribe decoupling | You need request/response semantics or human-facing APIs |
| REST API | Configuration, control, or integrations need stable endpoints | High-frequency telemetry is the main workload |
| Backend service | You need long-term storage, auth, fleet state, or integration with other systems | The system must operate entirely offline and local-only |
| Dashboard/UI | People need monitoring, configuration, or manual control | The system is autonomous and observable elsewhere |
| Cloud service | Fleet-wide storage, remote access, or multi-site coordination is required | Local operation and privacy matter more than remote access |

## Cross-Cutting Concerns

Several concerns cut across all five layers.

### Security

Device identity, transport encryption, API authorization, local network
exposure, and update paths. An edge runtime can take part in secure transports
and identity-aware integrations, but the deployment still needs a security
model.

### Reliability

Device read errors, failed connections, reboots, stale data, and offline
operation. Local buffering and clear error states matter more than optimistic
assumptions about perfect connectivity.

### Observability

Logs, metrics, device health, and enough telemetry to diagnose field failures.
A reading of zero and a failed sensor read are not the same thing.

### Updates

Firmware, edge binaries, dashboards, and backend services all need an update
story. The mechanism depends on the device class and deployment, but ignoring
updates creates long-term operational risk.

## Where OttO Fits

OttO is an edge runtime that connects Layers 1 through 3 and integrates upward
into Layers 4 and 5.

| Layer | OttO role |
| --- | --- |
| Devices and sensors | Uses typed device abstractions from the `devices` library |
| Protocols | Hides GPIO/I2C/UART/ADC differences behind device interfaces; carries state and commands over MQTT |
| Edge runtime | Registers devices, keeps their latest state, runs local rules |
| Backend/control plane | Integrates through MQTT topics with JSON payloads |
| Applications | Provides the state and command surfaces dashboards and tools build on |

That is why OttO suits a project like the self-watering garden, and why it
should not be described as the whole IoT platform. It is the edge runtime and
device boundary that make the rest of the platform easier to build.

## Common Pitfalls

```text
[ Device ] ---> [ Database ]
```

Yes, people really do this. The usual mistakes:

- Putting product rules or backend logic into device firmware.
- Treating MQTT topics as unversioned strings instead of API contracts.
- Assuming the cloud connection is always available.
- Letting dashboard requirements leak into sensor code.
- Hiding protocol-specific errors behind generic readings.
- Designing for one device instead of a system.
- Treating the edge hub as a dumping ground for unrelated responsibilities.
- Calling the edge runtime a cloud platform when it only owns the local layer.

These shortcuts feel productive early and become expensive later.

## Where to Go Next

- [OttO: A Go-Based IoT Edge Gateway Architecture](/iot/iot-edge-gateway/)
  covers the MQTT and REST boundaries in detail.
- [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/)
  covers Layer 1 and the device interface.
- [Self-Watering Garden](/iot/self-watering-garden/) shows the layers in an
  end-to-end project.
- [OttO: IoT Edge Runtime](/projects/otto/) is the project page.
