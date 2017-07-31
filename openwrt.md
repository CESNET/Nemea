---
layout: page
title: OpenWRT probe
menuentry: OpenWRT
public: true
permalink: /openwrt/
---

# NEMEA on OpenWRT -  system guide

## Description

This guide will show you how to compile, install and use NEMEA on OpenWrt system.


## Hardware requirements

Router with at least 32 MB RAM.


## Download

Clone the latest stable OpenWrt branch:

```
git clone https://git.openwrt.org/15.05/openwrt.git
```

Once cloned, change into OpenWrt build root directory:

```
cd openwrt
```

To include NEMEA into OpenWRT build, follow the [instructions](https://github.com/CESNET/Nemea-OpenWRT/blob/master/README.md) and install [NEMEA package feed](https://github.com/CESNET/Nemea-OpenWRT).


## Build configuration

Show OpenWRT configuration menu utility by running:

```
make menuconfig
``` 

and set the target system, target profile and also other options or packages to compile you want.

Once set, scroll down in main menu, find `NEMEA` entry and enter to it's configuration menu.

![]({{ "/doc/menuconfig-main-menu.png" | prepend: site.baseurl }} "Main menu")

There are 2 options how to get NEMEA into OpenWrt system:

- Compile and create `ipk` packages and install them later by `opkg` utility
- or compile and include NEMEA into OpenWrt firmware image file.

### Creating ipk packages

If you decided to create `ipk` packages, set the `nemea-framework` and `nemea-modules` option labels to `M`.

![]({{  "/doc/menuconfig-nemea-menu1.png" | prepend: site.baseurl }} "NEMEA configuration menu")

### Including NEMEA into image file

Otherwise set labels to `*`, NEMEA will be included in target firmware image file instead.

![]({{ "/doc/menuconfig-nemea-menu2.png" | prepend: site.baseurl }} "NEMEA configuration menu")

`NOTE`: Images can be configured in main menu under `Target Images` entry.

### Additional NEMEA configuration

If you enter into `nemea-framework` or `nemea-modules` menu, several variables for those packages can be configured. Defaults are recommended, so be careful when you set libtrap buffer size or flow cache size to higher values, otherwise modules might run out of memory.

## Compilation

When configuration is done you can finally compile OpenWrt using the following command:

```
make
```

This will take some time.

## Installing firmware image

If you created `ipk` packages, skip this section.

Image installation is not part of this guide, but you can follow official OpenWrt [guide](https://wiki.openwrt.org/doc/howto/generic.flashing).

## Installing ipk packages

Created packages are located in `bin/TARGET/packages/nemea/` directory, where `TARGET` is the target system you set in `Target system` configuration menu.

Assuming you already have installed OpenWrt system, copy NEMEA packages into your router using the following command:

```
scp bin/TARGET/packages/nemea/nemea-* root@<your_router_ip_address>:
```

Next log into your router:

```
ssh root@<your_router_ip_address>
```

and run:

```
opkg update
opkg install nemea-*
```

libtrap and NEMEA exporting modules are now installed.


## Using NEMEA modules

NEMEA modules are installed in `/usr/bin/nemea` directory. On router you can simply run:

```
/usr/bin/nemea/flow_meter -i t:12345 -I br-lan
```

which will start flow_meter module capturing packets from `br-lan` interface and listening on port `12345`.

If you have NEMEA installed on your computer, you can show exported flows from your router by running:

```
logger -i t:<your_router_ip_address>:12345 -t
```

or if your OpenWrt router uses big endian architecture, you will need to use special module:

```
endiverter -i t:<your_router_ip_address>:12345,u:my_socket &
logger -i u:my_socket -t
```

For help use:

```
/usr/bin/nemea/flow_meter -h
```

or [NEMEA readme](https://github.com/CESNET/Nemea/blob/master/README.md).


## USB Storage

At first, we need to install USB kernel module:

```
opkg update
opkg install kmod-usb-storage block-mount kmod-scsi-core kmod-fs-vfat kmod-fs-msdos kmod-nls-cp437 kmod-nls-iso8859-1 kmod-nls-utf8
```

Detect USB:

```
block info
block detect
```

Sample output:
```
config 'global'
	option	anon_swap	'0'
	option	anon_mount	'0'
	option	auto_swap	'1'
	option	auto_mount	'1'
	option	delay_root	'5'
	option	check_fs	'0'

config 'mount'
	option	target	'/mnt/sda1'
	option	uuid	'3dda-eb19'
	option	enabled	'0'
```

If we haven't changed `/etc/config/fstab` yet, we can update its content simply by:

```
block detect > /etc/config/fstab
```

but remember to remove the `option enabled '0'` line which disables our mountpoint.

Now using:

```
block umount; block mount
```

we should have working mounted USB drive.


## Running flow_meter using init script

To start `flow_meter`, you need to prepare its configuration in `/etc/config/flow_meter`.

Sample configuration:

```
config params
	option plugins basic,sip,http
	option ifcspec f:/data/base.trapcap:w:time=5,f:/data/sip:w:time=5,f:/data/http:w:time=5
	option network br-lan
```

Having configuration file, it is possible to start service:

```
/etc/init.d/flow_meter start
```

If we need to start `flow_meter` on startup, just enable it:

```
/etc/init.d/flow_meter enable
```

## Tested versions and devices

Tested on OpenWrt Chaos Calmer 15.05.1:

- `TP-Link Archer C7 v2`
- `TP-Link TL-WR1043ND v1`

and turris-os:

- `Turris Omnia`

