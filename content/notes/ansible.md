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

- Create Playbooks that defines the configuration of a target
  architecture. 
  
- **Ansible is _Idempotent_** meaning it defines the the desired
  outcome, it is up to Ansible to make that outcome real.
  
- It can be run numerous times with very predictable results.

- It is free but comes with the Ansible Tower (RedHat) premium add
  on. 
  
## Getting Started

The first and most important thing when getting started with Ansibel
is placing keys on all hosts to be managed.
