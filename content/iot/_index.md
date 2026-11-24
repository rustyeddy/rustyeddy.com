---
title: "IoT Architecture Case Studies"
description: "IoT case studies from OttO and a self-watering garden: device boundaries, edge gateways, MQTT messaging, and the delivery lessons behind each design."
tags: [iot, maker, software-architecture]
date: 2023-01-13
lastmod: 2026-11-23
show_articles: false
---

These are case studies, not a separate track. The main subject of this site
is delivering software well, increasingly with AI agents doing part of the
work; see [Software Delivery for Small Teams](/software/). IoT is where I
test those ideas against hardware, flaky networks, and devices that fail in
the field, which makes the tradeoffs hard to ignore.

The reference implementation is [OttO](/projects/otto/), a Go runtime for
edge devices, and the running example is a self-watering garden built on it.

## Architecture

- [The Five Layers of a Practical IoT System](/iot/iot-system-architecture-explained/)
  explains the device, protocol, edge, backend, and application boundaries,
  and when each piece is worth adding.
- [OttO: A Go-Based IoT Edge Gateway Architecture](/iot/iot-edge-gateway/)
  covers the gateway: MQTT as the device boundary, and how the original 2022
  design compares with the rebuilt OttO.
- [Building an IoT Device Abstraction Layer in Go](/iot/building-iot-device-manager-in-go/)
  shows how to keep application logic separate from hardware details.

## The garden case study

- [Self-Watering Garden](/iot/self-watering-garden/) ties the pieces together
  end to end.
- [ESP32 Collection Station Architecture](/iot/iot-sensor-station/) describes
  the device-side responsibilities in a sensor network.
- [Adafruit Soil Moisture Sensor (I2C) vs. Cheap Capacitive Sensors](/notes/soil-moisture-adafruit/)
  covers the sensor layer, where bad readings start.

## Older project work

[RedEye](/projects/redeye/), an earlier robot-camera project, is documented
as a historical case study, with field notes on
[streaming live video over a LAN](/notes/streaming-video-local-network/) and
[motor controllers](/notes/motor-controlor-notes/).
