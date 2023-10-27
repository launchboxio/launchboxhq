---
sidebar_position: 1
---

# Introduction

We've all been there. You start your first day at a new job, and get a handed a 1000 line README on standing up
the dev stack. First Vagrant or Virtualbox versions don't match, so you update a few of those. Then the scripts for
provisioning it aren't up to date, and fail. Afterwards, you want to pull in a co-worker to help troubleshoot, so you
copy / paste commands and outputs back and forth. Finally, after several hours of fighting it, your dev environment is
setup. Then your Mac complains about CPU or disk usage, and slows down or crashes. Before you know it, the day's over,
and you're batting 0.000 for productivity.

Launchbox aims to solve common issues for distributed teams working on Kubernetes native applications. You can
quickly create ephemeral or long lived Kubernetes clusters, automatically install addons / services that are needed
for your system, and then get to solving problems. No more flaky Vagrant stacks, running out of resources on your
workstation, or juggling ngrok tunnels to share with your teammates. Cloud native development, as it should be.

## How it works

Under the hood, we use [vcluster](https://www.vcluster.com/) to generate unique clusters on top of a host cluster. This
provides a 100% compliant Kubernetes environment for development. Launchbox also manages several functionalities on top
of that:
 - Scheduled pause / resume of development and testing environments
 - Support for AWS IRSA, Google Workload Identity, and others
 - Sharing access to other teammates for pair progamming and collaboration
 - Automation of service catalog deployment
 - Notifications when new service versions are available, and 1-click updates

## Cloud support
