---
title: Get Ready to Go
description: >
  This quick cheatsheet will get you ready to start working on a go
  project like the IoT project.
date: 2020-04-01
draft: true
---


## Get Ready To _Go_

The IoT Gateway was written in the _Go_ programming language. I won't
get into the reasons why _Go_ is an excellent choice of programming
language for this project other than to point out two advantages this
project will benefit from right away:

### Go is Compiled and easy to distribute

First, Go is a _compiled_ language making the resulting executable
self contained with no external libraries or run time environment to
rebuild, just copy a single binary, that is it.

Unlike Node/JS, Python and other interpreted languages the entire run
time environment must be replicated or recreated everywhere the
program is to be run. With Go a single _binary_ can be transferred
and run with out any additional installation steps, build process or
external dependencies. 

### Go executable are small and fast

A second wonderful advantage Go produces very small and fast programs
that works well on some of the _micro-controllers_ we are going to be
working on such as the _Raspberry Pi_.

As the project moves forward we will discuss a number of other
interesting aspects of the language that we will be taking advantage
of as the needs of the project arise.

### Install The Go Compiler

Go is very easy to setup. Either follow directions on the 
[Go Website](https://golang.org) or if your on Ubuntu you can just run 
the command:

```bash
snap install go --classic
```

Make sure you have go installed by running:

```bash
% go version
go version go1.17.8 linux/amd64
```

## The Main Function 

Let's build a simple ```Hello, world!``` program to make sure our set
up is ready and that we can actually write, compile and run a Go
program. Go is built around packages, every executable must have a
```package main``` and ```main()``` function (similar to C), like
so: 

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, world!")
}
```

Now run the little program to make sure everything is working as
expected:

```sh
% go mod init github.com/iot-project/iothub
% go mod tidy
% go run .
Hello, World!
```

If all goes well (and why would it not?) we'll see ```Hello,
World!``` printed on our screen. Fantastic! 

