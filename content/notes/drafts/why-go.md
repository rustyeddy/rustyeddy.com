---
title: Why Go?
description: >
  Some pragmatic reasons to choose Go as the programming language for your software
  project
draft: true
date: 2020-01-28
---
  
The reasons I like Go so much will be documented as we progress
through this document.

I won't get into various reasons why Go is _better_ or _worse_ than
another programming languages for the _IoT Project_. Under the
direction of a competent developer this project could have been
written successfully any modern "well known" language including but
not limited to: C++, Rust, Python, Node/JS, Java and it's machine code
variants, and so on.

## Static Types

Go is a _compiled_ and _static typed_ _compiled_ language vs. an
_interpreted_ _loose typed_ language that basically means if you make
mistakes with your variable types, Go (just like C/C++) will get mad
at you at _compile time_.

An angry _interpreted_ language (e.g. python, ruby, javascript and
php) fails at _run time_. 

That is basically the difference between somebody telling you are
going to _fuck up_ before going on stage vs. telling you that _you
fucked up_ after the fact at a during a live performance.

## Executable Binaries

Go can be distributed as a single file _program_ or _executable
binary_.

## Simple But Powerful Builtins

My favorite Go packages that are built right in to the core
distribution are, in no particular order:

- testing
- encoding/json
- fmt & logs
- net/http

## Concurrency

