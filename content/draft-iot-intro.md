---
title: Introduction to the IoT project
draft: true
date: 2023-10-07
---

# IoT Project

## Introduction

I'd like to start my online journey by developing an IoT project and
highlighting a number of important issues that ~comeup~ must happen to
develop a successful software project.

Why IoT? Primarily because I am really into IoT. And it fits my
background, over the years I have developed compjuter network
protocols and applications, embedded systems and even quite a git of
frontend work.

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

In addition to that, we will add a relay (switch) capable of turning
lights on and off from our user interface.

This basic project will lay the foundation for quite a few other IoT
projects that can be built by extending our base framework.

We will do this in a very open and inter-changeable manner. For
example, though we may choose say a Raspberry Pi to collect
temperature and humidity, also to control the relay we will build this
project such that it is very easy to integrate a totaly different
device using the same user interface and backend.

That is we'll create API's and use messaging to create a _loosely
coupled_ infrastructure so that somebody that wanted to add to this
system say an Arduino or ESP32 could do so just by developing toward
the same API's and messaging system.

## The Architecture


