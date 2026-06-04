---
title: "The Five Layers of a Practical IoT System"
subtitle: "How OttO maps to device, protocol, edge, backend, and application layers"
date: 2025-11-15
description: >
  A practical five-layer model for IoT systems, showing how devices,
  protocols, edge runtime, backend services, and applications fit together.
tags: ["IoT Architecture", "IoT System Design", "Edge Computing", "OttO", "Device Management"]
categories: ["IoT Systems", "Edge Computing"]
author: "Rusty Eddy"
slug: "iot-system-architecture-explained"
summary: "A practical five-layer model for IoT architecture, grounded in the OttO edge runtime and the Gardener reference application."
cover:
  image: "/images/iot-architecture-cover.jpg"
  alt: "Diagram showing the five layers of IoT system architecture"
  caption: "The five layers of IoT architecture."
---

A useful IoT architecture separates the physical system from the software that
coordinates it. Devices sense and actuate. Protocols move data. Edge runtimes
coordinate local behavior. Backend services provide durable state. Applications
turn the system into something people can inspect and control.

## Why This Matters

Layering keeps IoT systems from collapsing into one large device-specific
program. Clear layers make it easier to replace hardware, test behavior on a
laptop, add user interfaces, and keep local automation working when the network
is unreliable.

This article uses a five-layer model to explain those responsibilities. It is
a companion to the diagram-first [device-to-cloud architecture overview](/iot/iot-system-architecture-device-to-cloud/).
That page shows the full shape of the system. This page explains the layers
and shows where [OttO](/projects/otto/) fits.

OttO is not a complete cloud platform. It is a Go-based edge runtime and
device-management layer. It helps with device abstraction, local polling,
MQTT/HTTP integration, local persistence, and mock-friendly development. The
backend, cloud control plane, dashboard, and deployment model still need to be
designed around the specific product.

## Layer 1: Devices and Sensors

The device layer touches the physical world:

- Soil moisture sensors.
- Temperature, humidity, and pressure sensors.
- Buttons and switches.
- Pumps, relays, motors, and lights.
- Displays and local indicators.

This layer should be responsible for sensing, actuation, and minimal local
safety behavior. It should not own product workflows, long-term storage, or UI
assumptions.

In the OttO ecosystem, the companion `devices` library provides the hardware
abstraction boundary. A sensor or actuator exposes a small typed interface,
while the application code stays independent of the specific GPIO, I2C, UART,
or ADC implementation. For more detail, see [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/).

## Layer 2: Local Protocols and Device Communication

Real IoT systems rarely use one protocol. A single deployment can include:

- GPIO for switches and relays.
- I2C for sensors and ADC chips.
- SPI for displays or high-speed peripherals.
- UART or serial links for GPS and industrial devices.
- MQTT or HTTP for network communication.
- Vendor-specific protocols that have to be wrapped.

The protocol layer should isolate those differences. Application logic should
not care whether a moisture reading came from an analog input, an I2C SeeSaw
sensor, or a mock implementation.

OttO's role here is indirect but important: it expects devices to present a
consistent interface above the protocol layer. That lets lower-level drivers
change without rewriting the edge runtime or dashboard code.

## Layer 3: Edge Runtime

The edge runtime is the local coordination layer. It usually runs on a
Raspberry Pi, industrial Linux gateway, embedded router, or small server near
the devices.

Typical edge responsibilities include:

- Registering devices.
- Polling sensors on configurable intervals.
- Running local automation rules.
- Publishing telemetry.
- Accepting commands.
- Buffering data when the network is unavailable.
- Exposing local REST or WebSocket APIs.
- Reporting device errors and health state.

This is where OttO is strongest. OttO provides a `DeviceManager`, polling
loops, MQTT/HTTP integration, local persistence, and a runtime structure that
can run on embedded Linux or a laptop with mocks.

