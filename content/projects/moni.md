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

### Storage and Persistance

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

> TBD the store package we use in moni will soon be extended to
> include some of the top cloud providers.

Since our storage needs at the moment are simple we will stick with
the file system and use locally saved JSON files.  _Until we go head
into a real data base_.

#### TBD TimeSeries Database

In a short period of time, we will want to record a series of data
over time and hence a _Time Series Database_ such as _influxDB_(http://influxdb.io) is 

### Web Walker 

The purpose of _moni_ is to periodically walk the websites under
survelience, tracking all links on every page of the website for
reachability and responsiveness.

A database or databases will be utilized in the future to track
performance and availability over time, this will help determine if
there are trends in a website slowing as well as recurring problems. 

The above endpoints allow the user to get a list of website that are
being tracked, submit a new site for tracking, retrieve details on a
specific site walk and last to retrieve details on a specific page.

## Architecture

Moni was intentionally written to be simple, a single executable can
be copied to a new computer and begin using _moni_ without previously
installing any other requirements.

Now I do have plans that allow _moni_ to interact with various other
tools such as a Database or two, MQTT and Websites, in addition to the
existing REST interface.

This was made simple because it was developed with go.

### Colly For Website walking

Colly walks and scrapes the websites gather info we need. At the
moment we are only gathering the links (and anchor text) for links
that exist on sites we are watching.

I do not know Colly very well which is testament to how well it is
written, It was simple to get started with and just worked!

### Go Channels Job Q

We can use Go channels as a Job Queue. By creating a channel of, say
100 items with urls to be walked and with the walker reading URLs from
the channel we have created a very simple reader/writer.

### Go time.Ticker Job Scheduler

There are a number of ways a job scheduler could be implemented. One
possibility is using a slice of URLs that need to be walked, perhaps
with circular index or a timer wheel. 

Or we can create a Ticker for every URL that we will be walking. The
method or that listens on the ticker channel will run as a go
routine. When the ticker is activated, the URL to be walked is sent to
the _walkQ_ channel where it will be queued up for walking.

This means we have no queue's to synchronize, sort or update. We can
end up with a bunch of Go routines running in the background, one for
each URL we are watching.

>Is this better or worse than managing a Job queue?

Methinks this way is better! But I admit to being lazy also. Can this
be made better?

### Gorilla Mux

#### REST API

The first iteration will provide a REST API and a Web UI with a form
and a page that displays the results of a single page walk.  The rest
API will provide the following endpoints:

- GET	/api/sites
- POST	/api/site/example.com
- GET	/api/site/example.com
- GET	/api/page/example.com/about

#### SPA Web UI

- A single page with the following capabilities
  - display list of all sites
  - display list of pages on a given site
  - display links from a given page
  - display aliveness of page
  - display aliveness of every link from page
  - display response time of every page
- Form that allows new site inputs
  
## Development

I am trying to be purposeful while developing this tool, that is
adding specific features, that accomplish important tasks with out
breaking previous functionality or complicating the code beyond
supportability. 

It is written in Go and expected to run on a typical Linux server,
though I do not believe anything should prohibit from being used on
alternative platforms.

### Resources

- Source is all on github
- Have a problem? Issues are on github
- Roadmap See projects on github
- Deployment see CI/CD plans using github activities
- DevOps our deployment and operations is all automated
  - provision with terraform
  - configure and launch with ansible

## Deployment

This project will be deployed with a cloud provider. My favorite at
this point is _Digital Ocean_. Ideally we'd start out with Terraform
and fire up the hosts / containers of our base topology ready
listening for their configuration instructions

### Cloud Providers 

Software load balancer, two servers running cloud providers.

## Support
