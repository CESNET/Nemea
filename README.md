NEMEA System
============

Travis CI build: [![Build Status](https://travis-ci.org/CESNET/Nemea.svg?branch=master)](https://travis-ci.org/CESNET/Nemea)

This file describes the Nemea system in detail. To see more general information,
please have a look at https://www.liberouter.org/nemea or the CESNET
technical report 6/2013: V. Bartos, M. Zadnik, T. Cejka: "[Nemea: Framework for stream-wise analysis of network traffic](http://www.cesnet.cz/wp-content/uploads/2014/02/trapnemea.pdf)".

Installation
============

TODO: Vagrant installation

The Nemea system consists of the [Nemea framework](cejkato2/Nemea-Framework), Nemea modules (basic and detection) and Nemea Supervisor. The whole system
is based on GNU/Autotools build system that makes dependency checking and
building process much more easier.

To clone the read-only repositories, use:

```
git clone --recursive https://github.com/CESNET/nemea
```

Libraries from the Nemea framework can be compiled without any special
dependencies.

The first step in compilation from the Nemea distribution package is the
execution of `configure` script. The script supplies various possibilities of
configuration and uses some environmental variables that influence the build
and compilation process. The list of supported settings with the description
of environmental variables are available by the help of configure script, see:
```
./configure --help
```

The configure script allows users to set target paths for installation of
the results of the build process. The important parameters for changing paths are:
  ```--prefix```, ```--libdir```, ```--bindir```, ```--docdir```, ```--sysconfigdir```

The configure script enables silent mode of make(1) by default. To disable this
feature, please pass the parameter: ```--disable-silent-rules```

After successful run of the configure script, package should be ready for
compilation. The compilation can be started by:

```
make
```

The make(1) tool has various parameters, to build the Nemea package faster on
multicore systems, we recommend to use parameter -j with the number of jobs
that should be run in parallel.

When compilation ends without any error, the package can be installed into paths
that were set during configuration. It is recommended NOT to change target paths
by passing variables to make(1).
The installation can be done by (usually it requires root / sudo):

```
make install
```

Congratulations, the whole Nemea system should be installed right now... :-)

Quick Start Guide
=================

TODO: add logreplay and logger, since nfreader requires additional
dependency.

This section shows how to manually start Nemea modules. Module description and
specific parameters could be shown by running module with parameter "-h":
```
nfdump_reader -h
```

There are two possible data inputs for Nemea modules:
  a) from nfdump file (static data)
  b) from [IPFIXcol](https://github.com/CESNET/ipfixcol/) with UniRec plugin
     (real-time data).
	
a) Data from nfdump files could be read and sent to Nemea by "nfdump_reader"
module. Following command will send records from file "nfcapd.201406001" to TCP
interface on port 9988 in UniRec format:
```
nfdump_reader -i t:9988 /data/nfcapd.201406001
```

Another module then could capture and process this data, e.g. DNS amplification
detector:
```
dns_amplification -i t:localhost:9988,u:DNS_amp
```
  
After executing both commands, DNS amplification detection on data from given
file will be done. Possible attacks will be reported on Unix socket "DNS_amp".

b) Real-time data from IPFIXcol could be provided to Nemea also. First run
IPFIXcol, e.g.:
```
ipfixcol -d -c /data/configs/startup.xml
```

File "startup.xml" should contains configuration for IPFIXcol plugin, among
others there will be settings for output UniRec format and output interface.
Example of such configuration file for UniRec plugin is at the end of this
section. Command for running Nemea module with input from IPFIXcol (e.g. on TCP
port 9966) remains same as with input from "nfdump_reader":
```
dns_amplification -i t:localhost:9966,u:RT_DNS_amp
```
  
Another examples of starting Nemea modules follows:
ex1) This example starts two ```nfdump_readers``` on two different files. Records
from both files are then merged into one stream and sent on TCP interface,
port 9920:
```
nfdump_reader -i "t:9911" /data/link1/nfcapd.201406001
nfdump_reader -i "t:9912" /data/link2/nfcapd.201406001
merger -i t:localhost:9911,t:localhost:9912,t:9920 -n 2
```

