---
title: Streaming Live Video on a Local Lan Vs. Internet
date: 2018-12-23
description: >
  Streaming video over a local LAN in real time, where say OpenCV is
  making realtime steering decisions, is surprisingly different than
  streaming live video chat over the Internet, find out why.
---


Peter, 

Thank you for the feedback!  The AWS Orchestration part makes
perfectly good sense. 

RTSP is a good option for streaming video in a local setup up, where
minimal delay is the highest priority.  However, RTSP does not
typically do very well over the Internet due to the nature of
RTP/UDP. 

Which brings up another question: will there be more than once
transmitter/reciever per office (which RTSP could serve well).

In recent years people would use RTMP to stream video over the
Internet, by adding a plguin to NGINX, each camera would
stream to NGINX, NGINX then create the endpoints for the video,
waiting for client connections to start recieving the video.

Nowadays MPEG-DASH over HTTP is building popularity, MPEG-DASH (taking
over popularity from MJPEG) is an Open Protocol supported by most
browswers including Chrome, but may be lagging with Safari.

I am happy to set up a PoC with both RTSP and HTTP serving MPEG-DASH
from Raspberry Pis.  For generating video, I'll be using gstreamer
most likely to transmit the Raspberry Pi Video.

I can write up an architecture document with a bit more detail..

What are your thoughts?


Video on a LAN required for Real Time control decisions, whether it is
OpenCV churning through images while spitting out data used by _magoo_
the guidance module. 

Low latency is and a non-glitchy video stream are imparative to
driving a high speed vehicle correctly. This is true even when the
vehicle is being controlled by a human with a joystick.

A half second delay in video translates to about 43.5 foot different
in where the vehicle is vs. where it appears to be, or if the we have
a .5 second drop in video, we will have "jump" that 43.5 feet.

This makes safe navigation of a high speed vehicle unsafe, whether it
is being drivin by human or algorithm.

## Video Over the Internet

Delay is inevetible. You are crossing unknown links and firewalls.
Must wrap it all up under HTTP to make things the easiest.


