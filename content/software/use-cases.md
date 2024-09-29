---
title: Use Cases
description: >
  We are going to dig deep into our users needs and observe how they
  want to use the software, this will ultimately lead us to our
  MVP. We will define this in terms of Use Cases.
weight: 20
---

## Overview

This definition is from the
[Wrike](https://www.wrike.com/blog/what-is-a-use-case) 
website:

> A use case is a concept used in software development, product
> design, and other fields to describe how a system can be used to
> achieve specific goals or tasks. It outlines the interactions between
> users or actors and the system to achieve a specific outcome.  

## History 

- First article on Use Cases was established by Swedish computer
  scientist Ivar Jacobson in 1987 originally used by
  telecommunications company Ericsson to capture system requirements.
   
- In 1992 Jacobson co-authored the book "Object-Oriented Software
  Engineering - A Use Case Driven Approach" to help specifying
  functional requirements in Software Development


## References Definition of Use Case

- [Ivar Jacobson](https://www.ivarjacobson.com/publications/articles/use-cases-ultimate-guide)

This document about use-cases is by the one and only Ivar Jacobson
himself. This document claims to be uses cases 2.0, an improvement on
the revolutionary process of extracting and defining requirements for
software projects.


## Outline

### Overview

- Defines the various ways users will use the system/software

- Can and should establish success and failure scenarios

- Used to capture system requirements
   
- Use cases should help capture success and failure scenarios

- Use cases can help define functionality in an incremental aligned
  with _agile_ methodologies. 
  
- Use cases do not tell you HOW you should plan, schedule, test or
  develop the system, but do define a structure of that can be used to
  engage these practices
  
### First Principals

Acording to Jacobson these are the _first principals_:

1. Keep it simple by telling stories
   - Story telling is the easiest and most effective way to
     pass knowlege from one person to another. Story telling is older
     than the Bible! 

   - Each story will tell of a single way to successfully achieve a
     specific goal of the system, also how to handle problems that
     will inevitably arise.
     
   - A single use case is a story focused on achieving a single goal
   
   - Do NOT attempt to describe the entire system in one long story
     rather break the system down into a series of small very short
     stories. 
     
   - The stories must be communicated and captured in a way that makes
     them actionable and testable, i.e. they can be _measured_ in a
     concrete way
     
   - The test cases are the most important part of the Use-case, as
     they define what a successful outcome is.


2. Understand the big picture
   - You need to understand the big picture in order to make
     prioritized decisions on what should be added and what needs to
     be left out.
     
   - He goes into creating use case diagrams
   
   - Use cases do not have to involve people, they can involve other
     automated entities.
     
   - use cases can involve actions from many different users. You can
     have end users, system administrators and support people for
     example. 
     
   - The goal is to make the collection of Use case goals accessible
     to everyone. Use case diagrams can help visualize the various use
     cases. 

3. Focus on Value
   
   - When trying to understand how a system is going to be used, it is
     important to focus on the value it provides the users and other
     stakeholders
   
   - The goal is to focus on the specific value the system will give a
     specifig user, rather than long lists of functionality.
     
   - Start with the simplest possible way to achieve the goal
   
   - Provides an example

   - The use cases can have optional cases or variations on the
     standard simple case
     
   - Alternative flows / cases do NOT have to be captured at the same
     time. These can be added later.
     
   - It is almost always more valuable to complete and deliver the
     simple easy use case first, get feedback and incrementally
     deliver alternative flows later.  Rather than wait for all
     features to be perfect
     
4. Build the system in slices
   - 

5. Deliver the system in increments
6. Adapt to meet the team's nees.




---

## Previous writings


## Customer Discovery

_Customer Discovery_ consists of one or more customer discovery
sessions, where all *users* and *owners* of the software will be
interviewed for their expectations, needs and desires for the
upcoming software project. 

Don't just stop at the first answer, it will be too vague. Dig deeper
and start peeling back the details. This great article on the
[Five Why's](https://www.mindtools.com/pages/article/newTMC_5W.htm)

## User Stories

The information gathered from these sessions are then articulated in a
series of _non-technical_ descriptions of how the software is used by
everybody.

These descriptions of the software requirements are often referred to
as _User Stories_. Basically, each _story_ walks through one of the
ways in which the _planned_ software will be used.

### Keep Language Plain

The project can be discussed and understood best when the conversation
is had in terms that the user is comfortable with.

It is important to keep the language common and avoid tech talk such
that _everybody_ involved with the building and using the software can
participate in the conversation.

These user stories will later get broken down into specific tasks.

The real value to user stories is to create them like they are
recipes. Essentially software is about writing recipes with very
specific rules.   

## The Good 'ol Minimum Viable Product (MVP)

An important result of the customer discovery session is a mutual
agreement on what the minimum or useful (viable) piece of software is and 
which can be delivered as soon as possible.

The primary purpose of the MVP is to get stuff out the door. We
specifically want to avoid _disconnected development teams_.

Software can be properly managed just like  construction project. That's only if the right processes and tools are established and enforced
throughout the product lifecycle.

> Read The [Lean Startup](http://theleanstartup.com/) to really understand how to get specific about building a product your target market will be crazy about.

This is an involved and very important topic. I'm not going to attempt to
repeat or summarize them in this document, but we will assume that we
have a pretty clear picture of the application we are developing, at
least enough for now.

## Tasks Are Small and Measurable 

The tasks that we come up with must be completed within a day or
two. Any task that requires three days or more should probably be
broken down into smaller bite-size tasks.

We do not want to create tasks so that they're too big, ambiguous or
subject to misinterpretation. If your team is not making progress in a
day or two you should be able to know that immediately.

Keeping the granularity of tasks small allows the team to _start
stacking victories quickly_ and more important, gives everybody a
chance to see when a software project is about to make a left turn.


### Goals are Most Effective When ...

Goals do not have to be obnoxious, obtuse, vague or
pendantic. Just be real and reasonable.

If you want working software, provide a working set of goals.

- Few in number, very targeted
- Communicated in normal people language (user stories)
- Provide users quick and immediate value
- Prioritized to deliver _usable value_ incrementally
- Measurable and easy to determine when they are complete
- Everybody understands and agrees with the Goals
- Tasks should be 1-3 days max if possible (there will always be exceptions)

All these tasks have to add up to the MVP. Anything that does not
directly and immediately get the software project closer to an MVP
must be avoided.

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



