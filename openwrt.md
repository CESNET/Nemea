---
layout: page
title: Deployment of NEMEA with OpenWRT probe
public: true
permalink: /openwrt/
---

# OpenWRT Probe


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




