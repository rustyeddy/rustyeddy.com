---
title: A Guide to Developing IoT Software
subtitle: How to build a self watering garden
url: iot-project
date: 2020-09-06T10:32:26-07:00
description: >
  Read this article if you have a thing or an idea for a physical
  product that you want to enhance with software and attach to the
  Internet. We will build a self watering garden as an example
  project. 
git: https://github.com/iot-station
---

This site documents the technical challenges and design decisions I
used while developing the Organic Gardner IoT product: a self
watering garden. If you are interested in developing IoT software or
adding software to one of your projects you are in the right
place. Join the NewsLetter below and say Hi!

![High Level Sensor Station](/img/iot-project-drawing.png)

## What is this project about?

Code named _Organic Gardner (OG)_ is a project to build an automated
irrigation system where it gathers soil moisture levels from
inexpensive sensors, uses that data to determine when the sprinkler
system should be switched on and off. 

She does not exactly know it yet, but my wife will volunteer her
garden for testing!

### What Makes IoT Software Different?

An IoT project usually involves taking a well known functional device
like a doorbell (Ring) or Heater (Nest) and adding some "smart"
software and real time communication software, which may include an
Internet connection.

The communication software and Internet connection assume a whole new
level of complexity depending on the type of data being communicated
and how it is being interpreted and saved.

IoT projects with many scattered pieces can be a challange, if not a
complete night mare to manage. The topics of _Fleet
Management_ and _cloud automation_ will be discussed at some depth.

### On Demand Irrigation and Lighting Controls

The main application is what i call _On Demand Irrigation (ODI)_ which
is a feature that uses soil's moisture levels to control a network of
sprinklers ensuring every micro-section of the garden is optimally
watered just right! 

Lighting can be controlled by light levels or programmed with a
traditional time based scheduler, all according to application
requirements. 

## The Development Plan

To avoid being overwhelmed with details and keep the project moving
forward we will build it out incrementally, one interesting feature at
a time, stacking cool feature on top of cool feature. Testing will be
performed initially by _mocking_ MQTT publishers with the
```mosquitto_pub``` command line tool. 

Let's steal the term from [Lean Startup](http://leanstartup.com) and
define our **MVP** by etching out the details of our developmental
_milestones_. 

### MVP Milestones

The milestones are defined such that upon the completion of each one
we incrementally adds useful features to the application until we
iterate toward the complete OG MVP. 

{{< milestone 1 "Hub Subscribes to MQTT data" >}}
This first Milestone we import the <em>eclipse MQTT</em> library for go and
get to collecting environmental data transmitted (mocked) using the
<code>mosquitto_pub</code> publishing tool. The data collected is stored
efficiently in RAM for quick retrieval
{{< /milestone >}}

{{< milestone 2 "Hub Provides REST API for Data " >}}
Now that the Hub has data efficiently stored in RAM we need a way to
access the data, for that we'll create a REST API. The REST API is
dependendant on an HTTP server and router that can easily be provided
introducing the go <code>net/http</code> built-in package.
{{< /milestone >}}
   
{{< milestone 3 "Dashboard Displays Historic Data " >}} 
The next milestone is our responsive Single Page App (SPA) written
with the Vue JavaScript framework. The SPA will also be served up by
the Hub's HTTP server. The Dashboard will display historic data
retrieved via the
Hubs REST API.
{{< /milestone >}}

{{< milestone 4 "Dashboard Displays Real Time Data" >}}
This phase of the project we add Websockets to the Hub and Dashboard
allowing the Hub to stream real-time sensor data to the Dashboard. The
Dashboard will always display the latest data for every sensor it
displays as soon as the data arrives.
{{< /milestone >}}

{{< milestone 5 "Collection Station Transmits Data" >}}
This is the most interesting part of the project for me. This is were
we prototype hardware using the <em>esp32 SoC</em> and write some
<em>real time software</em>. When this is complete we can replace the
mock MQTT data with real data from a real sensor!
{{< /milestone >}}

{{< milestone 6 "Introducing the Cloud" >}} 
The final frontier, at least for this set of milestones is global
connectivity through the cloud. An Internet connection will allow us to
provide global access, safe persistent storage and fleet management
software preparing us for the next rounds of feature releases.
{{< /milestone >}}


## The Software Components

This project reflects a _"real world"_ software project in that it
involves a variety of programming languages, protocols and
technologies: _Go_, C++, _JavaScript_, _HTTP_, _MQTT_, _Websockets_
and other stuff.

This set of articles takes more of a _systems view_ of software
application architecture, rather than a deep dive into a single
programming language or technology. Make no mistake though, this
content will take on some tough technical challenges and work out some
important programming problems in detail.

### The Process of Softwware Development

A heavy emphasis of this site will be on the software development
processes, often referred to as the _Software Development
Lifecycle_. We will cover topics like: _Agile_, _Kanban_, Test Driven
Development, Version Control and the release processes (CI/CD).

This information will be particularly important for product owners and
managers responsible for building a team that will deliver software.

#### Software Component Overview

The project at this point consists of the following primary software
components. Each of these components are operational and Open Source
with a [Github Repo](https://github.com/iot-station/). 
Instructions to build and run each component can be found on the
respective README.md file. 

If you are interested in getting involved in a specific software
component and related technology, head to that software component to
see what is going on and get involved!

