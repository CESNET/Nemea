---
layout: page
title: Tutorial
menuentry: Tutorial
public: false
docmenu: true
permalink: /doc/tutorial/
---

## (IP) Flow monitoring

Network communication works because of *packets*.  A packet is a message
consisting of headers (according to used protocols) and payload (transferred data).

It is possible to analyze and store packets, but for large networks,
it is very resource consuming.  Therefore, we usually use IP Flow data
instead of raw packets for analysis.

An IP Flow represents a sequence of packets with the same key features.
We usually use *SRC_IP*, *DST_IP*, *PROTOCOL*, *SRC_PORT*, *DST_PORT* as key
features for aggregation of packets.  As a result, an IP Flow is a
one-directional communication between two applications via network.

For analysis of IP Flows, here comes the NEMEA system.

## NEMEA

A module is an independent process that communicates with other
modules using communication interfaces (IFC) implemented in `libtrap`.

![NEMEA parts](NEMEA-parts.png)


Real configuration - set of running modules is shown here, everything runs on a
single machine:

    --- [CONFIGURATION STATUS] ---
          | name                 | enabled | status  | PID   |
    Profile: Data sources        |  true   |
       0  | ipfixcol             |  true   | running | 6095  |
    
    Profile: Detectors           |  true   |
       1  | dns_amplification    |  true   | running | 31245 |
       2  | bruteforce_detector  |  true   | running | 31248 |
       3  | ddos_detector        |  true   | running | 31249 |
       4  | haddrscan_detector   |  true   | running | 31250 |
       5  | haddrscan_aggregator |  true   | running | 8631  |
       6  | hoststatsnemea       |  true   | running | 31252 |
       7  | ipblacklistfilter    |  true   | running | 31253 |
       8  | ipv6stats            |  true   | running | 31254 |
       9  | vportscan_detector   |  true   | running | 31257 |
       10 | vportscan_aggregator |  true   | running | 31258 |
    
    Profile: Reporters           |  true   |
       11 | hoststats2idea       |  true   | running | 8549  |
       12 | amplification2idea   |  true   | running | 8550  |
       13 | ipblacklist2idea     |  true   | running | 8551  |
       14 | vportscan2idea       |  true   | running | 8552  |
       15 | bruteforce2idea      |  true   | running | 8553  |
       16 | haddrscan2idea       |  false  | stopped | 0     |
       17 | ddos_detector2idea   |  true   | running | 8557  |
       20 | warden_filer         |  true   | running | 2255  |
    
    Profile: Munin               |  true   |
       18 | link_traffic         |  true   | running | 31281 |
       19 | proto_traffic        |  true   | running | 31288 |
    
    Profile: Others              |  true   |

## Starting with NEMEA

We expect that NEMEA is already installed on your machine.
If not, try to look at [Installation](/doc/installation/).

Download and extract: [nemea-tutorial.tar.gz](/doc/nemea-tutorial.tar.gz)

# 1. CSV files

See files:

    less virtual-sensor.csv

    less zwave-sensor.csv

## Replay CSV files

Read data from `zwave-sensor.csv` and "send" them via File interface,
i.e., into `outputfile.trapcap` file.

    /usr/bin/nemea/logreplay -i f:outputfile.trapcap -f zwave-sensor.csv

We can see the new `outputfile.trapcap` created in the current path.

## Translate UniRec into CSV

Logger will wait for data at `mysocket` IFC and translate it to CSV

    /usr/bin/nemea/logger -i u:mysocket -t

We can use `traffic_repeater` to replay UniRec stored in the file:

    /usr/bin/nemea/traffic_repeater -i f:outputfile.trapcap,u:mysocket:buffer=off

# 2. Generate own data

Have a look into `zwave-generator.py`:

    less zwave-generator.py

Generate data and show it using `logger` (ideally in 2 terminals):

    ./zwave-generator.py
    /usr/bin/nemea/logger -i u:mysocket -t


# 3. Store data into binary UniRec file(s)

`:w` rewrite

`:a` append (creates new file with suffix, e.g. data.trapcap.0, data.trapcap.1)

`:size=` in MB

`:time=` in minutes

    /usr/bin/nemea/traffic_repeater -i u:mysocket,f:soubor:a

    /usr/bin/nemea/traffic_repeater -i u:mysocket,f:soubor:time=2

Result:

    $ ls -lh soubor*
    -rw-rw-r--. 1 tomas tomas 929 26. Oct 23.38 soubor.201710262336
    -rw-rw-r--. 1 tomas tomas  47 26. Oct 23.38 soubor.201710262338
    $

# 4. Monitoring local traffic

NEMEA contains own IP Flow exporter.  It can aggregate IP Flow data and send
them to other NEMEA modules directly via TRAP interface or to a flow collector
in [IPFIX](https://en.wikipedia.org/wiki/IP_Flow_Information_Export) format.


## Start `flow_meter`

Capture traffic on wifi interface wlo1, export IP flow records and send
results via TRAP interface (UNIX socket) with `basicflow` identifier:

    $ /usr/bin/nemea/flow_meter -I wlo1 -i u:basicflow

We can receive the data using `logger` again:

    $ /usr/bin/nemea/logger -t -i u:basicflow

## IPFIX for flow collector

The following command runs IPFIX exporter that sends IPFIX data to
the server 127.0.0.1 with 4739 port using UDP.
We can watch data using [wireshark](https://www.wireshark.org/).

    $ /usr/bin/nemea/ipfixprobe -I wlo1 -x 127.0.0.1:4739 -u

In the real world, IPFIX data can be received by [IPFIXcol](https://github.com/CESNET/ipfixcol2).

# Further readings

Continue at http://nemea.liberouter.org/doc/

