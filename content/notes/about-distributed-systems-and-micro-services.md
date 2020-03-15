---
title: MicroServices and Distributed Systems Force Clarity
date: 2018-02-11
description: > 
  The process of building a distrubuted system forces one to identify,
  explicitly the procise protocol the two machines will communicate
  with. This present opportunity to carry this rigor of formality
  through out system design.
category: rambling
draft: true
---

I am very much dedicated to building distributed, micro-service style
systems. I prefer to piece solutions together based on lean,
efficient, best of breed components.

Besides, I work with _micro-controller_ type of devices regularly
which forces me to build out distributed system by definition.

## More Complex?

Many rightly claim that a distributed system increases the complexity
over the monolith, and it is true that communicaiton boundaries must
be explicitly created, and that communications between the boundarys
becomes a potential for failure, or reduced reliability that tightly
couple systems do not have to deal with.

Using the above observations as guiding principals for enforcing the
discipline to benefit from a smoother construction phase of developing
the system. 

If done with care and an eye toward simplicity and robustness, a team
can start developing patterns that are mandated according to the
driving force of the application they are developing.

### Clearify and Simplify Interfaces Early

In otherwords, distributed systems force an explicit definition
between APIs of subsystems.  That easily translates into communication
busses that can be _snooped_ or _mocked_ to significantly enhance, and
speed up both, finding and resolving bugs as well as making it
significantly easier to create comprehensive tests.

> Todo: maybe this would be a good time to layout some examples of
> clear boundary definitions, e.g. we defined API's.
