NEMEA System
============

Travis CI build: [![Build Status](https://travis-ci.org/CESNET/Nemea.svg?branch=master)](https://travis-ci.org/CESNET/Nemea)

This file describes the Nemea system in detail. To see more general information,
please have a look at https://www.liberouter.org/nemea.

Installation
============

Vagrant
-------

To try the system "out-of-box", you can use [Vagrant](https://www.vagrantup.com/).
For more information see [./vagrant/](./vagrant/).

Binary packages
---------------

The Nemea system can be also installed using binary packages. Information will
be supplied soon.

Source Codes installation
-------------------------

The Nemea system consists of the [Nemea framework](cejkato2/Nemea-Framework), Nemea modules (basic and detection) and Nemea Supervisor. The whole system
is based on GNU/Autotools build system that makes dependency checking and
building process much more easier.

To clone the read-only repositories, use:

```
git clone --recursive https://github.com/CESNET/nemea
```

After successful clone, use:
```
./bootstrap.sh
```
that will create `configure` scripts and other needed files.

The `configure` script supplies various possibilities of
configuration and uses some environmental variables that influence the build
and compilation process. For more information see:
```
./configure --help
```

Build process can be started by:

```
make
```

The make(1) tool has various parameters, to build the Nemea package faster on
multicore systems, we recommend to use parameter -j with the number of jobs
that should be run in parallel.

When the compilation process ends without any error, the package can be installed
into paths that were set by `configure`. It is recommended NOT to change
target paths by passing variables to make(1).
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

File `startup.xml` should contains configuration for IPFIXcol plugin, among
others there will be settings for output UniRec format and output interface.
Example of such configuration file for UniRec plugin is at the end of this
section. Command for running Nemea module with input from IPFIXcol (e.g. on TCP
port 9966) remains same as with input from `nfdump_reader`:
```
dns_amplification -i t:localhost:9966,u:RT_DNS_amp
```
  
Another examples of starting Nemea modules follows:
ex1) This example starts two `nfdump_readers` on two different files. Records
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

The Nemea system can be managed and monitored by a special module called
[Supervisor](https://github.com/CESNET/Nemea-Supervisor).
For examples and more information see its README.

Nemea Related Publications
==========================

* Tomáš Čejka, Radoslav Bodó, Hana Kubátová: Nemea: Searching for Botnet Footprints. In: Proceedings of the 3rd Prague Embedded Systems Workshop, Prague, Czech Republic, 2015.

* Tomáš Čejka, Václav Bartoš, Lukáš Truxa, Hana Kubátová: [Using Application-Aware Flow Monitoring for SIP Fraud Detection](http://link.springer.com/chapter/10.1007/978-3-319-20034-7_10). In: Proc. of 9th International Conference on Autonomous Infrastructure, Management and Security (AIMS15), 2015.

* Tomáš Čejka, Zdeněk Rosa and Hana Kubátová: [Stream-wise Detection of Surreptitious Traffic over DNS](http://ieeexplore.ieee.org/xpl/articleDetails.jsp?reload=true&arnumber=7033254). In: 2014 IEEE 19th International Workshop on Computer Aided Modeling and Design of Communication Links and Networks (CAMAD) (CAMAD 2014). Athens, 2014

* V. Bartos, M. Zadnik, T. Cejka: [Nemea: Framework for stream-wise analysis of network traffic](http://www.cesnet.cz/wp-content/uploads/2014/02/trapnemea.pdf), CESNET technical report 6/2013.

