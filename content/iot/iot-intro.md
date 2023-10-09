---
title: Introduction to the IoT project
draft: true
date: 2023-10-07
category: iot
description: >
  This section of articles is going to document my journey building an
  IoT project. This project is going to start off with a very simple
  goal of reading temperature and humidity to be displayed with a modern
  web UI. The project will then be expanded to support relays for
  turning lights on and off, GPS and accelerometers. Come on along for
  the ride!
---

## Overview

The purpose of the project is two fold, first to build something cool
that involves some a physical product aka IoT project. The second is
to demostrate solid _Software Engineering Principals_ and the practice
of employing a professional _Software Development Life Cycle (SDLC)_.

Why IoT? Aside from the fact that I really enjoy IoT and have an IoT
background. IoT employs a lot of interesting and diverse elements of
software development.

>IoT software projects are a combination of _Full Stack_ and
>_Embedded_ software development.

We will look at some embedded software development by writting code
that runs on tiny realtime systems (esp32, raspberry Pi pico) using
C++, we will look at hubs and integration with a Raspberry Pi and the
Go programming language. Web interfaces and Mobile Apps with
JavaScript and React.

We will also be building public REST API's and PubSub messaging
systems out a cloud based backend system giving us access to our
project from anywhere in the world that can access the Internet.

From a techinical perspetive all of these items are part of IoT and
quite interesting in that they use a wide array of techical elements,
require these disparate elements to be successfully integrated
together and maintained like any complex software system.

Also, they require a significant co-ordinated effort among various
players: users, developers, stake-holders, etc.  During this process
I'll try to lean on and explain sound software development practices
as the project unfolds.

## Project Overview

The basic Idea of this project will be to develop software to observe
and control a physical device from a remote UI, that is we will build
a little weather station that collects temperature and humidity from a
simple device and display it on a web interface viewable from
anywhere, even a phone.

After that we will add a relay (switch) capable of turning lights on
and off from our user interface. This basic project will lay the
foundation for quite a few other IoT projects that can be built by
extending our base framework.

## The Architecture

We will do this in a very open and inter-changeable manner. For
example, though we may choose say a Raspberry Pi to collect
temperature and humidity, also to control the relay we will build this
project such that it is very easy to integrate a totaly different
device using the same user interface and backend.

That is we'll create API's and use messaging to create a _loosely
coupled_ infrastructure so that somebody that wanted to add to this
system say an Arduino or ESP32 could do so just by developing toward
the same API's and messaging system.


