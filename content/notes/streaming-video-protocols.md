---
title: Streaming Video Protocols
description: >
  This is a hard one for me to wrap my head around.  I'm a networking
  guy, and the number of options for wraping and unwraping video
  streams as they are being moved about is mind boggling, let us try
  to make some sense of it here
date: 2019-04-28
categories:
  - video
tags:
  - h264
  - rtsp
---

## RTSP What it is and How to use it

**Real Time Streaming Protocol (RTSP)** 

This test I used _raspivid_ to _vlc_ to stream from my Raspberry Pi
Camera, I used the following command retrieved from
[here](http://www.mybigideas.co.uk/RPi/RPiCamera/)


```bash
% raspivid -o - -t 0 |cvlc -v stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/}' :demux=h264
