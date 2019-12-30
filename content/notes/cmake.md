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

CMake is a growingly popular method for generating Makefile files
depending on the _build_ computer being used.

#### Add an include directory -I.../include

```
include_directories(./include ../another/include)
```
