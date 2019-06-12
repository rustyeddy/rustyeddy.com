---
title: RedEye Streaming Video and Computer Vision
description: > 
  RedEye project manages live video streams used for autonomous
  vehicle control.
date: 2019-05-05
permalink: redeye
categories: 
  - computer vision
  - streaming video
github: http://github.com/mobilerobot-io/redeye
site: http://mobilerobot-io/projects/redeye
---

The RedEye project was born from the need to stream video from a
_slowly_ moving robot with _small inexpensive_ and easily available
cameras.

## Key Points

The video streams will be consumed by a HD video display, Computer
Vision control algorithms and storage.

### GStreamer Framework

The architecture is built around the powerful GStreamer libraries and
toolset. Which means that we can immediately _consume_ any video source
that GStreamer supports.

Likewise, we can _produce_ any video stream output that GStreamer is
capable of producing. Which may include:

- RTP / RTSP with UDP Multicast to support
- One or more: MPEG-DASH, HLS and/or WebRTC

### Video Sources

RedEye currently supports the [Raspberry Pi](http://raspberrypi.org)
with a [CSI Camera](http://raspberrypi.org/camera), the
[NVidia Jetson Nano](http://nvidia.com/jetson/nano) also with the RPi
camera.  RedEye also supports Linux USB video cameras using the
_video4linux_ package.  MacOS USB and builtin cameras are also supported.

Videos can also be sourced from files including: mp4, mov, h264 and
other formats.  They can also be consumed from a URL for example: an
HTTP/HTM5 Video or RTSP realtime stream. 

### Stream Multiplexer

The video from these cameras can be divided into multiple streams
with different formats. For example, video from a _car_ camera
might be converted into a high res stream and and a low res stream.
These two streams might also use different compression and encoding
algorithms. 

The High Def stream above could be consumed by HD Video Display,
while the second low res stream will be consumed by the OpenCV library.

### Cloud Storage and Support

One or more of the afore mentioned streams may need to be archived for
future replay. In this case the
[Store](http://github.com/mobilerobot-io/store) module can be used to
stash video-clips and images on one of the major Cloud provider storage.

## Feeding the Beast

Our main objective with RedEye is all about applying Computer Vision
to Real Time Vehicle Control. Real Time Vehicle control has two
facets: the first is an HD display for human control, the second is a
low def stream for the Computer Vision algorithms.

A demonstration of the RedEye software can be see here:

> Youtube Video Coming Soon

## Conclusion

Getting quality high speed video in realtime turned out to be much
more challenging and complex than I initially expected.  If you are
interested in any aspect of _real time streaming video_, especially as
it applies to Computer Vision algorithms, drop me a line, I would love
to chat and swap ideas!

> EMail Anyone?
