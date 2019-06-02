---
title: Stream HLS from NGINX
date: 2019-05-31
description: >
  This document describes the process of setting up NGINX to serve up
  live streaming video.
category: 
  - streaming video
tags:
  - hls
  - mpeg-ts
  - rtp
---


- Setup gzip to compress text based M3U8 index files.  They can be
  large and are downloaded frequently.
  
- May need to shorten the TTL values for M3U8.

- For VOD the index file is statis, hence does not change and only
  needs to be downloaded once.
  
- Security over HTTPS

- Browser to display video in HTML5 tags.

x264enc ! mpegtsmux ! hlssink max-files=5
