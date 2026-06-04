---
title: "Self-Watering Garden: An IoT Architecture Case Study"
date: 2022-05-25
description: >
  A case study for a proof-of-concept self-watering garden system that
  uses soil moisture telemetry, an edge gateway, MQTT, REST APIs, and a
  dashboard to coordinate irrigation decisions.
categories:
  - iot
tags: ["IoT Architecture", "Smart Irrigation", "Soil Moisture", "MQTT", "Edge Gateway"]
summary: "A practical case study showing how a self-watering garden can be designed as an IoT system with clear device, gateway, API, and dashboard boundaries."
---

The self-watering garden is a proof-of-concept IoT system for small
gardens and irrigation zones. The goal is simple: water plants based on
soil conditions instead of a fixed timer. It is the case study behind the
[IoT System Architecture](/iot/iot-system-architecture-device-to-cloud/) and the
[OttO edge runtime](/projects/otto/).

## Why This Matters

A small garden system is large enough to expose real IoT architecture problems:
noisy sensors, local control, manual overrides, telemetry, and unreliable
networks. That makes it a useful case study without requiring industrial-scale
hardware.

That makes it a useful architecture example. A garden project sounds
small, but it has the same moving parts as many larger IoT systems:
sensors, actuators, wireless communication, an edge gateway, APIs, a
user interface, and decisions that affect the physical world.

![Self-watering garden system diagram showing collection stations, smart hub, control station, dashboard, and cloud components](/img/self-watering-garden.png)

## Why Build It

Most small irrigation systems are schedule based. A controller opens a
zone at a configured time, runs for a configured duration, and repeats
that schedule regardless of the actual soil condition.

That is easy to understand, but it ignores useful context:

- Recent rain may make watering unnecessary.
- Hot dry days may require more water.
- Different plants need different moisture ranges.
- A raised bed, container, and in-ground zone can dry out at different
  rates.

A sensor-driven system can make a better local decision: water when the
soil is too dry, stop when the target moisture range has been reached,
and leave the zone alone when it does not need water.

## Project Status

This project should be read as a proof of concept and architecture
case study, not as a finished commercial irrigation product.

The important part is the system boundary. The project explores how a
collection station, control station, edge gateway, and dashboard fit
together. It is less about one exact sensor or board and more about how
the pieces communicate without becoming tightly coupled.

## System Components

The system has four primary runtime components.

### Collection Station

A collection station is the device-side telemetry node. It reads soil
moisture and other environmental data, then publishes those readings to
the gateway.

The original project used ESP-class hardware for this role. The exact
board can change as long as the station can read the sensor, connect to
the local network, and publish data using the expected message contract.

![Collection station diagram showing soil moisture and telemetry sensors sending data over Wi-Fi](/img/collection-station.png)

Soil moisture sensing deserves special attention because cheap sensors
can be noisy or unreliable. These notes cover that layer in more detail:

- [Soil Moisture Sensors](/notes/soil-moisture-sensor/)
- [Adafruit Soil Moisture Sensor Notes for IoT Projects](/notes/soil-moisture-adafruit/)

### Control Station

A control station is the actuator side of the system. It receives a
command and switches something physical, such as a sprinkler valve,
pump, relay, light, or heater.

![Control station diagram showing an IoT controller connected to watering equipment](/img/control-station.png)

The control station should stay deliberately small. It should know how
to execute a command safely, report its state, and fail predictably. It
should not need to know the full garden policy or dashboard workflow.

### OttO Edge Gateway

The gateway, called OttO in this project, is the coordinating layer. It
receives telemetry from collection stations, keeps recent state, exposes
APIs, streams dashboard updates, and publishes control commands when the
application logic decides a zone should change state.

This is the most important software boundary in the project. Sensors do
not talk directly to dashboards. Dashboards do not talk directly to
valves. The gateway sits between them and gives each side a stable
interface.

See [OttO: A Go-Based IoT Edge Gateway Architecture](/iot/iot-edge-gateway/)
for the gateway architecture.

### Dashboard

The dashboard is the human-facing application. It should let a user
observe current readings, inspect zone state, adjust thresholds, and
manually override a zone when needed.

The dashboard should use the gateway's REST and WebSocket APIs. It
should not subscribe directly to raw device topics or depend on internal
Go data structures. That keeps the UI replaceable and keeps device
messaging hidden behind the gateway boundary.

## Data and Control Flow

A normal watering decision follows this loop:

1. A collection station samples soil moisture.
2. The station publishes the reading over MQTT.
3. OttO receives the message and updates its local state.
4. Application logic compares the reading against the zone threshold.
5. If watering is needed, OttO publishes a command to the control
   station.
6. The control station opens the valve or starts the pump.
7. New moisture readings continue to arrive while watering is active.
8. OttO sends a stop command when the target moisture range is reached.
9. The dashboard shows the current readings and zone state.

This loop is intentionally event driven. The collection station reports
what it sees. The gateway decides what that means. The control station
performs the physical action.

## MQTT, REST, and WebSockets

The project uses different protocols for different boundaries.

MQTT is the device messaging boundary. Collection stations and control
stations can publish or subscribe to small topic-based messages without
knowing about the dashboard or REST API. See
[Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/).

REST is the request/response boundary for clients that need structured
access to state and configuration. It is useful for dashboards, tests,
admin tools, and backend services. See
[Adding the REST API to IoT Gateway](/iot/iot-gateway-rest/).

WebSockets are useful for live dashboard updates. The browser can stay
connected to OttO and receive changes as new telemetry arrives instead
of polling repeatedly.

These boundaries keep the system easier to reason about. Devices speak
MQTT. Applications use HTTP and WebSockets. The gateway translates
between those worlds.

## Cloud Boundary

The cloud is optional in this proof of concept.

A later system could send selected data to a hosted backend for durable
storage, remote access, alerts, analytics, or fleet management. Those
are useful capabilities, but they are not required for the local control
loop.

That distinction is important. Watering should continue to work on the
local network even if an internet connection is down. Cloud services can
extend the system, but they should not be required for basic irrigation
control.

## Common Pitfalls

### Letting Sensor Noise Drive Commands

Soil moisture readings can be noisy. A single low reading should not
necessarily turn on a pump. The control logic should use thresholds,
hysteresis, smoothing, or repeated readings so it does not rapidly turn
equipment on and off.

### Putting Policy on the Device

Collection stations should collect data. Control stations should switch
equipment. If every device owns its own policy, the system becomes hard
to inspect and update. Keeping policy in the gateway makes behavior more
visible and testable.

### Treating the Dashboard as the System

A dashboard is an interface, not the architecture. The watering loop
should keep working without a browser open. The dashboard should observe
and configure the system, not be the only place where control decisions
exist.

### Depending on the Cloud for Local Control

Remote access and historical reporting are useful, but basic watering
should not require a hosted service. The local gateway should be capable
of making the core decision close to the devices.

## Where This Fits

The self-watering garden ties together the rest of the IoT articles:

- [Building an IoT Device Manager in Go](/iot/building-iot-device-manager-in-go/)
  explains the device abstraction behind replaceable sensors and
  actuators.
- [IoT System Architecture: Device to Cloud](/iot/iot-system-architecture-device-to-cloud/)
  describes the broader device-to-cloud model.
- [OttO: A Go-Based IoT Edge Gateway Architecture](/iot/iot-edge-gateway/)
  describes the edge gateway role.
- [Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/) covers the
  device messaging path.
- [Adding the REST API to IoT Gateway](/iot/iot-gateway-rest/) covers
  the client-facing API boundary.
