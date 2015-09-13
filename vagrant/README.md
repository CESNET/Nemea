How to install the Nemea system using Vagrant
=============================================

This document describes how to install virtual machine with the Nemea system using Vagrant.
The goal is to simplify the installation setup and get started with using the Nemea system.

Requirements
------------

The guide assumes that Virtualbox and Vagrant are installed in your machine.
You can download these software here:

- Virtualbox: https://www.virtualbox.org/wiki/Downloads
- Vagrant: http://www.vagrantup.com/downloads

Vagrant preparation
====================

This directory contains Vagrantfile configuration files that can be used.
Choose what system you want to use:

Fedora 22 Cloud
---------------

For installation of Fedora 22 Cloud, rename `Vagrantfile.Fedora22` to `Vagrantfile`
and use the following command to get Vagrant box:

```
vagrant box add fedora22 https://download.fedoraproject.org/pub/fedora/linux/releases/22/Cloud/x86_64/Images/Fedora-Cloud-Base-Vagrant-22-20150521.x86_64.vagrant-virtualbox.box
```

Scientific Linux
----------------


For installation of Scientific Linux, rename `Vagrantfile.SL6` to `Vagrantfile`
and use the following command to get Vagrant box:

```
vagrant box add --insecure cesnet/nemea-2-1-0 https://sauvignon.liberouter.org/nemea-2-1-0.box
```

Installation - Final Step
=========================

Start the VM Installation using (this will take few minutes):
```
vagrant up
```

Once the installation is complete, SSH into the VM:
```
vagrant ssh
```

Troubleshooting
===============

Note: For more information about network configuration, refer to
http://docs.vagrantup.com/v2/networking/public_network.html

