---
title: Skid Steering
description: >
  Skid Steering is probably the simplest form of steering a vehicle,
  both its mechanics and software are very simple and a great place to
  jump in and get our feet oily.
date: 2019-05-15
categories:
  - mechanics
  - software
tags:
  - steering
  - gnc
---

Skid steering basics

- Based on _fixed direction wheels[1] or tracks_
- There are two _groups_ or _sides_ of wheels: left and right
- All wheels in a group MUST always point in the same direction
- All wheels in a group MUST always rotate at the same rate
- Direction is determined by the speed of the two wheel groups
  - To move straight all motors rotate at the same rate
  - Forward and Reverse are determined by positive and negative values 
  - Turning is achieved by varying the throttle on the right and left 

### Example

The ```Skidder``` class has the following API, as you can see all of
the movements we desire can be accomplished with a single API call
```skidder.set_throttle(left_throttle, right_throttle)```, 
does not get much simpler than this!

```python
skidder = Skidder()

# Move forward at full speed
skidder.set_throttle(1, 1)

# Move in reverse at half throttle
skidder.set_throttle(-0.5, -0.5)

# Turn right arch at 60% 
skidder.set_throttle(.6, 0)

# Turn left on a dime (and fast) at 70%
skidder.set_throttle(-0.7, 0.7)

# Stop
skidder.set_throttle(0, 0)

# Coast 
skidder.set_throttle(None, None)
```

With this simple library we can control the most simple of Mobile
Robots (or maybe a forklift). 

### Note About Speed and Accuracy

This library is very simple, it only knows how to control the
***percentage of potential load*** the motors will be provided.  The
Adafruit library appropriate uses the term **throttle**, because we
can not know the **speed** of the motor without some form of
**external feedback**.

#### Can NOT Directly Control Speed!

Of course, the library does not know what motors are being used, how
they are geared (how the gear ratio's are set).  Even if we knew the
motors, we still do not know, directly the load being supplied which
will directly effect the rotation of the motors.

#### Nor Control Turn Radius

It follows to reason that the inability to control _speed_ directly
also means that we can NOT control the degree of our turns!  For
example a faster spinning motor will rotate a chasis more degrees than
a slower rotating motor.  This can be changed simply by the power
supply being used, including the charge if batteries are being used. 

### External Feedback Required

This is not such a big deal when the vehicle is controlled by a Human,
the humans makes control decisions in their brains and translate that
to DATA INPUTS, from a joystick or keyboard possibly.

#### Computer Controls Require External Feedback

For the reasons stated above, Skid steering requires external feedback
to be accurately used with computer automated controlers, like [otto's
magoo](http://github.com/mobilerobot-io/otto). 

The possibilities for external controls are many! Including distance
sensors, computer vision, radar, maps of many varieties, etc. The
choices are so vast that we would be remis to become too committed to
one or two technologies.

For that reason our [Raspberry Pi Device Controller
(rpid)](http://mobilerobot-io/rpid) project was created to allow for
external feedback of incoming _new state_ combined with existing state
measured against the _desired state_ creates a new objective that
will in turn be translated into a Control OUTPUT to the _skid_ channel
with a left and right throttles to effectively control the vehicle.


### Skid Steering Demonstrated

Here are some diagrams and a video demonstrating _skid steering_ in
real life:

> Todo create skid steer video

> Todo create skid steer diagrams

## Disclaimer ~ Semantics of the term Wheel

[1] Disclaimer ~ I will often use the term wheels in a very generic
sense, sometimes the use of wheels is specificly to wheels, sometimes
I will use it generically to include [tank tracks] or other types
of elements that rotate to move the vehicle.

As distinguished from _legs_ or other types of _mobility enablers_.

## References

