---
title: Using CMake
date: 2017-04-21
description: >
  CMake is an indespensible way to create build files for a C (and
  other) projects. 
category: programming
tags: [ make, cmake, c, c++ ]
reference: https://cmake.org/cmake/help/latest/guide/tutorial/index.html
draft: true
---

The Unix build tool is a _declarative dependency tracking build tool_.
Make was born in 1976, and is still how most C and C++ programs and
libraries are built today, including the Linux operating system and
GNU Compilers and half of all the worlds systems software.

## So Many Makes, So Little Time

In that time, especially during the early years of commercial
fragmentation and little benefit from Open Source software, the _make_
tool and corresponding Makefile become splintered in implementation
details. For example each of BSD and AT&T Unixen had a flavor, the
Free Software Foundation had it's GNUMake, all of which still live
today!

### One Make to Unite Them All

Any attempt at unifying makefiles is basically hopeless, I forgot to
mention the world of Windows and embedded systems have billions of
lines of code depended some variation of _make_ or another.

> A single standard Makefile, not possible. We need another solution.

A standard Makefile, with any level of sophistication will not be
happening anytime soon, so the makers of CMake!  According to
Wikipedia: 

> CMake development began in 1999 in response to the need for a
> cross-platform build environment for the Insight Segmentation and
> Registration Toolkit. The project is funded by the United States
> National Library of Medicine as part of the Visible Human Project. 

Kudo's to the (_National Library of Medicine_)[https://www.nlm.nih.gov/] and 
the early creators of CMake. The took a bit of a different approach.

You basically define how you want to software built, you specify your
desires in CMakeLists.txt which gets generated in a _Makefile_, the
flavor of the Makefile is based on the build system of the host
Operating System.

> CMakeLists.txt has an approach akin to "When in Rome do as the Romans"

Now you have Makefiles generated that are tuned specifically to the
host operating system.

Here is an example _cmake_ command you would used to add the compiler
option  ```-I.../include``` at compile time.

```
include_directories(./include ../another/include)
```

> Goto my CMakefile cheet sheet !