ex2) This more complex example start one "nfdump_reader" on multiple files. All
files are read sequentially and sent on output interface. Data from
"nfdump_reader" are then anonymized and sent to "hoststatsnemea" detector and
to "flowcounter". Reports from detector are then stored to CSV file via
"logger":
```
nfdump_reader -i "u:HS_src" /data/0601/nfcapd.0000 /data/0601/nfcapd.0005
    /data/0601/nfcapd.0010 /data/0601/nfcapd.0015
  anonymizer -i u:localhost:HS_src,u:HS_an -k 0AnonymizationKeyWithLengthof32B
  flowcounter -i u:localhost:HS_an -p 100000
  hoststatsnemea -i u:HS_an,u:HS_report -F
  logger -i "u:HS_report"
```
    
note: In hoststatsnemea configuration file should be "port-flowdir = 1".

Example of configuration file for UniRec plugin for IPFIXcol:

TODO: update if needed

```
<?xml version="1.0" encoding="UTF-8"?>
<ipfix xmlns="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp">

  <collectingProcess>
    <name>UDP collector</name>
    <udpCollector>
      <name>Listening port 4740</name>
      <localPort>4740</localPort>
      <localIPAddress></localIPAddress>
    </udpCollector>
    <exportingProcess>UniRec output</exportingProcess>
  </collectingProcess>

  <exportingProcess>
    <name>UniRec output</name>
    <destination>
      <name>Make unirec from the flow data</name>
      <fileWriter>
        <fileFormat>unirec</fileFormat>
        <!-- Default interface -->
        <interface>
          <type>t</type>
          <params>9966,16</params>
          <ifcTimeout>0</ifcTimeout>
          <flushTimeout>10000000</flushTimeout>
          <bufferSwitch>1</bufferSwitch>
          <format>DST_IP,SRC_IP,BYTES,LINK_BIT_FIELD,TIME_FIRST,TIME_LAST,
		    PACKETS,?DST_PORT,?SRC_PORT,DIR_BIT_FIELD,PROTOCOL,?TCP_FLAGS</format>
        </interface>
      </fileWriter>
    </destination>
  </exportingProcess>
</ipfix>
```

Manage Nemea modules efficiently
================================

TODO: link to separate supervisor repository

The Nemea system contains a module called Supervisor. This module allows user
to configure and monitor Nemea modules. User specifies modules in XML configuration
file, which is input for the Supervisor.

Example configuration of one module called flowcounter:

```
<module>
  <enabled>false</enabled>
  <params></params>
  <name>flowcounter</name>
  <path>../modules/flowcounter/flowcounter</path>
  <trapinterfaces>
    <interface>
      <note></note>
      <type>TCP</type>
      <direction>IN</direction>
      <params>localhost:8004</params>
    </interface>
  </trapinterfaces>
</module>
```

Every module contains unique name, path to binary file, parameters, enabled flag
and trap interfaces. Enabled flag tells Supervisor to run or not to run module after
startup. Every trap interface is specified by type (TCP, unixsocket or service),
direction (in or out), parameters (output interface: address + port; input
interface: port + number of clients) and optional note.

User can do various operations with modules via Supervisor:
 - start or stop all modules,
 - start or stop one module,
 - display modules status,
 - display loaded configuration,
 - reload configuration (initial XML file or another XML file).

Supervisor monitors the status of all modules and if needed, modules are auto-restarted.
Every module can be run with special "service" interface, which allows Supervisor to get
statistics about sent and received messages from module.
Another monitored event is CPU usage of every module.
These events are periodically monitored.

Supervisor also provides logs with different types of output:
 logs#1 - stdout and stderr of every started module
 logs#2 - supervisor output - this includes modules events (start, stop, restart,
          connecting to module, errors etc.) and in different output file statistics
          about messages and CPU usage.

To get more information about Supervisor, read nemea/supervisor/README.

