---
title: Sensor Station I/O
date: 2020-09-06T10:32:26-07:00
---

# Sensor Station

Sensor Station is a collection of software components that make up a built to provide
a complete _Earth to Cloud_ _IoT_ framework.

## TODO Insert Diagram Here.

It starts by collecting data, cleaning and distribtuing the data to a
dashboard, databases, control logic and other interesting places. 

### Example Application

Spread a number of _Sensor Stations_ around a yard with the following
sensors: soil moisture, light sensor, temprature and humidity. All
this data is gathered by small inexpensive devices (micro-controllers)
that run off solar or battery power collecting afore mentioned data.

The data is transmitted via wireless network to a _Macro-controller_
that collects, cleanses and passes the data along to it's desired
locations including but not limited to: a _real-time dashboard_,
_time-series database_ and _control logic_.

The data can then be used to turn on and off lights and sprinklers,
amoung a variety of other cool things.

## Components

### Micro Controllers

For our purposes we will build _Sensor Stations_ from little,
inexpensive micro-controllers are fitted with sensors including soil
moisture, air temp, humidty and such. The devices will be able to
transmit data wirelessly back to a _Macro Controller_ that cares for
the data and sends it to it's various destinations such as control
logic, databases, dashboards and so on.

### Mesh Network

The micro controllers are capable of forming self configuring _mesh_
networks with slimmed down wireless network protocols (wifi & ble)
ideal for low to moderate data rate sensor advertisements may include
streaming video in certain conditions.
   
The mesh network allows devices to be scattered about in arbitrary
patterns to form networks that are capable of covering large areas
even with out any power or network infrastructure.  The _Mesh_ is self
forming and healing, zero configuration, zero infrastructure capable
network with an optional _IP Gateway_.

The mesh networks are advertised capable of 10Mps (or 1mps) per device
stream up to 200m (NEED TO CHECK THESE NUMBERS) and of course in the
real world YMMV.

### Dashboard (Web App)

A nice modern dashboard application for monitoring, configuring and
maintaining this system.

## Macro Controller

The Macro-Controller is basically what is known as a _micro-server_,
this one happens to be built with IoT applications in mind. It
includes a number of powerful features one would expect from a modern
industrial strength micro server.

Feature List:

- Serves up HTML for Webapp (SPA)
- Serves up HTTP _ JSON for REST API
- Speaks MQTT with IoT devices
- Speaks Websocket to with _real-time_ modern web applications
- Simple, very little (to no) configuration required
- Zero Configuration (plug it in and let it go!)

## Software

- Go: fast. _REALLY_ fast!
- Application is a single binary, Just like the good ole days!
-- No big ass frameworks to lug around, build or conflict.

### Separation of Data and Control

As will be seen as this architecture is drawn out, there is an
quasi-abstract layer of communication between the providers of data
and the consumers of that data, this provides us with all sorts of
advantages to do great things, but it does indeed bring along it's own
level of complexity that must be cared for out of the gate.

### TODO Speak more about messaging?

## Cloud Support and Automation

### TODO Write Up cloud automation

A lot can, and will be said about cloud automation. 

## On Prem _ Public Cloud _ Hybrid
## Automation, tools and Blueprints

