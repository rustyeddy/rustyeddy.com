---
title: Streaming Video is Complicated
description: >
  One of the primary requirements of my Mobile Robot project is the
  ability to stream live or _realtime_ video while the vehicle roams
  about.  This turned out to be more complicated than I expected
date: 2019-04-29
category: communication
tags: 
  - h264
---

I need to stream live video from a moving vehical with a connected
camera and a possibly connected wifi.

## Live High Resolution Video

Video will stream from the vehicle to be picked up by _video
consumers_ and processed as required.  Examples of _consumers_ are
Live Video Display on our (Webapp), OpenCV for vision algoritms.

## High Demand For Low Resolution

It turns out that computer vision alogrithms typically run quite a bit
faster on lower resolution images, the additional information from
these _hi-res_ images can slow down the type of algorithms we are
interested in by many factors.

### Snapshots Anyone? 

Snapshots, as it turns out have a role in some important use cases,
for now, we will assume that snapshots are a requirement.  Snapshots
are available from a number of options: High resolution Photog quality
images, there are quick images that are extracted from video as
milestones, or artifacts.

As it turns out, our Raspberry Pi Camera can help us with this quite
bit. 

## Video Consumers

Video _Consumers_ are what I am calling the software modules that
recieve the video for further processing of some kind.  In some use
cases we will have more than one _consumer_ for a given Video group. 

### IP Multicast Video

My end goal is to multicast the different video streams to different
IP multicast video streams.  In this case each consumer simply joins
that multicast video stream, and uses it as needed.

For example:

- Hires snap  group 225.1.1.4 hires snapshot
- Hidef video group 225.1.1.1 streaming at 1024, 768   
- Lodef video group 225.1.1.2 streaming at 640, 480
- lores snap  group 225.1.1.3 lores snapshot

This allows both our Webapp with the live display and the Storage
module to consume the live video stream and play it in real time for
human consumption.  The _Storage_ module will, on the other hand store
the video stream for future access. 

### Live Video and OpenCV

The _lores_ video, will be consumed by the OpenCV module to run
through one or more computer vision algoritms.  The specific use case
in play will determine which _computer vision algorithms_ will be run.

Examples that may run at a given time:

- Object Dection for real time navigation
- Perception for navigation
- Facial recognition for security and survelience 
- Scene change detection for property management and theft

## Raspberry PiCamera and Video Ports

The Raspberry Pi camera, price wise is very cheap ($25 usd) is a cheap
camera, yet is capable of producing high quality images.  Even better,
it is very _programmable_ and is capable of producing filtered
versions of the video it is producing.


