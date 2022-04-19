---
title: How to Build a Self Watering Garden
subtitle: A Guide to Developing IoT Software
url: iot-project
date: 2020-09-06T10:32:26-07:00
description: >
  This project will gather sensor data such as soil moisture, heat and
  temperature to determine when to start and stop watering a
  garden. We will use very inexpensive hardware and Open Source
  software getting started is very easy on the wallet!
git: https://github.com/iot-station
---

![High Level Sensor Station](/img/iot-project-drawing.png)

## What is this project about?

_Organic Gardner (OG)_ is an automated irrigation system that gathers
soil moisture levels from various sections of a garden then uses that
data to activate the garden sprinkler system. Done right, this will
eliminate both over and under watering. Likewise there will no longer
be any need to program the watering schedule with confusing sprinkler
menus. 

> Although she does not know it yet, my wife will volunteer her
> succulent garden for testing!

From this hopefully interesting and useful example project we will
establish a set of _Best Practices_ and _software_ that will help
reduce the complexity and time to market with your IoT software
project. 

### What Makes IoT Software Different?

An IoT project usually involves taking a physical device (or
functional system) like a doorbell (Ring) or Heater (Nest) and adding
smart software with an Internet connection to open a whole new world
of services.

The _Ring Doorbell_ is a popular example of an IoT enhanced product.
It allows you to see and talk to somebody on your porch when you are
a thousand miles away or in your bathroom.

The _Nest_ thermometer learns exactly what temperature you want your
house, it then keeps your home exactly the temperature you want. Even
better, when your not home it will not waste any energy.

> Just applying smarts to reduce energy consumed in widely used
> applications alone is an worthy avenue to pursuit 

#### IoT Brings New Challenges

With all the great new capabilities IoT software brings with it today,
these same benefits also bring bring a heavy cost of complexity. The
key to beating the complexity and efficiently building robust software
is to embrace the right processes, a major goal of this website.


#### Establishing Best Practices

By establishing the right _Software Development Processes_ for your
project based on _Best Practices_ gathered on this website we can work
together to reduce complexity and build software that is more simple,
robust and reusable.

## The Development Plan

To avoid being overwhelmed with details and keep the project moving
forward we will build it out incrementally, one interesting feature at
a time stacking cool feature on top of cool feature. Testing will be
performed initially by _mocking_ the collection station MQTT
publishers with the ```mosquito_pub``` command line tool. 

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
<code>mosquito_pub</code> publishing tool. The data collected is stored
efficiently in RAM for quick retrieval
{{< /milestone >}}

{{< milestone 2 "Hub Provides REST API for Data " >}}
Now that the Hub has data efficiently stored in RAM we need a way to
access the data, for that we'll create a REST API. The REST API is
dependent on an HTTP server and router that can easily be provided
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

### The Process of Software Development

A heavy emphasis of this site will be on the software development
processes, often referred to as the _Software Development
Life cycle_. We will cover topics like: _Agile_, _Kan ban_, Test Driven
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

