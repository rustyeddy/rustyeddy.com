---
title: RedEye Camera
date: 2020-04-01
description: >
  RedEye is API driven camera server with built in capabilities of
  running video streams through Computer Vision algorithms and
  controlling Robots with GPIO and other IO methods. The API provides
  complete control over the camera and accessories.
site: http://rustyeddy.com/projects/redeye
github: https://github.com/redeyelab/redeye
project_status: Historical
tags: ["Video", "Networking", "Embedded Linux", "Camera Systems"]
categories: ["Projects", "Networking"]
image: /img/redeye-cmdline-snapshot.png
image_alt: "RedEye command-line camera control interface showing API command options."
logo: /img/redeye-right.png
---

RedEye is an API-driven camera server that streams video, runs frames through
computer vision pipelines, and controls robotics hardware over GPIO. Every
capability the camera exposes is reachable through one API, so the same
functions are available from a built-in web app, REST, MQTT, or WebSockets.

Source: <https://github.com/redeyelab/redeye>

## Project Status

**Historical.** RedEye is kept as a case study in camera, networking, and
robotics architecture, not as a current project recommendation. The code
reflects an earlier era of single-board computer vision and video streaming.
What still holds up is the system-design problem it captures, not the specific
implementation.

## What RedEye Explored

RedEye sits at the intersection of four concerns that each pull a system in a
different direction: video transport, near-real-time control, computer vision,
and robotics I/O. The interesting problem was keeping those boundaries explicit
instead of letting them collapse into one tangled program. It remains a useful
reference for keeping real-time-ish systems inspectable.

## Architecture: API First

RedEye is closer to a service-oriented architecture than a single application.
Every capability — play, pause, snapshot, filter selection, storage — is exposed
through the same library the camera itself runs on. The built-in web app is just
one client of that API. REST, MQTT, and WebSocket clients are equally
first-class.

Designing API-first meant the camera had no privileged "main" interface. Any
functionality available to the web app was, by construction, available to an
external integration. That is what gave RedEye its flexibility: you could drop a
camera into an application without going through a UI layer that secretly held
capabilities the API did not.

## Core Capabilities

### Video streaming

RedEye uses OpenCV to abstract over the messy details of opening and
initializing the many camera types a host might present, exposing them through a
single interface. Video streams over IP and can be consumed by any client.

### Computer vision pipelines

Video streams and single frames can be run through OpenCV-based computer vision
filters. Pipelines are built as plugins and can be switched at runtime, so new
CV work can be added without touching the camera-control code. Example pipelines
include:

- Face detection
- Motion detection
- Object tracking

### Robotics and GPIO

On hardware that exposes it — a Raspberry Pi or NVIDIA Jetson Nano, for example —
RedEye can drive GPIO directly to control motors and robot arms alongside the
video pipeline.

### Messaging

MQTT support was built in from the start. Combined with the RPC-style API, that
let RedEye cameras integrate into a wide range of applications rather than living
as a standalone device.

## Camera API

The API covers three areas: camera control, configuration, and storage.

| Command | Purpose                                      |
| ------- | -------------------------------------------- |
| Config  | Get and set configuration                    |
| Play    | Start streaming video                        |
| Pause   | Stop streaming video                         |
| Snap    | Save a snapshot to storage                   |
| Record  | Save a video stream to storage               |
| Filter  | Get and change the active CV filter(s)       |
| Store   | Get and set storage locations and credentials |
| MQTT    | Broker and credentials                       |

Control covers play, pause, and snap. Configuration covers resolution, frame
rate, color, and more. Storage covers where and how clips and snapshots are
written.

All commands are reachable through any of the supported transports:

- Built-in reactive web app
- REST API
- MQTT messaging
- WebSockets

## Storage Destinations

Capture targets are configured ahead of time, so a running camera can write to
local or remote storage without further intervention:

- Display on a local screen
- Serve video and images over HTTP / HTML5
- Save to the local filesystem
- Save to a remote or cloud filesystem — Dropbox, AWS, Flickr, Unsplash,
  YouTube, and similar

Configure the destination with the appropriate credentials once, and captures
land there from then on.

## Common Pitfalls

Camera and robotics systems get messy when video transport, control commands,
computer vision, and UI behavior are coupled together. Latency assumptions,
network limits, and hardware-specific control paths need to be visible design
constraints, not surprises discovered at the end.

## Where This Fits

RedEye is a historical project case study. For current architecture guidance,
start with [IoT](https://rustyeddy.com/iot/) and
[Projects](https://rustyeddy.com/projects/). For supporting background, see the
older [streaming video notes](https://rustyeddy.com/notes/streaming-video/) and
[IP multicast notes](https://rustyeddy.com/notes/ip-multicast/).
