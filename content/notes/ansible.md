---
title: Ansible
date: 2017-04-03
description: > 
  Ansible is an ideal tool to efficiently configure and manage a
  network of computers.  See how I use ansible to manage a fleet of
  Raspberry PIs and their build servers.
category: devops
tags:
  - raspberry-pi
  - rpi
  - ansible
reference: https://ansible.org
draft: true
---

Ansible is a very powerful yet simple, in all its complexity. It is a
wonderful tool that I get frequent use of.  It's real home I suppose
is in the larger corporation _devops_ world, it is wonderfully well
suited to a mid sized IoT environment.

## A Few Highlight about Ansible

### Scripts are Accurate and Repeatable

Create Playbooks that combine a series of specific roles to get define
specific _roles_ the configuration steps to get a desired
outcome. Once you figure out how to get something installed correctly,
just script it out.

If and when things change and the script breaks, fix it, simple.

> We have just ensured we can repeat the same successful installation
> over and over again, in record breaking time!
  
### Processes Get Documented

By virtue of creating accurate names and descriptions of the tasks
required for ansible, it will provide some great documentation of the
actions performed by the varies roles.

## How Ansible Works

Ansible runs _playbooks_ from any host you care to run it from: we'll
call it the: _"ansible host"_. The _ansible host_ can then over see
the configuration management of any number of _target hosts_, we'll
call them _"targets"_.

At any given time _ansible_ can be used to launch a single command or
more typically a playbook that will invoke a series of actions to
ensure all _targets_ are configured and operating in the state
specified by a series of _roles_ that make up the ansible playbook. 

Ansible playbooks can (and often are) run from: a laptop by a
developer during test builds, or large enterprise servers that
entrusted with maintainnig order and consistency in large complex
enterprise arrangements.

Heck, Ansible can even be run from a _Raspberry Pi_! I think it
provides some really powerful, and useful solutions to IoT problems. 

## Getting Started with Ansible

Running _ansible_ at all requires the _ansible host_ to be able to
remotely login and control the _targets_. This must be established
before ansible can do anything else.

> Prepare your ansible targets with public ssh keys!

The key to getting started with ansible is to prepare all target hosts
with the appropriate public SSH key(s) providing the _ansible host_
with controlling access. This is the best, easiest and recommended way
to get started.

### Preload Targets with Keys

For physical servers (bare metal) this may require some manual
preparation to load each _target_ with the appropriate ssh key. May
seem like a pain, but it is really trivial compared to the amount of
work you will save allowing ansible to do the work.

> Ansible provides other ways to access and control the targets, but
> when possible ssh keys are the best way to go.

In cases of _Virtual Machines (VM)_ and _Containers (containers)_ the
necessary public keys maybe (depending on the virtual provider)
preloaded when the new VM or container is _spun up or
provisioned_. This is ideal, allowing us to create 100% __zero touch__
provisioning! 

anyway, back to ansible...

## Using Ansible to Setup Devops

Setting up a _personal development_ host can be tedious, depending on
the particular tools you use. In my particular case, most of my
development is done on Linux, for either Linux or some embedded system
and I use _emacs_.

> yes, I use the greatest editor that has ever lived, and still lives!

Installing emacs is pretty trivial if you are content with your
operating systems package manager. For example, I often use ubuntu
(ubuntu19) at the time of this writing.

The package manage (apt) installs emacs-25, bummer. Often times, I am
more than happy to go with day old tools and such (if they worked
before, they should still work just fine), however, emacs in this case
is a whole version behind.

> raspbian installs emacs25, I want emacs26

Now, I could go through the trouble of setting up the package manager
to update the latest version, but in my case, I think I will just
build and install it from src.

I want to build this for my new Raspberry Pi 4(!). I am doing some
development for the Raspberry PI, and I find the Pi4 compiles **much
faster** than the older pis.

And emacs is plenty spry enough to happily run on the rpi4.

However, building emacs does require quite a bit of supporting
libraries if you want to build it with _windowing support_, which I
do. 

> you can actually build emacs to run as a pure terminal application..

The above is a really cool option in some cases, however I want to add
GTK-3 support because I will be X-ing into the (often headless) RPI4.

> after some failed ./configure attempts and subsequent apt-get
> installs ..

I finally got the complete series of steps down to successfully build
emacs-26 for the latest version of raspberry pi. If you follow the
steps in order it is pretty easy to do, you just have to wait a
while. 

### Emacs Compilation (Raspberry Pi) in Ansible

I decided to encode the series of steps to compile and install emacs
with an ansible-playbook. It works on Raspberry pi, I have not tried
ubuntu or another form of debian, but I expect that will work also.

> Here is the gist for my ansible install and build emacs


### Running the Playbook

> Todo insert instructions to run playbook here.

