---
title: WPE an Excellerated Raspberry Pi Kiosk
date: 2020-12-25
description: >
  Raspberry Pi's have just become even cooler! Add an inexpensive
  touch panel and you can create insanely cool.
reference:

  - https://github.com/WebPlatformForEmbedded/buildroot
  - https://medium.com/@decrocksam/building-web-applications-for-wpe-webkit-using-node-js-3347146013f3
draft: true
---

The WPE project (TODO: place reference) allows you to create a
_hardware accelerated web viewing__ experience with an embedded system
and inexpenive display. 

For example a Raspberry Pi with an 7inch tftp touch screen has my
brain racing with ideas for applications.

## About WPE

WPE creates a cool hardware accelerated kiosk, just point at a URL and
the app displays the application takes over the screen.

> It is awesome! But, it has one major drawback.!.

### Building WPE

But is also a pain to get going, no binary package at this point, and
as far as I can tell, you need to start with _buildroot_, get all the
configs correct, build and burn an SD image.

Phew. Not that I am not up for learning to use buildroot and getting a
system going, but I could not find a straight forward recipe, very
nicely written example suffered the nefarious outdated screen shots.

> I did the best, first pass I could at cloning and configuring WPE
> for RPI3, but alas ...

My first pass or two at configuring and compiling WPE failed, and had
to move on to other things ..., to be written about shortly.

Lacking an easy build requires me to spend time learning buildroot,
WPE and a bit about the giagantic complexity that is _webkit_. Sounds
interesting but I (like almost everybody in the universe) don't have
time for it.

## Balena and Next Steps

Balena has created a working WPE image, unfortunantly when I add the
WPE container to my Balena application, only 3 of the 4 required
containers run.  

Bummer!

