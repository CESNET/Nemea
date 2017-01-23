---
layout: page
title: Hands-on workshop at TF-CSIRT 2017
public: false
permalink: /tfcsirt2017/
---

# Tools for Monitoring and Security Analysis

We are having a hands-on tutorial at 50th TF-CSIRT meeting:

[https://www.first.org/events/symposium/valencia2017](https://www.first.org/events/symposium/valencia2017)

on Wednesday Jan 25th from 9:30 to 17:00.

[Register now!](https://app.certain.com/profile/form/index.cfm?PKformID=0x2487766434e)

## Description

The hands-on workshop shows basics of flow-based network monitoring (NetFlow, IPFIX) and processing the flow data. The course is focused on security analysis and on processing flow data extended by L7 information.

The attendees will learn:

* basics of **flow monitoring** (what is flow, exporter, collector, ...),
* to work with flow data extended by application layer (L7) information,
* to **store flow data** using IPFIXcol collector,
* to **query stored data** - filtering and aggregation,
* to **analyze data** in near real-time both automatically and by ad-hoc filters using NEMEA framework,
* to **detect** various kinds of malicious traffic, both by manual analysis of stored data and by setting up an automatic processing pipeline,
* to **handle** detected security events and visualize them using NEMEA Dashboard.

There is a **virtual machine** (VM) prepared (see below) for participants so the only requirement is an installed  VirtualBox or VMware tool. VM is based on a GNU/Linux distribution CentOS 7 and contains everything already installed and configured. VM is ready and suitable for experiments and testing so that it can be used to practice skills learnt at the workshop and after it as well.

Besides configuration files and scripts, VM contains selected **anonymized traffic traces** from a real network. These data sets will be used for explanation of detected threats and presentation of usage of the selected tools.

We will also present a flow exporter created from a commodity home router equipped with **OpenWrt system** and NEMEA `flow_meter`. Using this device, it is possible to cheaply collect data for statistics and security analysis in small networks.

The following screenshots capture several moments from the course.

![]({{  "./system-control.png" | prepend: site.baseurl }} "NEMEA supervisor")
![]({{  "./dashboard.png" | prepend: site.baseurl }} "NEMEA Dashboard")
![]({{  "./scgui-graph.png" | prepend: site.baseurl }} "SecurityCloud GUI")
![]({{  "./scgui-query.png" | prepend: site.baseurl }} "SecurityCloud GUI - querying")


# Files for download


* VM image is available at [github release](https://github.com/CESNET/Nemea/releases/download/v2.3.2/tfcsirt-2017-vm.tar).
* [ScreenCast]({{"./how-to-import-vm.webm" | prepend: site.baseurl}}) about importing VM into VirtualBox.
* Data traces are included in the VM
* Latest presentation will be available soon.





