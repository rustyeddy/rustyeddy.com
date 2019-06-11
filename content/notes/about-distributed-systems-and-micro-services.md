---
title: About MicroServices and Distributed Systems
date: 2018-02-11
description: > 
  I am very much in favor of micro-service style architectures with
  builds service pipelines based on lean and efficient software
  components, rather than obese frameworks trying to be something they
  are not.  Here is what I mean:
---

I am very much dedicated to building distributed, micro-service style
systems. I prefer to piece solutions together based on lean,
efficient, best of breed components.  

## More Complex?

Many rightly claim that a distributed system increases the complexity
over the monolith, and it is true that communicaiton boundaries must
be explicitly created, and that communications between the boundarys
becomes a potential for failure, or reduced reliability that tightly
couple systems do not have to deal with.

This is true.  However, if done with care and an eye toward simplicity
and robustness, a team can start developing patterns that are mandated
according to the driving force of the application they are developing.

### Clearify and Simplify Interfaces Early

In otherwords, distributed systems force an explicit definition
between APIs of subsystems.  That easily translates into communication
busses that can be _snooped_ or _mocked_ to significantly enhance, and
speed up both, finding and resolving bugs as well as making it
significantly easier to create comprehensive tests.
