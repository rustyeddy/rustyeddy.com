---
title: Otto the Pluggable Macro Controller Micro Service
description: >
  Otto is a simple, micro-server built to normalize communications
  across multiple channels (REST, SPA, MQTT, REST, etc.) while
  applications and functionality are added via pluggins.
categories: 
  - software
  - micro service
tags:
  - golang
  - rest
  - mqtt
  - rest
github: http://github.com/mobilerobot-io/otto
image: https://mobilerobot.sfo2.cdn.digitaloceanspaces.com/display-and-motors.jpg
todo:
  - image depicting communications with REST/MQTT, etc
  - do some code samples
draft: true
---

Otto is a small, simple _micro-server_ written in Go. It handles
requisit communications and related infra structure required by
servers and controllers.  The applications and functionality will be
provided via pluggins.

Otto can run as a REST server in a data center or the controller on
micro-controller type of computer.  Otto was developed with the notion
that much of the code that makes for a good server (or any application
for that matter) requires redundant but import supporting
infrastructure. 

## Otto Core

The Otto core provides the following support out of the box, available
to all plugins that require these services out of the box.

> Communication Handlers for REST, HTML, SPA, Websocket and MQTT
> Messaging.  Additionally: Configuration Management, Logging, Stats
> Collection and Plugin Management

The plugins can be combined in any combination to achieve precisely
the functionality needed for a given circumstance.

## Current Plugins 

Plugins are very simple to write, they are basically _Go Plugins_ with
public Name() and Register() functions.  The Register() function
essentially registers handlers with otto to recieve events and
corresponding event info.

This is the current list of otto plugins.  Plugins can be written
anywhere and loaded by Otto.  These just happen to share Otto's
repository. 

- Echo	~ send data, or a message and get it back.
- Store ~ persistant storage of Go objects as JSON strings
- Dork	~ cloud based compute and storage monitor
- Wally ~ website page walker / scrapper
- Monty ~ mico-controller monitoring program

A link to the [github repository](http://github.com/mobilerobot-io/otto




