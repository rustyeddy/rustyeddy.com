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