The [Gardener](https://github.com/rustyeddy/gardener) reference application
uses this shape for irrigation: collection stations produce readings, the edge
runtime coordinates telemetry and control, and the dashboard shows the system
state.

## Layer 4: Backend and Control Plane

The backend layer is the durable system of record. It may run locally, in the
cloud, or both.

Typical backend responsibilities include:

- Long-term telemetry storage.
- Device identity and metadata.
- User authentication and authorization.
- Remote command dispatch.
- Configuration management.
- Diagnostics and health reporting.
- Fleet-level analytics.

OttO can integrate with a backend through MQTT, HTTP/REST, or WebSockets, but
it does not remove the need for backend design. The backend still needs clear
ownership of identity, authorization, historical storage, and external system
integration.

The key boundary is this: backend services should talk to devices through
messages and APIs, not through hardware assumptions.

## Layer 5: Applications and Integrations

The application layer is where people and external systems interact with the
IoT deployment.

Examples include:

- Dashboards.
- Mobile-friendly control pages.
- Alerting and notification systems.
- Reports and historical charts.
- Third-party integrations.
- Administrative tools.

Applications should present system state and user intent. They should not
reach around the edge runtime to control physical devices directly. UI-to-device
shortcuts are useful in demos and expensive in production.

In the Gardener example, the dashboard can show moisture readings, expose
manual controls, and adjust thresholds. It should do that through the edge or
backend API, not by embedding assumptions about GPIO pins or sensor buses.

## Cross-Cutting Concerns

The five layers are not enough by themselves. Several concerns cut across all
of them.

### Security

Security includes device identity, transport encryption, API authorization,
local network exposure, and update paths. OttO can participate in secure
transports and identity-aware integrations, but the deployment still needs a
security model.

### Reliability

Reliability means handling device read errors, failed network connections,
reboots, stale data, and offline operation. Local buffering and clear error
states matter more than optimistic assumptions about perfect connectivity.

### Observability

An IoT system needs logs, metrics, device health, and enough telemetry to
diagnose field failures. A reading of zero and a failed sensor read are not the
same thing.

### Updates

Firmware, edge runtime binaries, dashboards, and backend services all need an
update story. The right mechanism depends on the device class and deployment,
but ignoring updates creates long-term operational risk.

## Where OttO Fits

OttO is best understood as an edge runtime that connects Layers 1 through 3
and integrates upward into Layers 4 and 5.

| Layer | OttO role |
| --- | --- |
| Devices and sensors | Uses typed device abstractions from the devices library |
| Local protocols | Hides GPIO/I2C/UART/ADC differences behind device interfaces |
| Edge runtime | Registers, polls, stores, publishes, and exposes local APIs |
| Backend/control plane | Integrates through MQTT, REST, WebSockets, and persistence boundaries |
| Applications | Provides API and telemetry surfaces for dashboards and tools |

This is why OttO is useful for a project like the self-watering garden, but
also why it should not be described as the whole IoT platform. It is the edge
runtime and device boundary that make the rest of the platform easier to build.

## Common Pitfalls

- Putting product rules directly into device firmware.
- Treating MQTT topics as accidental strings instead of API contracts.
- Assuming cloud connectivity is always available.
- Letting dashboard requirements leak into sensor code.
- Hiding protocol-specific errors behind generic readings.
- Calling the edge runtime a cloud platform when it only owns the local layer.

## Where to Go Next

- [IoT System Architecture (Device to Cloud)](/iot/iot-system-architecture-device-to-cloud/)
- [OttO: IoT Edge Runtime](/projects/otto/)
- [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/)
- [Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/)
- [Adding the REST API to IoT Gateway](/iot/iot-gateway-rest/)

## Where This Fits

This page is the compact model for the IoT architecture used across the site.
For the diagram-first version, read [IoT System Architecture: Device to Cloud](/iot/iot-system-architecture-device-to-cloud/).
For implementation details, continue to [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/)
and [OttO Edge Gateway Architecture](/iot/iot-edge-gateway/).
