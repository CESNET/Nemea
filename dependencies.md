# Building environment

* autoconf
* automake
* gcc
* gcc-c++
* libtool
* libxml2-devel
* libxml2-utils (contains xmllint on Debian)
* make
* pkg-config

## Optional dependencies of modules and detectors

* rpm-build (build of RPM packages)
* libpcap (flow_meter)
* libnfdump (http://sourceforge.net/projects/libnfdump/) or libnf (https://github.com/VUTBR/nf-tools/tree/master/libnf/c) (nfreader)
* libidn (blacklistfilter)
* bison and flex (unirecfilter)

## How to install everything:

```
dnf install -y autoconf automake gcc gcc-c++ libtool libxml2-devel make pkg-config libpcap libidn bison flex
```

On older systems use `yum` instead of `dnf`.

On Debian-based systems:

```
apt-get update;
apt-get install TODO
```
