---
title: Raspbery Pi Camera Control Service
date: 2019-03-04
description: >
  I created a python/flask server on the Raspberry Pi to control the
  operation of the PiCamera. Take snapshots, timelapse photography and
  streaming video are all desired.
categories:
  - software
  - computer video
tags:
  - picamera
  - pi camera
  - camera
todo: 
  - images
  - video
  - block diagrams
  - link to github report
image: https://mobilerobot.sfo2.cdn.digitaloceanspaces.com/display-and-motors.jpg
resources:
  github: http://github.com/mobilerobot-io/ripid
draft: true
---

I have created a python / Flask based server to run on the Raspberry
accepting REST calls to perform application specific functions.

I have created a flask server that will accept REST requests to
control the PiCamera, AdaFruitMotorSheild and other stuff.
  

Refer to the PiCamera documentation here:
https://picamera.readthedocs.io/en/release-1.13/. 

The software can be found in [github
repository](http://github.com/mobilerobot-io/rpid). 

And how to write and operate a flask based server for your project. 

## TODO ~ Turn streaming On and Off

The next task is to turn video streaming On and Off, this may require
duping and modifying somewhat a python script ...



  
