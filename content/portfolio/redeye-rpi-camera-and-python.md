---
title: RedEye Project Streaming Video and Computer Vision
description: > 
  RedEye project builds a series of dynamic video pipelines prepared
  to be consumed by a high definition display, computer vision library
  and cloud storage.
date: 2019-05-05
categories: 
  - computer vision
  - streaming video
github: http://github.com/mobilerobot-io/redeye
site: http://mobilerobot-io/projects/redeye
---

The RedEye project goal is to build a fast and flexible video
streaming application to be used on a mobile robot (i.e. a rover style
vehicle). 

## Architecture

RedEye is an application with the purpose of capturing and consuming
live video streams, filter incoming streams into formats ready for
various consumers.

In other words, RedEye can expect to manage cameras and capture video
from one or more Raspberry Pi, Jetson Nano or Linux / MacOS USB port. 

The streams from these cameras can be dividing into multiple streams,
with different formats, for example, one stream form a _car_ cam might
be converted into high res and low res streams, perhaps with different
compression and encodings.

The different streams may then be recieved by one or more consumers
(sinks), for example the hi-res and lo-res streams above might be
consumed by a HD Display for real time viewing, while the low
resolution stream is consumed by our Computer Vision (OpenCV)
algorightms. 

### Cloud Storage and Support

In one or more of the afore mentioned streams may need to be archived
for future replay. In this case the Store module can be used to stash
video-clips and images on one of the major providers storage, add some
indexing and we can assemble a replay application.

RedEye is built on top of GStreamer and likewise heavily influenced by
it's architecture, flexibility, power and ecosystem, which is heavy.
Gstreamer is not easy to get started with, but it is very logical and
consistent with a huge ecosystem, that a few well spent hours of
lurning curve investment will payout in dividends!

## Feeding the Beast

Our main objective with RedEye is all about applying Vision to Real
Time Vehicle Control. Real Time Vehicle control has two facets: HD
display for Human Vision, Computer Vision for guidance feedback.

> Applying Vision to Real Time Vehicle Control 

High Definition feeds are consumed by Humans, in particuar the Human
that is controlling the Robot, with a _Joystick_ or a _keyboard_ for
example. 

Computer Vision will be used heavily as the near future approaches, as
we start integrating more and more CV algorigthms into a navigation
system. 




