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
image: /img/redeye-cmdline-snapshot.png
logo: /img/redeye-right.png
draft: true
---

A _RedEye camera_ is a _Video Streamer_ software that can be controlled
via an _API_, save video images and snapshots locally or in the
cloud.

## What Makes RedEye so Smart

### Computer Vision with OpenCV

Also, _Redeye_ can run video streams or single images through
_Computer Vision AI filters_ written the _OpenCV_(http://opencv.org).

Computer Vision algorithms, however complex can be written as a plugin
and dynamically switched at runtime.

### Robotics with GPIO

If that ain't enough RedEye also has access to it's hosts _GPIO_
library, if available. For example, RedEye loves to control motors and
robot arms when running on a Rasberry Pi or NVidia Jetson Nano. !

### IIoT with API

RedEye was built with MQTT support at it's core, along with it's RPC
style API RedEye camera's can be integrated into one heck of a diverse
range of applications! 

> It will be nice to show some here.

## Streaming Video

RedEye uses OpenCV to handle all the crazy details of opening and
initialization the computers variety of camera types in a single
intuitive interface. We will stick with that, no need to mess it up. 

## Camera Commands (API)

The Camera Server API supports the following commands:

1. Config: get and set configurations
2. Play: start streaming video (open)
3. Pause: stop streaming video
4. Snap: save a snapshot to storage
5. Record: save a video stream to storage
6. Filter: get and change the CV filter(s)
7. Store: get and set storage location(s) and creds
8. MQTT: broker and credentials

## Run

## Where Can be done with Images and Video?

Images and videos can go a lot of places! Including, but not limited
to the following:

1. Display on local screen
2. Serve video and images up over HTTP/HTML5
3. Save video and images on the Local Filesystem
4. Save video and images on a Remote (Cloud) Filesystem

The location(s) of video and images can be setup before hand. Dropbox,
AWS, Flicker, Unsplash or Youtube. If you have a favorite respository
for your photos or video configure the storage box ahead of time with
appropriate access keys and what not, from that point on your can be
safe knowing your images and videos are safely stored where ever you
want them.

## About the Camera Software

_RedEye_ is really more of a _Service_ _Oriented_ _Architecture (SOA)_
than an application really.

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

