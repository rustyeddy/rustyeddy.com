---
title: Moni the Web Sitter
date: 2019-12-21
image: "/img/moni.png"
description: >
  Moni will periodically walk the owners website reporting
  availability and performance.  Moni will also check the reachability
  of all links on the monitored site.
---

Moni was built to monitor resources I manage that are attached to the
web. Keeping track of servers, apps, websites and devices quickly
becomes a mess. Moni can server as an inventory database periodically
checking the health and performance of the things it manages.
<!--more-->

## Goal and Requirement

The primary goals of Moni are as follows:

### Moni Backend Server

- Provide a CRUD REST API for Sites
- Utilise colly to crawl specified website and child pages
- Record and classify external vs internal links
- Test for performance of a given page
- Test for accessibility of all links, external and internal

### Moni Storage

What type of persistance should we use?  We can go crazy with this
one, mongo, mysql, postgress, other NoSQL?  Sure we can, but let us
keep this simple and just use the file system for persistence.  Yea, I
know this is no kind of _modern web app_ without a sexy data
persistance engine, right?

Well, lets what we would like to store _exactly_? For now, we really
just want to store the domain name, the other external information we
will gather, from the respective __source of truth__ reside in
external sources, for this reason we can avoid _caching_ these results
in our own databases, and build them live from the SOT.

#### TBD TimeSeries Database

In a short period of time, we will want to record a series of data
over time and hence a _Time Series Database_ such as _influxDB_(http://influxdb.io) is 

### Moni SPA

- A single page with the following capabilities
  - display list of all sites
  - display list of pages on a given site
  - display links from a given page
  - display aliveness of page
  - display aliveness of every link from page
  - display response time of every page
  
### Moni 


The purpose of _crawl_ is to walk a website recording the response
rate from the server(s) and the reachability of every link on a given
page. 

The first iteration will provide a REST API and a Web UI with a form
and a page that displays the results of a single page walk.

## Ops Overview

The program _crawl_ can be run interactively as a command line tool
with appropriate arguments, it can also be run as a _daemon_,
listening for incoming URLs from the API

## Architecture

## Development

## Deployment

## Support
