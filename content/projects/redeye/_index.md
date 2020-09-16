---
title: RedEye Camera Backend
date: 2020-04-01
description: RedEye is smart camera software built with Open Computer Vision (OpenCV) with simple control and configuration APIs 
site: http://rustyeddy.com/projects/redeye
github: https://github.com/redeyelab/redeye
image: /img/redeye-cmdline-snapshot.png
logo: /img/redeye-right.png
---

## About the Camera Software

The _RedEye Camera_ software streams video over _IP_ through
configurable _Computer Vision Pipelines_ with example
pipelines that include:

- Face Detection
- Motion Detection
- Object Tracking

Pipelines can be built as plugins and added directly to the camera
with runtime configuration. This allows you to add your own _Computer
Vision_ application(s) without worrying **too much** about the
software that controls the camera.

## Camera APIs

The Camera provides APIs for  _camera control_, _configuration_ and
_storage_. These APIs give you complete control over the
cameras functionality. Most of this functionality can be had through
the built in webapp, or any other communication mechanism you choose.

The camera design is **API first** which means that all of the cameras
functionality is exposed through the same libraries the camera
operates from, giving you a tremendous amount of flexibility to
integrate cameras into your application.

### Control, Configuration and Storage

The APIs collectively provide control over the cameras _play_, _pause_
and _snap_ controls, a myriad of configurations including
_resolution_, _Frames Per Second_, _Color_ and a ton more.

The _storage_ interface provides very flexible options when it comes
to where and how to store video clips and snapshots..

### Supported Protocols

All APIs can be accessed in one or more of the following ways: 

- Built Reactive Webapp
- REST API
- MQTT Messaging
- Websockets

If you have any questions, find a bug or would like to use this
software, please drop me a line, or fill out an issue.

{{< gist >}}

