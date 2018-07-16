---
layout: page
title: TRAP Interface Specifier
menuentry: TRAP IFC
public: false
docmenu: true
permalink: /trap-ifcspec/
---

Format of TRAP interface specifier (IFC_SPEC):
==============================================

TRAP interface specifier is an argument of `-i` option used by every NEMEA module. It specifies a configuration of module's TRAP interfaces (IFC), i.e. what kind of IFC to use and where to connect.

Configurations of individual IFCs are separated by comma `,`, e.g. `<IFC 1>,<IFC 2>,...,<IFC N>`. Input IFCs must be specified first, output IFCs follow. The number of input and output IFCs depends on the specific module (you should be able to find it in the module's help or README).

Parameters of each IFC are separated by colon `:`, e.g. `<type>:<par1>:<par2>:...:<parN>`. The first parameter is always one character specifying the type of the IFC to use, other parameters differ for individual types (see below).

Example of startup of a module with 1 input and 1 output IFC:
```
traffic_repeater -i t:example.org:1234,u:my_socket
```
The example makes the repeater to use a TCP socket as its input IFC and connect it to 'example.org', port 1234; and to create an UNIX domain socket identified as 'my_socket' as its output IFC.

Supported interface types:
==========================

TCP interface ('t')
-------------------

Communicates through a TCP socket. Output interface listens on a given port, input interface connects to it. There may be more than one input interfaces connected to one output interface, every input interface will get the same data.

Parameters when used as INPUT interface:

```
t:<hostname or ip>:<port>
```

or

```
t:<port>
```

If you skip `<hostname or ip>:`, IFC assumes you want to use localhost as the hostname.

Parameters when used as OUTPUT interface:

```
<port>:<max_num_of_clients>
```

Maximal number of connected clients (input interfaces) is optional (64 by default).

## TLS interface ('T')

Communicates through a TCP socket after establishing encrypted connection. You have to provide certificate, key and CA chain file with trusted CAs. Otherwise same as in TCP: Output interface listens on a given port, input interface connects to it. There may be more than one input interfaces connected to one output interface, every input interface will get the same data.

Parameters when used as INPUT interface:

```
T:<hostname or ip>:<port>:<keyfile>:<certfile>:<CAfile>
```

or

```
T:<port>:<keyfile>:<certfile>:<CAfile>
```

If you skip `<hostname or ip>:`, IFC assumes you want to use localhost as a hostname.

Parameters when used as OUTPUT interface:

```
<port>:<max_num_of_clients>:<keyfile>:<certfile>:<CAfile>
```

Maximal number of connected clients (input interfaces) is optional (64 by default).

Parameters keyfile, certfile, CAfile expect a path to apropriate files in PEM format.

UNIX domain socket ('u')
------------------------

Communicates through a UNIX socket. Output interface creates a socket and listens, input interface connects to it. There may be more than one input interfaces connected to one output interface, every input interface will get the same data.

Parameters when used as INPUT interface:

```
<socket_name>
```

Socket name can be any string usable as a file name.

Parameters when used as OUTPUT interface:

```
<socket_name>:<max_num_of_clients>
```

Socket name can be any string usable as a file name.
Maximal number of connected clients (input interfaces) is optional (64 by default).


Blackhole interface ('b')
-------------------------

Can be used as OUTPUT interface only. Does nothing, everything sent to this interface is dropped. It has no parameters.


File interface ('f')
--------------------

Input interface reads data from given files, output interface stores data to multiple files. Recommended file name extension for files with captured TRAP traffic is `.trapcap`. Tilde (`~`) can be used to specify home directory when specifying path, e.g. `~/nemea/data.trapcap`.

Input interface:

Files to be read by input interface can be specified with globbing.
E.g. lets say, we have multiple data files captured on 18th of April 2016, with names like data.201604180900, data.201604181000.
Following syntax can be used:

```
<file_name> 	// e.g. data.201604180900 - reads data only from file "data.201604180900"
<file_name*> 	// e.g. data.20160418* - reads data from all files in directory that were captured on 18th of April.
```

Name of file (path to the file) must be specified.
Input file interface can also read from /dev/stdin.

Output interface:

```
<file_name>:<mode>:<time=>:<size=>
```

Name of file (path to the file) must be specified.

Mode is optional. There are two types of mode: `a` - append (default), `w` - write.
If the specified file exists, mode write overwrites it, mode append creates a new file with an integer suffix, e.g. `data.trapcap.0` (or `data.trapcap.1` if the former exists, and so on, it simply finds the first unused number).

If parameter `time=` is set, the output interface will split captured data to individual files as often, as value of this parameter indicates.
Output interface assumes the value of parameter `time=` is in minutes.
If parameter `time=` is set, the output interface creates unique file name for each file according to current timestamp in format: filename.YYYYmmddHHMM
Parameter `time=` is optional and is not set by default.

If parameter `size=` is set, the output interface will split captured data to individual files after size of current file exceeds given threshold.
Output interface assumes the value of parameter `size=` is in MB.
If parameter `size=` is set, numeric suffix as added to original file name for each file in ascending order starting with 0.
Parameter `size=` is optional and is not set by default.

If both `time=` and `size=` are specified, the data are split primarily by time, and only if a file of one time interval exceeds the size limit, it is further splitted. The index of size-splitted file is appended after the time, e.g. `data.trapcap.201604181000.0`.

Example:

```
-i "f:~/nemea/data.trapcap:w"					// stores all captured data to one file (overwrites current file if it exists)
-i "f:~/nemea/data.trapcap:w:time=30"			// creates individual files each 30 minutes, e.g. "data.trapcap.201604180930", "data.trapcap.201604181000" etc.
-i "f:~/nemea/data.trapcap:w:size=100"			// creates file "data.trapcap" and when its size reaches 100 MB, a new file named "data.trapcap.0", then "data.trapcap.1" etc.
-i "f:~/nemea/data.trapcap:w:time=30:size=100"	// creates set of files "data.trapcap.201604180930", "data.trapcap.201604180930.0" etc. and after 30 minutes, "data.trapcap.201604181000"
```

Output file interface and negotiation:
Whenever new format of data is created, output interface creates new file with numeric suffix.
Example: `-i "f:~/nemea/data.trapcap:w"` following sequence of files will be created if data format changes: data.trapcap, data.trapcap.0, data.trapcap.1 etc.

When mode `a` is specified, the interface finds first non-existing file in which it writes data.

Example: 
Assume we have already files "data.trapcap" and "data.trapcap.0", the following command:

```
-i "f:~/nemea/data.trapcap:a"
```

checks for existing files and first captured data will be stored to file "data.trapcap.1".

Output file interface can also write data to /dev/stdout and /dev/null, however mode `w` must be specified.

## Common IFC parameters

The following parameters can be used with any type of IFC. There are parameters of libtrap IFC that are normally let default or set in source codes of a module. It is possible to override them by user via IFC_SPEC. The available parameters are:

* timeout - time in microseconds that an IFC can block waiting for message send / receive
   * possible values: number of microseconds or one of the special values:
     * "WAIT" - block indefinitely
     * "NO_WAIT" - don't block 
     * "HALF_WAIT" (output IFC only) - block only if some client (input IFC) is connected
   * default: WAIT
* buffer (OUTPUT only) - buffering of data and sending in larger bulks (increases throughput)
   * possible values: on, off
   * default: on
* autoflush - normally data are not sent until the buffer is full. When autoflush is enabled, even non-full buffers are sent every X microseconds.
   * possible values: off, number of microseconds
   * default: 500000 (0.5s)

Example:

```
-i u:inputsocket:timeout=WAIT,u:outputsocket:timeout=500000:buffer=off:autoflush=off
```


## More examples:

my_module with 1 input interface and 2 output interfaces:

```
./my_module -i "t:localhost:12345,b:,t:23456:5"
```

The input interface will connect to localhost:12345 (TCP). The first output interface is unused (all data send there will be dropped), the second output interface will provide data on TCP port 23456, to which another module can connect its input interface.

nfdump_reader module that reads nfdump file and drops records via Blackhole IFC type:

```
./modules/nfreader/nfdump_reader -i b: ./file.nfdump
```

