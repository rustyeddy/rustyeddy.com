---
title: IP Multicast the basics
description: >
  IP Multicast is a seldom used but very useful mechanism for groups
  of machines to communicate.  I will cover the basics of IP multicast
  in this document.
date: 2018-02-03
---

## IP Multicast addresses

The typical IP addresses used by computers networking today are known
as _unicast addresses_, meaning that every unicast address as a single
(physical or logical) end point.

Most all computer networking is _point to point_ between two specific
IP addresses, you name it: web browsing, email exchange, transfer
files and so much more.

However, there are other more specific forms on communication
available and occasionally used: Broadcast and Multicast.

#### Broadcast vs. Multicast

- Broadcast to everybody
- Muilticast to a select group that have opted-in

### Link local multicast and ethernet addresses

- Ethernet muilsticast addresses
- Link local multicast and broadcast used all the time
- Stays on a single physical link (or broadcast doamin if switches)
- efficient transfer of redundant info
- resource discovery

### IP Multicast and IP mutlicast addresses

- IP also has multicast address (class D) 224.0.0.0/32 to
  239.255.255.255/32
- one sender many recievers
 
## IP Multicast Routing

Setting up local IP multicast domains is not very difficult, IFF you
have control over the local network, and can quickly recover if
something goes wrong.

## IP Multicast Routing Interdomain (worlwide!)

Multicast can extend beyond a link local network, building or
company.  But it is **heavily** regulated and global multicast feeds
are generally not available unless you have a specific application and
setup blessed by the powers above.

## IP Multicast In the Real World

> TODO: provide real world examles for this article.

> TODO refer to my multicast work  CRS and pimd


