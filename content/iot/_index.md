---
title: Internet of Things (IoT)
description: >
  A software-first guide to IoT systems: device boundaries, edge gateways,
  APIs, messaging, and maintainable embedded-to-cloud architecture.
tags: [iot, maker, software-architecture]
date: 2023-01-13
show_articles: false
---

This section is for engineers who want IoT systems to behave like software
systems, not one-off hardware demos.

If you care about device boundaries, gateway responsibilities, APIs, messaging,
observability, and long-term maintainability, start here. Wiring details and
board bring-up matter, but the main focus is how the pieces fit together after
the prototype works.

## Start With the Architecture

These are the pillar articles for the IoT section:

- [IoT System Architecture: Device to Cloud](/iot/iot-system-architecture-device-to-cloud/) explains the device, gateway, API, and cloud boundaries.
- [Five Layers of a Practical IoT System](/iot/iot-system-architecture-otto/) gives a compact model for organizing real IoT systems.
- [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/) shows how to keep application logic separate from hardware details.
- [OttO Edge Gateway Architecture](/iot/iot-edge-gateway/) describes the Go-based edge runtime behind the reference implementation.

## Implementation Notes

Use these when you want a narrower design or implementation detail:

- [Adding MQTT to the IoT Gateway](/iot/iot-gateway-mqtt/) covers telemetry and publish/subscribe boundaries.
- [REST APIs for IoT Gateways](/iot/iot-gateway-rest/) covers control, configuration, and telemetry access over HTTP.
- [ESP32 Collection Station Architecture](/iot/iot-sensor-station/) describes the device-side responsibilities in a sensor network.
- [Self-Watering Garden](/iot/self-watering-garden/) ties the pieces together as a small end-to-end case study.

## Related Project Work

The IoT articles connect most directly to [OttO](/projects/otto/), the edge
runtime, and to older robotics/video work such as [RedEye](/projects/redeye/).
Project pages are case studies and reference implementations. Notes are smaller
working references. The articles in this section are the canonical architecture
path.
