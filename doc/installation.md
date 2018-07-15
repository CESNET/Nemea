---
layout: page
title: Installation
menuentry: Installation
public: false
docmenu: true
permalink: /doc/installation/
---

# Installation of NEMEA

There are three different ways of installation of the NEMEA system covered
in this document: **vagrant**, **binary packages** and **source codes**.


## Vagrant

To try the system "out-of-box", you can use [Vagrant](https://www.vagrantup.com/).
For more information see [./vagrant/](./vagrant/).


## Binary packages

Latest RPM packages can be found in COPR: https://copr.fedorainfracloud.org/groups/g/CESNET/coprs/
The NEMEA repository is at https://copr.fedorainfracloud.org/coprs/g/CESNET/NEMEA/

After installation of COPR repository, NEMEA can be installed as any other package (run as root/sudo):

```
yum install nemea
```

Note: Latest systems (e.g. Fedora) use `dnf` instead of `yum`.


For development purposes, there is `nemea-framework-devel` package that installs
all needed development files and docs.

Currently, we do not have .deb packages (for Debian/Ubuntu/...) but we are working on it. Please follow installation from [source codes](#source-codes)

## Source codes

The whole system is based on GNU/Autotools build system that makes dependency checking and
building process much more easier.

To clone the NEMEA repositories, use:

```
git clone --recursive https://github.com/CESNET/nemea
```

After successful clone and [dependencies](#dependencies) installation (**!**), use:

```
./bootstrap.sh
```

that will create `configure` scripts and other needed files.

The `configure` script supplies various possibilities of
configuration and it uses some environmental variables that influence the build
and compilation process. For more information see:

```
./configure --help
```

We recommend to set paths according to the used operating system, e.g.:

```
./configure --enable-repobuild --prefix=/usr --bindir=/usr/bin/nemea --sysconfdir=/etc/nemea --libdir=/usr/lib64
```

After finishing `./configure`, build process can be started by:

```
make
```

The make(1) tool has various parameters, to build the NEMEA package faster on
multicore systems, we recommend to use parameter -j with the number of jobs
that should be run in parallel.

When the compilation process ends without any error, the package can be installed
into paths that were set by `configure`. It is recommended NOT to change
target paths by passing variables directly to make(1).
The installation can be done by (usually it requires root / sudo):

```
make install
```

Congratulations, the whole NEMEA system should be installed right now... :-)


# Dependencies

RHEL/CentOS/Fedora (CentOS7 is mainly supported):
```
yum install -y bc autoconf automake gcc gcc-c++ libtool libxml2-devel make pkg-config libpcap-devel libidn-devel bison flex
```

Note: Latest systems (e.g. Fedora) use `dnf` instead of `yum`.

Debian/Ubuntu:
```
apt-get install -y gawk bc autoconf automake gcc g++ libtool libxml2-dev make pkg-config libpcap-dev libidn11-dev bison flex
```

