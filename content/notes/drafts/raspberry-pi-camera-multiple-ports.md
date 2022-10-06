---
title: Raspberry Pi Camera and Multiple Ports
description: >
  I am using the Raspberry Pi Camera and the excellent PiCamera python
  library to simultaneously generate high and low definition streams
  from the same Raspberry Pi Camera.
date: 2019-04-21
categories:
  - video
tags:
  - raspberry pi
  - picamera
---

As I started bumbling around trying to figure the best way to stream
[live video from a moving vehicle], I found that the Raspberry Pi
camera is capable of producing filtered versions of the images it is
producing, through _video ports_.
<!--more-->

### Raspberry PiCamera and Video

- The live video stream(s) will potentially be recieved by more than
  one consumer: including but not limited to:

  - Live streaming High Def video watch while the rover is roaming about
  - OpenCV module to run Computer Vision algorighms
  - Cloud storage for future replay
  - Snapshots can be produced or pulled from vide
  
- The Raspberry Pi Camera has multiple ports
  - Video Ports (defaults):
    - Port 0 for high res, slow, mildly distruptive snapshots (capture)
    - Port 1 standard for video High Def video recording (1024, 768,
    1240, 1080), etc

  - Additional ports
    - Port 2 lowdef low frames fed to OpenCV
	- Port 3 lowres capture triggered by events

- There are many standards and ways to do things
