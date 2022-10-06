---
title: WebRTC What is it?
description: >
  That is a good question, I have been trying to figure it out
  myself. Here are some notes that I have gathered along the way. 
date: 2019-05-05
category: Video
tags: webrtc
draft: true
---

WebRTC stands for Web Realtime Communications.  Yea, I know you can
Google too, now let's ask, _"What does that mean?"_.  

## Realtime Communication

Generally speaking we all, intuitively know what _Real Time_ means, it
is a sense of what is happening _now_.  OK, that is reasonable, after
all it is how we live the majority of our lives.

### Communication "Topologies"

- One to one
- One to many
- many to many
- many to one?

### Types of Communication

- Video
- Audio
- Text 
- Telemetry
- etc

### Tranmission Medium(s)

- Local or Remote communication
- wired or wireless
- controlled / uncontrolled
- under or over subscribed
- reliability over time
- usage patterns (christmas church service)

## Handling Failure

If all communication found itself on reliable, consistent
under-subscribed links with an efficient end-to-end network design,
then realizing _Realtime Communication_ would is simply a matter of
living withing the bandwidth and delay of your communication end
points. 

However, for us that live in the real world, these things happen, at
times, under ideal circumstances, but that certainly do not hold
across the world wide Internet, for any number of the above issues
that I list above. 

We do find, when trying to _codify_ real-time in software, as we program,
design algorithms and test systems, we quickly find that we have to
start define in increasingly granular terms, what "Real-Time" means.

The parameters we have to work with include:







