---
title: IoT Real-time Dashboard
date: 2022-01-12
weight: 30
description: >
  The dashboard is a WebUI built into the Hub providing a window into
  your environmental health with real-time data and historic values.
---

## Dashboard WebApp

![Example image](/img/dashboard.png)

The dashboard is a WebUI built into the Hub providing a window into
your environmental health. All sensor data is transmitted over a
dedicated _MQTT_ _channel_, the channel is comprised of a _path_ that
looks like a _directory structure_ or URL path. Contained in the path
are the _identification_ of the device and the name of the _sensor_.

With this design, any _data publisher_ can contribute to the _Sensor
Station Application_.

### Mobile First

I have no doubt or argument with the _Mobile First_ discipline,
personally I still do most of my _browsing_ on a computer, not so much 
a mobile phone.

Likewise, I don't normally build _mobile_ apps or _web pages_ until
now. 

It is quite obvious that mobile is huge and a very important game
changer. 

The reason I am biting the bullet and beginning the mobile development
is because of _Google Search Console_, it had switched modes to mobile
because it detected most of my website visitors are from mobile
devices. 

OK, I get the hint. That is why the IOT Station _dashboard_ will be
designed for _Mobile First_.

### Written with Vue

React or Vue? That was the question, vue was the answer.

Why Vue, what makes these modern frameworks so attractive, why not
just write good ol JS.


## User Story

1. User visits website and sees the dashboard.

2. User can select station view and get an 
   enhanced view of just that station.

### Wireframes

1. Stations List view Wireframe
1. Station Detail view wireframe

### Storyboards

See User Story

### Media Manifest

1. Logo
2. Icons for 
   1. each of the sensors

### Data Manifest

Local station.sensor time series values.

