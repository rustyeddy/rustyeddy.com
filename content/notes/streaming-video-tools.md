---
title: Streaming Video Tools
description: >
  The number of fantastic, but complex tools available for streaming
  is mind boggling, these are notes I started gathering as I worked
  through the redeye project.
date: 2019-04-23
category: video
tags:
  - gstreamer
  - vlc
  - ffmpeg
---

The grandparents of streaming video, and snapshots, read, writing
and transcoding video and single frame images are _ffmpeg_, _vlc_ and
_gstreamer_. 

Other platforms, such as the wildly cool and inexpensive Raspberry Pi
and attached CSI Camera (Raspberry Pi Camera) have thier own set of
utilities: like raspivid.  Or the NVidia Nano with it's gst-streamer
plugins and nvgst-capture/nvgst-playback utilies. 

> This writting is as of March 2019

### GStreamer Complex, Flexible, Future Proof

**GStreamer** really complex pipelines but insanely flexible.

- Allows tees to process more than one outgoing stream
- Can be "easy" to extend do to flexible pipelines
- used by nvidia to support it's proprietary drivers

**VLC** less Complex than the Rest, and still in heavy use today.
[Videolan](http://videolan.org) 
  
**FFMPEG** flexible, complex long command line, also in use today but
maybe loosing steam?  Maybe not?

A very well written article [about streaming video over the
internet](https://isrv.pw/html5-live-streaming-with-mpeg-dash) states
that he saw FFMPEG hit limits scaling his video beyond a
medium-quality stream.

I was not even considering FFMPEG, since I already sided with
gstreamer, or a home rolled solution if I really had to.  "Had to"
meaning, that I could avoid installing some gigantic infra-struct type
of system.

- Allows simultaneous transmission of different resolutions / bitrates.

