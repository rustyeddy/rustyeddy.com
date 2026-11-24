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

- [Build an MCP Server in Go](/notes/mcp-claude-tools/) builds a typed, write-gated MCP server with the official Go SDK and connects it to Claude Code.
- [Adafruit Soil Moisture Sensor (I2C) vs. Cheap Capacitive Sensors](/notes/soil-moisture-adafruit/) covers sensor reliability, calibration, protection, and an I2C sensor with code.
- [Using Go timers for MQTT testing](/notes/go-timers-testing-mqtt/) captures a focused Go/MQTT testing pattern.

## Older Project Notes

These are useful historical references, but they should not be read as current
recommendations without checking the surrounding context:

- [MQTT for Controller Communication](/notes/mqtt-comm/) covers an older message-bus design for control software.
- [Streaming Live Video on a Local LAN vs. the Internet](/notes/streaming-video-local-network/) collects older video-system tradeoffs from the RedEye camera work.
- [IP Multicast Basics](/notes/ip-multicast/) preserves networking background that connects to later multicast work.

## How Notes Fit the Site

Notes are smaller and rougher than pillar articles. They may support an article,
explain a detail, or preserve project history. The section remains useful as an
archive, but the primary reading paths live in [IoT](/iot/), [Software](/software/),
and [Projects](/projects/).
