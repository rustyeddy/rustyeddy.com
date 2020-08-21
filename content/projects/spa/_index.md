---
title: SPA - Single Page Application Micro-Server
date: 2019-01-19
description: >
  This Single Page App (SPA) is a small, simple and pretty fast web server
  ideal for building dashboards on little computers like the Raspberry
  PI, as well as                   
categories: 
  - micro service
  - fullstack
resources:
  home: http://rustyeddy.com/projects/spaclock
  github: https://github.com/rustyeddy/spaclock
  website: http://rustyeddy.com
  resume: http://rustyeddy.com/resume
image: https://rustyeddy.sfo2.digitaloceanspaces.com/SensorStation.png
draft: true
---

## Description

SPA Clock is an embedded webserver intended to run on a Rasberry Pi
(or similar linux system) with a touchscreen and Internet connection.

This clock comes with _Zero Touch configuration_. Just plug it in,
connect it to the internet and always have accurate time! 

> Even through power outages and timezone changes, you'll never have
> to reset your clock again.

Now wait, that is not all! You also get other cool things like the
date and current local weather!  

It is all OpenSource and easy to modify or extend with a simple yet
really powerful plugin system! 

## Open Source Technologies

SPAClock was built with current but proven technologies. It is
compact, easy to modify and a __great way__ to start developing modern
web applications.

### Tech Stack

Here is the bulk of what was used to build this application:

- Go (the language) creates a tight, efficient micro-server
  - server static web pages and artifacts
  - REST API for various configuration and stuff
  - Websocket for realtime browser based perusing
  - MQTT for messaging between devices and controllers
- Vue.js for Front End application framework
- Cloud Automation for Deployment and Operations

## Why SPA Clock?

I started building the Single Page Application Internet Clock
(SPAClock) for two reasons: 

#### 1. Show Off (my Talents :)

To provide perspective clients with an unencumbered portfolio
example. 

In otherwords: most of my work has been paid for by an employer or
client, for which I lack the permission to show. In most cases I do
not even have access to my past work. (Makes me very sad).

This project is something I have been doing on my spare time to
_show_ rather than _tell_ you about my code slingin skills.

#### 2. Learn Vue and Improve Frontend Skills

The other reason for SPAClock is that I wanted to learn Vue.js and
level up my _front end_ development skills. 

> So, what do you think?

