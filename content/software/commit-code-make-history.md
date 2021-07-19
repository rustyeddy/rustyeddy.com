---
title: Commit Code and Make History
date: 2021-04-04
weight: 80
description: >
  Once your developer has taken her code through the demanding process
  of testing and peer reviews, it is time to make that code available
  to your users... 
---

## Github and making the Commitment

Now it is time for the developer to _commit_ the changes she has been
working on, tested and pushed through the peer reviews. This step is
pretty simple, however, we want to make sure we are doing it
correctly.

> Todo example commit

When the code is merged into the **main** or **master** repository,
just like commitments, it will be accompanied by the log comments
that go along with the log files.

Additionally, every _commit_ will have a _unique identifier_, a big
nasty looking hex-i-decimal string guaranteed to most likely be locally
unique. 

### History in the Making

Well written comments, source diffs and a unique identifier come
together to create a specific moment in the code life history.

Stringing all commitments together, one forms a very accurate history
of the source development. If the comments are well written, that
history is accompanied by a wonderful narrative told by the developers
as the software is being written. 

## The Beginning of Visibility

This can provide the viewer with literally a line by line replay of
the entire history of a software development project. The commitments
can also be directly related to the particular **github issues** that
have spurred the updates to the code in the first place.

This is a very powerful way for not only developers, but also users,
management and marketing a deep insight into the process of software
development. 

## Tagging - Releases

Git also provides a feature called _tagging_, which is in fact very
similar to _branching_. _Tags_ however are meant to _label_ a specific
reference of the source at a specific point in time.

_Software releases_ are a good reason to use _tags_. For example: a
tag **v1.0.2** would be a typical tag that might be used to reference
the version of code after **v1.0.1**.

This practice allows the team, or anybody interested, the ability to
_reference_ and _re-create_ a specific past version of the software.

## Automated Builds and Testing

Github provides a ton of goodies with it's well defined _API_ and the
plethora of _web-hooks_ it provides.

In the next section we'll get into _automatically_ building new images
upon every committment, running the images through automated tests and
finally sending **only** the tested images to a file server for
general access. 

