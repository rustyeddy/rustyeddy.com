---
title: Internet Of Things
description: >
  Building DIY electronic projects is a lot of fun. You no longer need
  to be a rocket scientest nor a millionaire to build some really cool
  IoT style of projects. Here we will build some cool projects, but
  unlike some other cool projects we find on websites and Youtube
  channels we will focus mostly on the software side of IoT
  development, by way of a tool called OttO that allows use to take
  our projects sophistication to a whole new level with communication,
  cloud technology and intuitive user interfaces to make our projects
  really cool. Continue reading below to find out more.
tags: [ iot, maker ]
date: 2023-01-13
---

## Overview

The purpose of the project is two fold, first to build a cool IoT
project or two, second to demostrate solid _Software Engineering
Principals_ and the practice of employing a professional _[Software
Development Life Cycle (SDLC)](../software)_.

Why IoT? Aside from the fact that I really enjoy IoT and have an IoT
background. IoT employs a lot of interesting and diverse elements of
software development.

>IoT software projects are a combination of _Full Stack_ and
>_Embedded_ software development.

### Diversity of Technology

We will look at some embedded software development by writting code
that runs on tiny realtime systems (esp32, raspberry Pi pico) using
_C++_ and _python_, we will look at hubs and integration with a
Raspberry Pi and the _Go_ programming language. Web interfaces and
Mobile Apps with _JavaScript_ and _React_.

### Building Extensible Systems with APIs

We will also be building public REST API's and use MQTT for a
Publish/Subscribe (Pub/Sub) messaging system. We will also look at the
aspects of out a cloud based backend giving us access to our project
from anywhere in the world that can access the Internet.

From a techinical perspetive all of these items are part of IoT and
quite interesting in that they use a wide array of techical elements,
require these disparate elements to be successfully integrated
together and maintained like any complex software system.

Also, they require a significant co-ordinated effort among various
players: users, software developers, electrical engineers, mechanical
designs, all sorts of technitions and various other stake-holders. 

During this process I'll focus on the software that I am most familiar
with and and explain sound software development practices as the
project unfolds. At the same time I'll be learning quite a bit about
hardware as well as improving my software skills.

## Project Overview

The basic Idea of this project will be to develop software to observe
and control a physical device from a remote UI, that is we will build
a little weather station that collects temperature and humidity from a
simple device and display it on a web interface viewable from
anywhere, even a phone.

After that we will add a relay (switch) capable of turning lights on
and off from our user interface. This basic project will lay the
foundation to build other IoT projects should we want to.

## The Architecture

We will do this in a very open and inter-changeable manner. For
example, though we may choose say a Raspberry Pi to collect
temperature and humidity, also to control the relay we will build this
project such that it is very easy to integrate a totaly different
device using the same user interface and backend.

That is we'll create API's and use messaging to create a _loosely
coupled_ infrastructure such that anybody that wanted to could add to
this system say an Arduino or ESP32, could do so just by developing
toward the same API's and messaging system.

## Next 

Below are links to various articles that describe the project in quite
a bit more detail.

