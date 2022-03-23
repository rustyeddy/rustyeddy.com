---
title: IoT Gateway Collects MQTT Data
date: 2021-12-01
description: >
  The IoT Gateway program is established with an MQTT library for
  which it recieves data from the network and data channels.
category: iot-gateway
tags: [ go, mqtt, iot ]
draft: true
---

The IoT Gateway (iot-project/hub) is a small _micro-service_
written in the delighful [Go programming language](http://golang.org).

1. Create a github repository
1. Checkout the empty project
3. Import the eclipse paho MQTT library
1.3 Connect to MQTT Broker
2.2 Subscribe to net/announce/+ for station information
3.3.3 Define Callback
3.3 Subscribe to data/+/+ => data/<station>/<sensor>
3.3.3 Define Callback
