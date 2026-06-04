---
title: Notes
description: >
  Smaller working references, experiments, and historical notes on software, networking, embedded systems, and tools.
date: 2001-02-19
---

This section is for smaller observations, setup notes, experiments, and older
project references that are still useful but not necessarily canonical.

Use Notes when you want implementation details, project history, or a narrow
technical reference. Start with [IoT](/iot/) or [Software](/software/) when you
want the polished architecture and delivery paths.

## Current Technical Notes

These are the strongest current notes:

- [Exposing a Go App as Claude MCP Tools](/notes/mcp-claude-tools/) covers a typed tool boundary around a Go application.
- [Soil Moisture Sensors for IoT Garden Projects](/notes/soil-moisture-sensor/) covers sensor reliability, calibration, and integration concerns.
- [Adafruit Soil Moisture Sensor Notes](/notes/soil-moisture-adafruit/) follows up with a more specific I2C sensor option.
- [Using Go timers for MQTT testing](/notes/go-timers-testing-mqtt/) captures a focused Go/MQTT testing pattern.

## Older Project Notes

These are useful historical references, but they should not be read as current
recommendations without checking the surrounding context:

- [MQTT for Controller Communication](/notes/mqtt-comm/) covers an older message-bus design for control software.
- [Raspberry Pi Motor Control Software](/notes/rpi-motor-control-service/) documents older robot-control implementation notes.
- [Streaming Video Tools](/notes/streaming-video-tools/) and [Streaming Video is Complicated](/notes/streaming-video/) collect older video-system tradeoffs.
- [IP Multicast Basics](/notes/ip-multicast/) preserves networking background that connects to later multicast work.

## How Notes Fit the Site

Notes are smaller and rougher than pillar articles. They may support an article,
explain a detail, or preserve project history. The section remains useful as an
archive, but the primary reading paths live in [IoT](/iot/), [Software](/software/),
and [Projects](/projects/).
