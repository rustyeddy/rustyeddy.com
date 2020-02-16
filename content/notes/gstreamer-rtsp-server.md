---
title: Using Gstreamer to create an RTSP Server
date: 2019-05-30
description: >
  An RTSP server can be useful for streaming live video to local
  sources.  This article documents my use of streaming realtime video
  for vehicle navigation are documented in this article.
category: video
tags:
  - rtsp
  - rtmp
  - mpeg-dash
draft: true
---

Of it earlier this month I set out to start streaming video From the
CSI camera, that is a raspberry pie camera, From a moving vehicle for
the vehicles guidance and navigation.

I was surprised to find that the whole world of streaming video is
Incredibly complex. In 2019 we are streaming everything from stupid
instagram videos to the NFL, yet do not have A solution that is easy
universally adopted.

## TLDR; Gstreamer RTSP Pipeline

We can stream video righout out of our Raspberry Pi's Camera (CSI)
attached to, either a Raspberry Pi or a Jetson Nano, GST extracts the
video from the CSI camera using a custom driver (raspicamsrc or
nvargussrc) for the RPi or Nano respectively.

### Camera Generates Hidef and Lodef Streams

Two streames are sent from two active video ports on the camera (of
highres and a lowres streams course you gotta ask for it), the streams
are independently passed through gstreamer pipelines to be encoded and
scaled accordingly. 

### RTSP Live Video Endpoints

The RTSP server created two _"endpoints"_ that can be attached to
recieve the video to be viewed or stored, etc. So in some cases it
can make sense to have every video camera be the RTSP server.

The RTSP server does not necessarily serve the video, you can have a
single RTSP server manage a variety of remote cameras.

> Fact check: is the above really true?


## No Simple Choice to Stream Live Video

In other words, We simply do not have A plug-and-play situation, The
tools we use the serversThe configurations and all that are heavily
dependent on the application and the various components of people
reviews including the browsers people select. 

## Protocols, RTP and RTSP

We have a number of protocols for live streaming.

### GStreamer for Video

GStreamer comes as a command line utilities or the tool GST launch
that make experimenting with various _video pipelines_ quite easy.
it easy to experiment and bill with a callPipelines with.  Well that
tool is extremely powerful and many people use itAsset application
framework directly, gst-launch-1.0 Was never meant to be an
application rather anybody tool. 

### Developing Gstream Apps

The advice strategy streamer team will give you and building
applications actually building from their libraries, Do you have
Python and JavaScript binding so you do not have to develop in
C. Python and JavaScript are options.

#### gs-rtsp-server

Gstreamer Has contributed large library they will turn Angie's dreamer
pipeline into an art ESP server, Sabes please do streamer to extract
the videoFrom the camera for pipe into standard in, The raw video of
then goes through So Mace G6 for a loading coating, Get trapped in RTP
EtterBlah blah blah, into a stream.
