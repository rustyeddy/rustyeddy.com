---
title: Software Development Guide
draft: true
date: 2018-10-02
description: >
  This document I briefly describe the primary elements of my software
  development process, if more details are required, then perhaps I
  will find to the time to expand.
draft: true
---

This guide is best suited for small to mid sized development projects,
a good example are micro-services or embedded development for small
manufactures, makers and IoT companies.
<!--more-->

## Software Development Process

### Start A Specific and Measureable Goal

It is surprising how many software project get underway without a
clear direction to what they are building.

> Do NOT build a house before you have approved architectural
> drawings.

The above statement should be self evident. The same applies to
software.

### Define Good Goals

Good goals keep everybody focused and working toward the same
endpoint. They must not be 

1. Singular: have a single requirement. Do not confuse the issue with
   second and third level concerns
2. They are easy to understand to everybody is always on the same page
3. Goals must be measurable, you have to be able to tell when they are
   done, or how well they are working.
4. Realistic: do not make people feel like the must continually be
   superwoman.

### Story board and Wireframe

For me the is nothing better in the early part of designing a new
system and software is to begin the visualization process as early as
possible. 

#### Storyboards Walk Through Usecases

Storyboards ought to be created for the major _use-cases_, there should
be one _frame_ for each step in the _use-case_ should help bring forth
details of decisions that need to be made.

Storyboarding in evitably leads to more and more frames with growing
detail and notes.  By all means keep jotting down the notes they will
become important soon.

> The quality of the storyboard defines the quality of the User
> eXperience! 

#### Wireframe define The Story

Every click of a button or newly entered form typically takes the user
onto a new frame in the story, which also likely means a new web page,
or popup to look at and work with.

When the storyboard starts to take form, it is time to start nailing
down the _wireframes_ for the application.  Wireframes are going to:

1. Specify usage of every pience of screen real estate.
2. Identify specific content on each page
3. Identify all media for page (video, images, PDFs and CTA)
4. Clearly identified CTA

### Style Guide

#### Great References
- Rafal Tomal
- Refactoring UI
- Nathan and ConvertKit

#### Style Guide

- Color Palatte
- Typography
- Templates are page layouts (from wireframes)

### Development Host

- Development Host
  - Never develop in the wild
	- Risk of disaster increases astronomically
	- "Fixes" get out of sync, all fixes must funnel through a well
      defined process.
	- Using devhost

### ALWAYS use protect with a VCS

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

## Other Tech Topics

- Streaming Video
- Ansible and Fleet management
