---
title: IoT Real-time Dashboard
date: 2022-01-12
weight: 30
description: >
  The dashboard is a WebUI built into the Hub providing a window into
  your environmental health with real-time data and historic values.
---

### Dashboard - Real-Time and Historic Environmental Data

The dashboard is a WebUI built into the Hub providing a window into
your environmental health. All sensor data is transmitted over a
dedicated _MQTT_ _channel_, the channel is comprised of a _path_ that
looks like a _directory structure_ or URL path. Contained in the path
are the _identification_ of the device and the name of the _sensor_.

With this design, any _data publisher_ can contribute to the _Sensor
Station Application_.

