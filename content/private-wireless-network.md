---
title: Private Wireless Network for IoT Devices
date: 2021-08-30
description: >
  All sorts of control and info gathering devices like doorbell
  cameras and wireless speakers need to talk to an app of some type,
  how does this when an existing network is not available, or you want
  to keep other devices off?
---

## Overview

A _Private Wirelss Network_ is a common solution, one relatively
simple way to create a PWN using a _Raspberry Pi_, some free software
and a bit of brain greese we can turn our favorite $50 linux computer
into a PWN provider aka _Wireless Access Point (WAP)_.

### Automation!

Yes, my favorite words. I took the time to automate the configuration
of a RPI into a Private WAP.

## Building a Private WAP

_Normally_ an RPI will be configured to accesss a wireless network as
a client provided the RPI has been configured via an accessible _SSID_
and correct _password_.

Using popular and powerful free software:

- dnsmasq
- hostapd
- route tables updates

and a couple other itmes that will be discussed in the detailed
_playbook_.


