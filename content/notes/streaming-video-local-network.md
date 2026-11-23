---
title: "Streaming Live Video on a Local LAN vs. the Internet"
date: 2018-12-23
lastmod: 2026-11-23
description: "Field notes from a robot camera project: why live video on a LAN needs low latency, RTSP vs. HTTP streaming, multicast consumers, and the tools I used."
categories: ["Video", "Networking"]
tags: ["Streaming Video", "LAN", "Networking", "Latency", "GStreamer"]
aliases:
  - /notes/streaming-video/
  - /notes/streaming-video-tools/
---

{{< older-note >}}

These notes come from the [RedEye](/projects/redeye/) work in 2018 and 2019:
streaming live video from a camera on a moving vehicle, over a local network
that might be Wi-Fi. The protocols have moved on since, but the tradeoffs
haven't.

## Why latency matters on a LAN

On a local network the video isn't just for watching. It feeds real-time
control: OpenCV working through frames and passing data to the guidance
module, or a person steering with a joystick. Either way, low latency and a
stream without glitches are requirements.

The arithmetic is unforgiving. At about 60 mph a vehicle covers roughly 87
feet a second, so a half-second delay puts it about 43.5 feet from where the
video shows it. A half-second dropout makes it appear to jump the same
distance. That's unsafe whether a human or an algorithm is driving.

## LAN vs. the Internet

**On the LAN, RTSP.** RTSP (with RTP over UDP) is a good fit when minimal
delay is the top priority and the network is yours. It handles more than one
sender and receiver per site well. It doesn't travel well over the Internet,
because of how RTP and UDP behave across unknown links and firewalls.

**Over the Internet, HTTP.** Delay is unavoidable once you cross links you
don't control, so the practical move is to wrap everything in HTTP. At the
time the common setup was RTMP: each camera streamed to NGINX with the RTMP
module, and NGINX published endpoints for clients. MPEG-DASH over HTTP was
gaining ground as an open, browser-supported alternative, though Safari
favored Apple's HLS.

My plan for the proof of concept was to run both, RTSP and HTTP with
MPEG-DASH, from Raspberry Pis, generating the video with GStreamer.

## One camera, several consumers

I called the modules that receive video *consumers*: the web app's live
display, a storage module that records the stream, and OpenCV running vision
algorithms. A single camera had to serve all of them, at different
resolutions.

**Lower resolution for vision.** Computer vision algorithms run much faster on
low-resolution frames, and the extra detail in high-resolution images can slow
them down several times over. The vision pipeline wanted the small stream.

**Snapshots too.** Some use cases needed still images: high-resolution photos,
and quick frames pulled from the video as markers. The Raspberry Pi camera can
produce several outputs at once, so one inexpensive camera covered both.

**Multicast groups per stream.** The end goal was to publish each stream to
its own IP multicast group and let each consumer join the groups it needed:

```text
225.1.1.1  high-definition video (1024x768)
225.1.1.2  low-definition video (640x480)
225.1.1.3  low-resolution snapshots
225.1.1.4  high-resolution snapshots
```

The web app and the storage module join the video groups, and OpenCV joins the
low-resolution one for object detection, navigation, or scene-change
detection. Adding a consumer doesn't add load on the camera. See
[IP Multicast Basics](/notes/ip-multicast/) for how the groups work.

## Tools

The long-standing tools for streaming, snapshots and transcoding are
**GStreamer**, **VLC** and **FFmpeg**:

- **GStreamer**: complex pipelines, but very flexible. Tees let one pipeline
  feed several outgoing streams, including different resolutions and
  bitrates, and NVIDIA builds its Jetson camera support on GStreamer plugins.
  I chose it.
- **VLC**: less complex than the others, and widely used.
- **FFmpeg**: flexible, with long command lines. Some people reported it
  hitting limits beyond medium-quality live streams, which was one reason I
  stayed with GStreamer.

Boards also ship their own utilities. In 2019 that meant `raspivid` for the
Raspberry Pi camera and the `nvgst` capture and playback tools on the NVIDIA
Jetson Nano.
