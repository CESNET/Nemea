---
layout: page
title: Documentation
menuentry: Docs
public: true
permalink: /doc/
---

Related pages: [TRAP IFCSPEC](/trap-ifcspec/), [Reporters](/reporting/)

This page is written from the high-level view by system users to the low-level
API needed by developers of the NEMEA Modules/Detectors and by developers of
the libraries contained in the NEMEA Framework

## Usage by User

The recommended installation of the NEMEA system is done as a part of [STaaS collector](https://github.com/CESNET/STaaS), where Ansible is used.
The installation is described in the [separate page](/doc/installation).

A default path of the installed modules is in `/usr/bin/nemea/`.
Users can read documentation of the modules in `/usr/share/doc/nemea-modules/`
or `/usr/share/doc/nemea-detectors/`.

Each module has `-h` parameters to print the module's help.  The header of the help
shows number of communication interfaces (IFC).  All IFCs are configured at the startup
of a module using `-i` parameter with an argument.
The `-i` parameter is also described in the module's help in a separate section: `-h 1` or `-h trap`.
It is also described at [TRAP IFCSPEC](/trap-ifcspec/) page.

**Example of help header of a module**

```
$ /usr/bin/nemea/vportscan_detector -h
TRAP module, libtrap version: 0.11.2
===========================================
Name: vportscan_detector
Inputs: 1
Outputs: 1
Description:
  Vportscan detector is a simple, threshold-based detector for vertical scans
  detection. The detection algorithm uses information from basic flow records
  (source and destination IP addresses and ports, protocol, #packets, #bytes).

...
```

This output says that `vportscan_detector` has 1 input IFC and 1 output IFC.

**Example of a command to start the module**

```
/usr/bin/nemea/vportscan_detector -i u:flow_data_source,u:vportscan_out
```

This command starts `vportscan_detector`. The input IFC is set to `u` type (UNIX socket)
and `flow_data_source` is and identifier of the IFC.
Comma is a separater of IFCs, so that the second IFC is also of `u` type and the identifier
is `vportscan_out`.

Note: any input IFC can be connected to one output IFC, this can be done by specifying the
same IFC type and identifier.

Note2: See [TRAP IFCSPEC](/trap-ifcspec) for more detailed information about IFC configuration
and types.


## Usage by Programmer

This section covers documentation of the [NEMEA Framework](https://github.com/CESNET/Nemea-Framework),
which is the main part of the NEMEA System shared within all NEMEA Modules and Detectors.
It consists of (GitHub links):

* **libtrap:**    [https://github.com/CESNET/Nemea-Framework/tree/master/libtrap](https://github.com/CESNET/Nemea-Framework/tree/master/libtrap)
* **UniRec:**     [https://github.com/CESNET/Nemea-Framework/tree/master/unirec](https://github.com/CESNET/Nemea-Framework/tree/master/unirec)
* **nemea-common:**     [https://github.com/CESNET/Nemea-Framework/tree/master/common](https://github.com/CESNET/Nemea-Framework/tree/master/common)
* **pytrap:**     [https://github.com/CESNET/Nemea-Framework/tree/master/pytrap](https://github.com/CESNET/Nemea-Framework/tree/master/pytrap)
* **pycommon:**      [https://github.com/CESNET/Nemea-Framework/tree/master/pycommon](https://github.com/CESNET/Nemea-Framework/tree/master/pycommon)

These components are described in the following subsections.

### libtrap

**Description**

`libtrap` is a library (shared object) written in C.
The aim of `libtrap` is to provide implementation of various types of communication interfaces (IFC)
that can be used by modules to send or receive data messages.
A developer may choose a number of output and input IFCs.

Configuration of IFCs is given by a user (not by a developer) when a module is being started.
From the developer'đ point of view, it does not matter what type of IFC is used or what parameters
are used.

A developer of a module must take care of initialization and finalization of the libtrap context,
however, it can be copied from an existing examples.
Basically, there are two main functions of libtrap that are used by repeatedly used by a developer:
`trap_send()` to send a message via an output IFC and `trap_recv()` to receive a message via an input
IFC.

**Doxygen**

[Public API for module developers](./libtrap/)

[Internal API for developers of libtrap](./libtrap-devel/)

### UniRec

**Description**

UniRec is a definition of binary data representation (format) and an implementation
of functions to work with it.
To understand UniRec, we have to split two terms: `template` and `message`.
A template is a definition of fields that are present in every message.
A field is defined by name and type.

There is a list of currently used UniRec fields: [unirec_fields.md](https://github.com/CESNET/Nemea/blob/master/unirec_fields.md).
Developers can easily define any field.

| UniRec Field Type | CPP Constant | C Type | Size in Bytes |
| --------- | -------------- | ---------- | --:|
| char      | UR_TYPE_CHAR   | char       |  1 |
| uint8     | UR_TYPE_UINT8  | uint8_t    |  1 |
| int8      | UR_TYPE_INT8   | int8_t     |  1 |
| uint16    | UR_TYPE_UINT16 | uint16_t   |  2 |
| int16     | UR_TYPE_INT16  | int16_t    |  2 |
| uint32    | UR_TYPE_UINT32 | uint32_t   |  4 |
| int32     | UR_TYPE_INT32  | int32_t    |  4 |
| uint64    | UR_TYPE_UINT64 | uint64_t   |  8 |
| int64     | UR_TYPE_INT64  | int64_t    |  8 |
| float     | UR_TYPE_FLOAT  | float      |  4 |
| double    | UR_TYPE_DOUBLE | double     |  8 |
| ipaddr    | UR_TYPE_IP     | ip_addr_t  | 16 |
| macaddr   | UR_TYPE_MAC    | mac_addr_t |  6 |
| time      | UR_TYPE_TIME   | ur_time_t  |  8 |
| string    | UR_TYPE_STRING | char       | -1 (variable size) |
| bytes     | UR_TYPE_BYTES  | char       | -1 (variable size) |


**Doxygen**

[Generated documentation of API for module developers](/doc/unirec/)

### nemea-common

**Description**

`nemea-common` is a collection of various functions and data structures
that are generally useful in modules.  There are e.g. prefix tree, B+ tree,
hashing functions, hash table, ...

**Doxygen**

[Generated documentation of API for module developers](/doc/nemea-common/)

### pytrap

**Description**

`pytrap` is a native module for Python 2 and 3 that wraps API of `libtrap` and `UniRec`.
It allows writing new NEMEA modules in the Python language.

Examples can be found at [https://github.com/CESNET/Nemea-Framework/tree/master/examples/python](https://github.com/CESNET/Nemea-Framework/tree/master/examples/python)

**Docs**

[Generated documentation of Python API for module developers](/doc/pytrap/)

### pycommon

**Description**

The main part of `pycommon` is a python module `report2idea` for reporting
alerts generated by NEMEA detectors.

There is currently no development documentation for this module.

For user documentation of the configuration of reporter modules see [Reporting Modules and Alert Filtering](/reporting/).

### Prepared Examples

**C**

* [https://github.com/CESNET/Nemea-Framework/tree/master/examples/c](https://github.com/CESNET/Nemea-Framework/tree/master/examples/c)

**Python**

* [https://github.com/CESNET/Nemea-Framework/tree/master/examples/python](https://github.com/CESNET/Nemea-Framework/tree/master/examples/python)

