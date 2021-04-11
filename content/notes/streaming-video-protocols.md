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
- rtp
- rtsp
- rtmp
- hlsl
- mjpeg
- mpeg-dash
- mpeg
- jpeg

## RTP ~ Real Time Protocol

Actually holds payloads containing arbitrary, but time/delay sensitive
media (audio, video, live conversations, etc).  Incorporates enough
controls to allow for network congestion, reciever compensation and
more. 

## RTSP What it is and How to use it

**Real Time Streaming Protocol (RTSP)** 

General consensus says that RTSP is a good choice for low latency,
local area networks.

> RTSP good for Local Low Latency, Bad for Internet

This test I used _raspivid_ to _vlc_ to stream from my Raspberry Pi
Camera, I used the following command retrieved from
[here](http://www.mybigideas.co.uk/RPi/RPiCamera/)

[Video describing the use of gst-rtsp-server](https://gstconf.ubicast.tv/videos/latest-gstreamer-rtsp-server-features/)


```bash
% raspivid -o - -t 0 |cvlc -v stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/}' :demux=h264
```

With this, I ran the _vlc_ on a Macbook Pro, I ran the vlc client and
opened the following network connection:

> rtsp://10.24.2.10:8554/

I was able to see the video just fine, however performance sluggish.
I tried running VLC on my [Jetson nano](http://todo), it just
crashed.  So much for that..

My goal is not to figure out why VLC is crashing, rather to get low
delay, glitch free video with as good quality as possble.  The high
definition channel will be sent to the Webapp for live display,
primarily for Human consumption.

> Need to identify the optimal real time video transport for a mobile
> vehicle. 

## HLS - Apple Centric Solution Transport

As of now, I am under the impression that HLS is heavily Apple
centric, and perhaps not the best open, "agnostic" solution.

> Todo: update my understanding of this.


## MPEG DASH

