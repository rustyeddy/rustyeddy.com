---
title: The RedEye Intelligent Video Network Project
date: 2019-05-14
description: >
  RedEye is an Intelligent Video Network that runs on a network of
  Linux computers with CSI and USB cameras. Computer Vision algorithms
  can be applied to any stream and changed on the fly. Interfaces with
  external systems like Robots and Video Storage services are
  available for custom applications. I wrote RedEye for my portfolio
  and because it very interesting. 
github: https://github.com/redeyelabs
---

RedEye is actually a collection of three independant applications, one
could even say micro-services that act in concert to provide
interesting applications built from streaming video sources, Computer
Vision algorithms and Visualizations driven by a comprehensive API.
<!--more-->

## RedEye Components

RedEye is an OpenSource software project with a powerful API for
integration with a variety of applications including but not limited
to Robotics, Enviromental and Industrial Automation.

RedEye intends to be 100% API driven, infact supporting the following
communication protocols: HTTP Server for REST and HTML, MQTT Client
and Websockets for messaging and M-JPEG for video stream delivery.

1. [_recam_](https://github.com/redeyelabs/recam): streams video from
networked camers (Raspberry Pi, Jetson Nano, Linux w/Webcam, etc.)
through Computer Vision AlgoRithms and interfaces with Robotics!

2. [_station_](https://github.com/redeyelabs/station): controls video
streams, save videos, snapshots and change AI Algorigthms on cameras
within it's network.

3. [_app_](https://github.com/redeyelabs/app): Webapp served by the
station, a modern, nice looking app that can be used to watch video,
observe algorights and even change them, on the fly.

4. [_aeye_](http://github.com/redeyelabs/aeye): The A-Eye module (like
the name? Pretty clever huh?) is a collection of _Computer Vision_
_filter_ plugins (easy to write, check out the examples) you can use
OpenCV, NVidia Stuff or roll your own!

There links to each of these applications below where all the detail
about how to get, build and run these applications can be found. Heck,
in due time we may even get some containers built for easy deployment.

## RedEye Architecture

RedEye can be called a _Service Oriented Architecture_ made from the
following _Micro Services_ (Buzzword Kill). Bottom line is that each
of the applications use standard open protocols making it very easy to 
integrate RedEye into many different applications and automations.

### HTTP - WebUI, REST and File Uploads

The HTTP protocol is used quite a bit both for it's REST interface as
well as serving up HTML for the WebUI and providing file uploads. The
recam and stations module provide HTTP servers.

### MQTT - Messaging

RedEye depenends on an MQTT broker to facilatate _camera discovery_,
_event and error logging_ and _camera controls_. Both _recam_ and
_stations_ are MQTT clients.

### Websockets

RedEye comes with a WebUI (written in Vue)! Websockets provide
realtime communication between the _Stations_ service and the
WebUI. Websockets allow humans to control much of the run time control
of the network as well as observe it's health.

### M-JPEG - Video Streamer

M-JPEG is not the most efficient video streaming mechanism but it is
relatively simple, used for a couple decades around the Internet and
Computer Vision algorithms, which is what we're all about!

All camera [recams] stream their video's using M-JPEG accessible via a
common URLs:

- http://cam1.mobilerobot.io/video0
- http://cam1.mobilerobot.io/video1

The above URLs are used to access the first and second video cameras
on the device with the name: cam1 in mobilerobot.io.

### Computer Vision Filters 

Computer vision filters are very simple to integrate into RedEye: a
shared library that exposes a single public function:

> void* filter( void* img );

The filter can be included with RedEye and recompiled, or the filter
can be built as a shared library and loaded at runtime.

Computer vision filters simply take an image in, do some possible
transformations and return the transformed image. Entire pipelines can
be built by stacking independent filters.

## External Controls

RedEye easily interfaces with GPIO libraries like WiringPI that can be
used to control electro-mechanical devices like industrial robots or
agricultural controls.

It is also easy (for a competent programmer) to integrate a variety of
external physical devices via Serial Port, i2c, SPI and good ol TCP
sockets. 

## Open Source all on Github

RedEye is an _Open Source_ project that organizes and controls a
network of in-expensive Raspberry Pi and Jetson Nano Camera's for
example, though in theory any M-JPEG streamer would do!

## Give it a Try, Let me know what you think!