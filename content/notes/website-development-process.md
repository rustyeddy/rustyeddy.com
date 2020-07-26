---
title: Website Development Process
date: 2019-11-03
description: >
  This page will overview the process developing your website.
draft: true
---

## Measurable Goal

To be truely effective _and objective_ we need to be clear about an
outcome or desired effect of every project we take one. It is best to
select a single overiding, measurable goal.

That goal should be measurable, it could be a dollar amount in sales,
a number of email subscribers (or InstaTwitter followers) or any
number of other things.

### A Dynamic System

The more specific or goals become the better we are able to ascertain
the success of our project.  Most important, we must use our
measurements and other observations as input to adjust and improve the
site. 

We should expect to _iterate_ our site over time, driven by improvement.

## Sitemap 

Create a sitemap that declares every section (category and tags) of
the website. 

The sitemap will provide a high level of structure for your website.
The sitemap can act as _inventory_ for the site, which can be used
later to track the health or the website, spread of visitors through
the site, or just deciding what to retire.

The sitemap can be created with a .yml file.

## Wireframes

Wireframes define the layout of every page and section of the site.
The wireframes can be transformed into a template or set of templates
to be filled with the appropriate content (includes text, image and
video).

## Style Guide

The style guide is a one stop shop that dictates the over all look and
feel of the site. Style Guides include the following bits of
information: 

- Color palette
- Fonts and Font Sizes
- Spacing
- Element Types (headers, alerts, popup boxes)
  
### Responsive / Mobile First!

Remember to be responsive and mobile first!  Phones are the reality of
today. 

Aging people with depleting vision appreciate the ability to increase
font size and use less screen.  Github is still not mobile friendly.
Or even small screen friendly.

## Content Plan

- Content for every page defined on the sitemap
- Major Topics, Pain Points and Phrases 
- Keyword research, phrases
- Editorial Calendar

The content plan will guide the topics that eventually get written
about as articles, discussed during promotion and cross linked.

### Media Manifest

Many, (most or all?) websites have images, video's and/or other forms
of media that we must keep track of.  That is were our _media
manifest_ is important.

The media manifest defines all pieces of media that will go on every
web page.  The media manifest should have some meta info about the
particular media type.

Likewise every section or spot on every page has a specific piece of
content or media, that can, _in theory_ be linked to define an entire
website. 

## Road Map

- Start with a specific measureable goal and build from that
  - Every addition or new feature serves a specific purpose
  - The new feature does not disrupt previous use
- Story board and Wireframe
  - Identify use cases
  - Walk through use cases with story boards
  - Wireframe every step of the story
  - Every frame of the story requires content
	- written
	- video
	- images
	- other: pdf, etc
  - Every story has a specific measurable conclusion
- Style Guide
  - Getting some help from friends
	- Rafal Tomal
	- Refactoring UI
	- Nathan ...
  - From Wireframes to Layouts
	- Designer to Developer (lets loose labels and embrace strengths
      and weaknesses)
  - Color Pallete
  - Typography
  - Template from Layouts
- Development Host
  - Never develop in the wild
	- Risk of disaster increases astronomically
	- "Fixes" get out of sync, all fixes must funnel through a well
      defined process.
	- Using devhost
- ALWAYS use protection, we have a VCS!
  - Version control, we'll use github
  - Everything is easy to find, but YOU must follow the rules
  - Everything can be automated to ensure quality!
  - Everyhinng can be REMEMBERED!!
- Keeping it Simple
  - Static sites generated from hugo (you can use jekyll, or..)
  - Just need simple hosting (no databases, etc.) github pages will do
    just fine, thank you
- Tracking Bugs and Requesting Features
  - Issue tracking and github issues
  - Github projects (alternatives) and kanban board
  - issues, to commits, to test runs to release, to closing.
- Production Hosting
  - CI/CD release process: hugo to github pages
  - add build step
  - discuss other "static" hosting alternatives
  - discuss other hosting options that includes databases
  - mention other sophisticated backed ends
- DevOps
  - CI CD process from fix the production
  - Monitoring and responding to problems
  - Problem tracking to testbed
	- turn production bugs into futur tests
  - collecting lots of data, what to do?


That's, there is nothing left todo! Time to kick back and chill out.
That is, unless you want to do something with all this work, like
market it to real **paying** users!  Or build out a GraphQL backend
with MQTT to support your fantastic _Single Page App_..

Then, there's plenty more work to do, but let's kick it for a bit.
