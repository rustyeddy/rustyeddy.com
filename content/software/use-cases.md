---
title: Use Cases
description: >
  A use case is all the ways of using a system to achieve a particular
  goal for a particular user that can be measured or observed in a
  specific way
weight: 20
---

## Why Use-Cases?

This post is going to talk about how we will use normal conversations
with the users of a software project we are about develop to lay the
foundation for the entire software development project.

These conversations are going to be in story form and we'll call them
_use cases_.

## Customer Discovery

_Customer Discovery_ consists of one or more sessions with all the
people (stakeholders) of the software (we'll call them users) and get
them to tell us stories about how the are going use the software.

Every story will be in plain, non-techy common language from the POV
of the user.  We will unravel each of the user stories into a series
of _use-cases_, much like unraveling a complex novel into a series of
short stories each with a single plot and conclusion.

The goal for each _use-case_ is break down the various ways the system
will _provide value_ to the user into a singular activities with clear
and measurable objectives.

### Here's An Example

My wife, Kelly is an active gardner, specifically she is really into
_succulents_ which do well in the dry warm climate we live in costal
Southern California. Succulents, like almost every other plant need
water, however you have to be very careful NOT to over water them.

They tend to be on the smaller to medium size plants where Kelly has a
few hundred of these crazy looking plants all over the place making
the process of caring for them a challenge, in particular keeping
water schedules.

#### Automated Watering System

So I thought I'd help her out and devise an automated water system for
her garden. This project is not just software but will also involve
prototyping and building hardware as well.

> Use-cases are not only valuable for software, but can be used while
> designing hardware or system for matter, including even a business!

Let's start with a hypothetical _Customer Discovery_ session that
could happen in the real world. In reality I derived the use cases
from years of watching and listening to her talk about this stuff, but
you don't have years so I'll summarize it in a hypothetical conversion
that could have really happend.

#### The User Story

Here is the hypothetical summary of the automated sprinkler system
that Kelly ask me to build: 

> I have a garden of a few hundred succulents consisting of a variety
> of types, succulents are very resilient but are sensitive to over
> watering and each variety can have different watering needs.
>
> I need an irrigation system that can automatically water my
> succulents when the soil becomes too dry, yet be very careful not to
> over water.
>
> I need to be able to adjust the soil moisture levels for different
> types of plants, because not one size fits all.
>
> It will also be nice to be able to manually water by pressing a
> button or even in some cases put watering on a schedule. Oh and
> wouldn't also be cool to keep track of temprature and humidity?
>
> Ya know, now that I think about it, can we also control some lights
> as well? Oh, one more thing, I'd like to observe and control my
> gardens sprinklers from anywhere with my phone.

Notice how no techy talk is involved in Kelly's description of what
she wants out of this magic gardening system. Also notice how the pretty
simple concept of automatically watering dry plants is starting to
grow more complex with feature creep?

```
Use plain language in user speak
```

## User Story to Use Cases

OK, now we are going to break down this quasi derived conversation
into use-cases that we will then:

1. Derive into a set of _testable requirements_
2. Bust out a todo list with well defined work items
3. Begin to design the _User eXperience_ with _wireframes_ and
   _storyboards_
4. Define our _Minimum Viable Product (MVP)_
5. Get ready to start building
   
The concept is simple and easy to understand, even our small example
this is a bit to unpack so let's get started.

## Requirements and Acceptance Tests

From each of these use-cases stories we can start extracting the core requirements,
desired features and all their hopes and dreams. We will break these
stories down into _use cases_.

Now let's get into what exactly these _use cases_ are going to look
like as well as how we are going to break them down into
_requirements_, _tests_ and prioritize them into specific work items. 

### Breaking out the use-cases

The primary subject of the conversation is that Kelly can use help
watering her hundreds of succulents most of which are sensitive to
specific soil moisture levels.

The story went on to bring up other wants from the system, some
required, some nice to haves but we will break them all out
individually focusing on the most important objective first, then
working through the rest of the _wants_ and _needs_ until we are done. 

```
Break out a single objective for each use case and focus on the
specific value it provides the user
```

#### Use-case 1: Water Plants when the soild is too dry

> Use-case 1: Peridoically measure the moisture level of soil and turn
> on a water pump when the soil is dry, then turn it off when it gets
> too wet.

##### Requirements for this use-case

The first use-case can now be summarized into the following three
requirements: 

---

1. Periodically measure soil moisture levels

3. If the moisture level drops below a certain level start watering

3. Turn water off when the moisture hits a high point

---

We will find as we move on even these basic requirements are going to
be broke down into more detailed specifics as we start moving into
development.

The key at this point is to still keep the words and conversation in
the users terminology, as they are still a very important part of this
process. 

##### The Specific Value of this use-case

The tangible value that Kelly gets out of this use-case is not having to
manually track and water plant herself while having confidence that
her plants are being adequately watered without being over watered.

### The acceptance test for this use-case

The _acceptance tests_ for this use-case will be observe a water pump
get activated when the moisture level hits the low mark, and the water
pump stops when it hits the high mark.

The tests are:

---

1. Water pump is not active when moisture level is below threshold

2. Water pump activates when moisture crosses the dry threshold

3. Water pump de-activate when moisture crosses the damp threshold

---

In the process of writing up these _acceptance tests_ it occurs to me
that the watering may not be instantaneous depending on how often the
moisture level is checked.

Also that maybe there should be a visual to indicate the soil moisture
level and if the pump should be running. 

These are good examples of how use-cases and necessarily the
respective acceptance tests can evolve as we start diving into the
details. 

As Ivar Jacobson likes to put it we'll start adding these details as
we _slice up_ the use cases and define the _official acceptance
tests_. 

That brings up another important point, where do we draw a line in the
sand and call an iteration _"finished"_ at least to the point we get
it in the users hand for feedback.?.

## The Minimum Viable Product (MVP)

We need to determine exactly what use-cases and specific features
_must_ be included in a release vs. which features can be _back logged_ 
for future development.

> Esential read: The [Lean Startup](http://theleanstartup.com/) to
> really understand how to get specific about building a product your
> target market will be crazy about.  TODO: reference to the MVP

By now we are all familiar with Eric Reis and his concept of the
_Minimum Viable Product_ which poses the concept of getting your work
in the hands of the user a soon as possible.

An important result of the customer discovery session is a mutual
agreement on what the minimum or useful (viable) piece of software is and 
which can be delivered as soon as possible.

The primary purpose of the MVP is to get stuff out the door. We
specifically want to avoid _development teams_ that are _disconnected_
from their _users_.

That often means delivering a system that is lacking many features and
even a bit janky or embarrasing.

### Kelly's MVP

In our case, I had Kelly single out a specific succulent that we can
use as we prototype the hardware and start developing the software, we
can hard code the mosture levels and visual observe the plants being
watered. 

The other features such as an LED, screen and app for visual feedback
as well as configurable moisture levels will be part of future release
iterations.

##### The User eXperience - User Interface

This use-case does not appear to have any user inputs or outputs other
than seeing water from the pump starting to flow knowing her plants
are being watered with out having to manually check and water herself.

In future use-cases we will involve a specific user interface, for
example: 

1. An ability to change the high and low moisture level configurations
2. Push a button, either physical or on an app to start or stop water
4. Led indicating the pump is on
4. Physical screen or app see when the pump is on and watering

We will eventually get to these above use-cases as well, to keep this
page from growing out of control we will continue with this use-case
for the remainder of this document.

If you want to see all of these use-cases broken out, clink on over to
the project. ```TODO: link to iot project```

## Slicing Up the Use-Cases

Now we are at the point that we will start breaking the system into
much more granular detail. At this point it is easy to start seeing
details pop out of nowhere and _scope creep_ becomes a real thing.

It is important that we stay disciplined and keep our tasks small and
manageable as well as identify the appropriate release iteration for
delivery. 

---

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


