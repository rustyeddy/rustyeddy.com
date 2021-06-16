---
title: Mainlining Your Vetted Code
date: 2021-04-04
weight: 80
description: >
  Once the sometimes ardjous process of being confronted with a
  problem to solve, coding it up, debugging, passing all tests and
  then getting hammered by a peer. Wow, finally it becomes available
  to everybody.
---

## Github making the Commitment

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

Git also provides a feature called _tagging_, it is in fact very
similar to _branching_, except they are meant to _label_ a specific
reference of the source at a specific point in time.

Software release is a typical example: a tag **v1.0.2** which would
not be unusual.

This allow the team to _reference_ and _re-create_ that specific
version of the code again. 

## Automated Builds and Testing

Github provides a ton of goodies with it's well defined _API_ and the
plethora of _web-hooks_ it provides.

In the next section we'll get into _automatically_ building new images
upon every committment, running the images through automated tests and
finally sending **only** the tested images to a file server for
general access. 

