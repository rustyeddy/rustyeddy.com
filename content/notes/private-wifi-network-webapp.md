---
title: How to build a private WIFI network for your WebApp
date: 2021-07-22
description: >
  There are times when a device loaded with software needs to be
  configured without a keyboard or monitor. A WebApp is a great way to
  do just that, but what if you can't or don't want to connect to an
  existing Wifi network. We will discuss these scenarios in this
  document. 
---

I work with _physical computing_ or devices that have rather
sophisticated software that needs to be configured, monitored and
controlled.

## Building a Private Wifi

Here is the situation, I just plugged a white box into the wall and it
has a steady green light. I can see two other lights, one of which is
red. The other two lights are off.

This device is pretty cool, it will control the lights in my garage, I
have a well lit garage. But I need to configure this thing to set up
lighting schedules, basically synchronize with daylight.

### Making a Wireless Connection

I can't stick a monitor or a keyboard cable into this thing. However,
since my device is running good old _Linux_ with a nice Wifi chip, we
are going to turn it into an Access Point (AP).

To make this connection happen we are going to do the following:

1. Install and configure _Device_ as an AP with a specific SSID
2. Device with a browser like Firefox connects with wireless SSID
3. Browser (firefox) connects to device URL
4. Device sends configuration pages to Browser
5. User configures the device then saves and exits

At this point the device operates on it's own, not needing anymore
interaction. However, this same method of configuring the device can
used to monitor through a dashboard. 

### Configuring the AP

_HostAPd_ is a very popular _Linux_ tool that will help us easily
configure the _Device_ as an _AP_ advertising a specific SSID.

_hostapd_ is available from _Debian_ distributions with the familiar
apt packaging.

> apt-get install -y hostapd

This needs to be configured, here is what I do to help configure every
device with a _unique_ but _recognizable_ _SSID_. The WebApp user
should have a simple time connecting with the private network and
subsequently the browser connects to the server and bang, off and
running. 

## Reasons for a Private Wifi 

OK. Why not just connect to an exiting network? In some cases we will
connect to an existing network and hence take advantage of _Internet
Services_ and on premise infrastructure.

### No Access Allowed

There are many cases, like a top secret skunk works projects or an
industrial production facility where they want to isolate unnecessary
external devices from internal infra structure.

### Reduce Security Vulnerabilities

Creating private networks allows control of who and how that network
can be accessed. By limiting access to external networks from my
lighting system and am reducing the surface of my security
vulnerabilities. 

### No Access At All

Sometimes we are in the middle of almost nowhere, like the High
Sierra's, there is no _Internet_ or Wifi Infrastructure. And good luck
trying to get a cell phone signal (hey T-Mobile!) up there.

However, a little WiFi connectivity can still be had! Thank You _Solar
Power!_.

## Conclusion

This article is not finished, I ran out of time. I will finish it, but
only if somebody asks me to.  Heck if nobody will read it, then should
I spend the time?

Is the sound of a singing bird beautiful if nobody hears it?

