---
title: Use Cases
description: >
  A use case is all the ways of using a system to achieve a particular
  goal for a particular user that can be measured or observed in a
  specific way
weight: 20
---

## Customer Discovery

_Customer Discovery_ consists of one or more customer discovery
sessions, where all *users* and *owners* of the software will be
interviewed for their expectations, needs and desires for the
upcoming software project. 

### User Stories become Use-Cases

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


> A use case is the smallest unit of activity that provides a
> meaningful result to the user

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

    - Complex systems should not be attempted to build in one go,
      rather they should be built in _slices_
      
    - Each slice should be delivered providing clear incremental value
      to it's users
      
    - The receipe is to focuse on the most useful thing the system has
      to do and focus on that feature. Then take that one useful
      feature and slice it into thinner slices
      
    - Determine the test cases that will validate that particular
      slice and implement the test cases followed by the slice itself 
      
    - Put any slices aside for questions that can not yet be answered
    
    - You can make _estimates_ for the time and effort required to
      implement that slice but _estimates_ are just that
      
    - Test cases are the most important part of the use case narrative
      because they make the story real.
      
    - To find the _central_ theme you will need to shed all the lesser
      important features and focus on the most useful thing the system
      does 
      
    - Once enough use-cases have been implemented the user will have a
      system that is useful, though still lacking features, but those
      will eventually be implemented
      
    - The slice should be a complete implementation, not just the code
      that fulfills the requirements but tests, user experience,
      architecture, documentation, test framework, integration and
      delivery (CI/CD)
      
    - A use-case is probably too much to be implemented in one
      two-week period however a slice of a use-case should be able to
      be implemented in one two week sprint
      
5. Deliver the system in increments

    - This seems like it is repeating use-case slices.
    
    - Software evolves in generations vary rarely, even for the
      smallest project are they developed and forever complete in one
      go. 
      
    - Software typically evolves over release after release building
      on what came before it
      
    - Use-cases are a great tool for release planning. Releases can be
      based on a particular group of slices being implemented even
      before the complete use-case itself has been developed.
      
    - Use-case diagrams can be useful

6. Adapt to meet the team's needs

    - Not all teams or software projects are the same, the system of
      use-cases needs to be adaptable to the team and project needs
      
    - Projects that have close interaction with _stake-holders_ and
      most specifically the users will be the most efficient and
      flexible (agile)
      
    - Projects that lake user input due to whatever reason will need a
      lot more detail in the requirements up from and be much more
      heavy weight
      
    - Use-case can be made extremely light.
    
    - The tools used can be as simple as use cases written on index
      cards or more official captured in electronic tools, for example

### What are stakeholders

Everybody that has an interest in the software

- User that use the software on the daily
- Administrator that has to configure and maintain the software
- The person paying for the software
- The developers and devops folks running and fixing the software

### What is the System

- It is typically a software system, it can be SaaS, an embedded
  system with software and hardware or even a new business
  
### More about use-cases

- They are iterable, the first telling of a user story may not be the
  final version
  
- Fullfill the simplest story first (slice)

### Priorities, Slices and Estimates

Once all use-cases have been captured they can then be sorted
according to priorities, the highest priority use-cases can then
be have implementation estimates.

### Creating the Backlog from Use-case slices

From use-cases to the Kanban board


---

## Previous writings


