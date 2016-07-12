## README outline
- [Project status](#project-status)
- [NEMEA System](#nemea-system)
   - [Parts of the system](#parts-of-the-system)
   - [Repositories](#repositories)
- [Dependencies](#dependencies)
- [Installation](#installation)
   - [Binary packages](#binary-packages)
   - [Source codes](#source-codes)
   - [Vagrant](#vagrant)
   - Packer
- [Quick start and how to](#quick-start-and-how-to)
   - [Try out NEMEA modules](#try-out-nemea-modules)
   - [Deploy NEMEA](#deploy-nemea)
   - [Create your own module in C step by step](#create-your-own-module-in-c-step-by-step)
- [NEMEA Related publications](#nemea-related-publications)


## Project status
Travis CI build: [![Build Status](https://travis-ci.org/CESNET/Nemea.svg?branch=master)](https://travis-ci.org/CESNET/Nemea)


# NEMEA System

NEMEA (Network Measurements Analysis) system is a **stream-wise**, **flow-based** and **modular** detection system for network traffic analysis. It consists of many independent modules which are interconnected via communication interfaces and each of the modules has its own task. Communication between modules is done by message passing where the messages contain flow records, alerts, some statistics or preprocessed data.

## Parts of the system

The following picture shows all important parts of the system.

![NEMEA parts](doc/NEMEA-parts.png)

1. Modules - basic building blocks; separate system processes; receive stream of data on their input interfaces, process it and send another stream of data to their output interfaces; all modules are simply divided into two groups according to their task:
   * **detectors** (*red*) - detect some malicious traffic, e.g. *DNS tunnel*, *DoS*, *scanning*
   * **modules** (*yellow*) - export&storage of flow data, preprocess or postprocess the data (filter, aggregate, merge etc.)
2. NEMEA Framework - set of libraries implementing features common for all modules
   * **TRAP** (Traffic Analysis Platform) (*blue*) - implements communication interfaces and functions for sending/receiving the messages between interfaces
   * **UniRec** (Unified Record) (*orange*) - implements efficient data format of the sent/received messages
   * **Common** library (*purple*) - implements common algorithms and data structures used in modules
3. **Supervisor** (*green*) - central management and monitoring tool of the NEMEA system. It takes care of running modules according to a specified configuration.

## Repositories

The project is divided into four repositories added as submodules:
* [NEMEA framework](https://github.com/CESNET/Nemea-Framework)
* [NEMEA modules](https://github.com/CESNET/Nemea-Modules)
* [NEMEA detectors](https://github.com/CESNET/Nemea-Detectors)
* [NEMEA Supervisor](https://github.com/CESNET/Nemea-Supervisor)


## Dependencies

### Building environment

* autoconf
* automake
* gcc
* gcc-c++
* libtool
* libxml2-devel
* libxml2-utils (contains xmllint on Debian)
* make
* pkg-config

### Optional dependencies of modules and detectors

* rpm-build (build of RPM packages)
* libpcap (flow_meter)
* libnfdump (http://sourceforge.net/projects/libnfdump/) or libnf (https://github.com/VUTBR/nf-tools/tree/master/libnf/c) (nfreader)
* libidn (blacklistfilter)
* bison and flex (unirecfilter)

### How to install dependencies:

```
dnf install -y autoconf automake gcc gcc-c++ libtool libxml2-devel make pkg-config libpcap libidn bison flex
```

On older systems use `yum` instead of `dnf`.

On Debian-based systems:

```
apt-get update;
apt-get install TODO
```



# Installation

There are three different ways of installation of the NEMEA system covered
in this document: **vagrant**, **binary packages** and **source codes**.


## Binary packages

The NEMEA system can be installed from binary RPM packages.
To add CESNET's repository containing the packages, run (as root/sudo):
```
rpm -ivh https://homeproj.cesnet.cz/rpm/liberouter/devel/x86_64/liberouter-devel-1.0.0-1.noarch.rpm
```

After that, NEMEA can be installed as any other package (run as root/sudo):
```
yum install nemea
```

Note: `yum` was replaced by `dnf` in some distributions.

For development purposes, there is `nemea-framework-devel` package that installs
all needed development files and docs.


## Source codes

The whole system is based on GNU/Autotools build system that makes dependency checking and
building process much more easier.

To clone the read-only repositories, use:

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
./configure --prefix=/usr --bindir=/usr/bin/nemea --sysconfdir=/etc/nemea --libdir=/usr/lib64
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


## Vagrant

To try the system "out-of-box", you can use [Vagrant](https://www.vagrantup.com/).
For more information see [./vagrant/](./vagrant/).


# Quick start and how to


## Try out NEMEA modules

**Important**: Nemea has to be compiled in advance. Follow [these instructions](#installation) to install NEMEA system from source codes (for this part the *make install* step is optional).


### Execute a module

Modules using TRAP library have two implicit program arguments. `module -h` for help (optional) and `module -i IFC_SPEC` for interface specification (mandatory).


**Module help `-h`**

The example below shows part of help output of the [logger](https://github.com/CESNET/Nemea-Modules/tree/master/logger) module. It contains modules name, description, number of input and output interfaces, modules paramteters and TRAP library parameters (common for all modules).

```
TRAP module, libtrap version: 0.7.6 b258bb4
===========================================
Name: Logger
Inputs: variable
Outputs: 0
Description:
  This module logs all incoming UniRec records to standard output or into a specified file. Each record
  is written as one line containing values of its fields in human-readable format separated by chosen
  delimiters (CSV format). If you use more than one input interface you have to specify output format by
  parameter "-o".

Usage:  logger [COMMON]... [OPTIONS]...

Parameters of module [OPTIONS]:
-------------------------------
  -w  --write <string>             Write output to FILE instead of stdout (rewrite the file).

  -a  --append <string>            Write output to FILE instead of stdout (append to the end).

  -t  --title                      Write names of fields on the first line.

  -c  --cut <uint32>               Quit after N records are received, 0 can be useful in combination
                                   with -t to print UniRec.

Common TRAP parameters [COMMON]:
--------------------------------
  -h [trap,1]                      If no argument, print this message. If "trap" or 1 is given, print
                                   TRAP help.

  -i IFC_SPEC                      Specification of interface types and their parameters, see "-h trap"
                                   (mandatory parameter).

  -v                               Be verbose.

Environment variables that affects output:
------------------------------------------
  LIBTRAP_OUTPUT_FORMAT            If set to "json", information about module is printed in JSON format.

  PAGER                            Show the help output in the set PAGER.
```


**Interface specifier `-i`**

The `-i` parameter with the interface specifier *IFC_SPEC* (`module -i IFC_SPEC`) specifies modules interfaces - their types and parameters. The interface specifier has the following format:

`<IFC 1>,<IFC 2>,...,<IFC N>`.

where `<IFC x>` looks like

`<type>:<par1>:<par2>:...:<parN>`.

Interfaces are separated by `,` and their parameters are separated by `:`. Input IFCs must be specified at first, output IFCs follow. Examples below show the two most common cases.

* `module1 -i t:address:port1,t:port2`
* `module2 -i u:sock1,u:sock2`

First example *module1* uses TCPIP interfaces (for machine to machine communication) and it has one input and one output interface. The first interface (`t:address:port1`) has type `t` (TCPIP) and it will connect to machine with address `address` on port `port1` (it behaves as a client). The second interface (`t:port2`) is also TCPIP and it will listen on port `port2` for incoming connections (it behaves as a server).

Second example *module2* uses UNIX-SOCKET interfaces (for communication on the same machine) and it has also one input and one output interface. The first interface (`u:sock1`) has type `u` (UNIX-SOCKET) and it will connect to socket `sock1` (it behaves as a client). The second interface (`u:sock2`) is also UNIX-SOCKET and it will listen on `sock2` for incoming connections (it behaves as a server).

**Important findings:**
* TCPIP interface for machine to machine communication, UNIX-SOCKET for communication on the same machine
* input interface behaves as a client, output interfaces behaves as a server

For detailed information and another examples with *IFC_SPEC* click [here](https://github.com/CESNET/Nemea-Framework/blob/master/libtrap/README.ifcspec.md).


### Interconnect two modules

Let´s try to interconnect [logreplay](https://github.com/CESNET/Nemea-Modules/tree/master/logreplay) and [logger](https://github.com/CESNET/Nemea-Modules/tree/master/logger) modules to see them communicate.
Logreplay module has one output interface and it reads CSV file from logger module and sends it in UniRec format.
Logger has one input interface and it logs all incoming UniRec records to standard output or into specified file in CSV format.
These two modules can be interconnected using one input IFC and one output IFC.

[This script](https://github.com/CESNET/Nemea/blob/master/use-cases/logger-repeater.sh) can be used for the demonstration. With no parameter it prints help with description, otherwise it accepts *generate* parameter or a name of input CSV file. With *generate* parameter it first creates tmp CSV file with header and 3 flow records (see [this](https://github.com/CESNET/Nemea/blob/master/use-cases/logger-repeater.sh#L53)). Thereafter it executes logreplay and logger modules

```
logreplay -i "u:my_socket"` -f CSV_file
```
and
```
logger -i "u:my_socket" -t
```

Logreplay has one UNIX-SOCKET output interface listening on *my_socket* and logger has one UNIX-SOCKET input interface which connects to *my_socket*.

Now finally open [this directory](https://github.com/CESNET/Nemea/tree/master/use-cases) and execute the script:
```
./logger-repeater.sh generate
```

It should print exactly the same output as generated CSV tmp input (header and 3 records). In [use-cases](https://github.com/CESNET/Nemea/tree/master/use-cases) there are more examples with basic modules.
`logreplay` is one of possible ways of getting data into the NEMEA system. Here(TODO) is the list of all possible ways.


## Deploy NEMEA

This section shows how to deploy NEMEA in four steps.

It only covers the basics needed to run the system in its default configuration. Keep in mind that NEMEA was designed as a very flexible framework, so every user can (and should) adjust the configuration of NEMEA modules to their own purposes.


### 1. Installation

First of all, the whole system (NEMEA Framework, Modules, Detectors and Supervisor) has to be installed. Follow [these](#installation) instructions to install the system from RPM or from source codes.


### 2. Prepare configurations

To avoid manual control of the system, there is [NEMEA Supervisor](https://github.com/CESNET/Nemea-Supervisor). It is central management and monitoring tool of the system and it takes care of running modules **according to a specified XML configuration**.

We need to prepare XML configuration file for Supervisor. Fortunatelly, almost everything is already done.

After installation (from RPM or from source codes with recommended `configure` parameters), there are 2 important paths with configurations:
* `/ush/share/nemea-supervisor/` - contains default prepared XML configuraions of all NEMEA modules (like [here](https://github.com/CESNET/Nemea-Supervisor/tree/master/configs))
* `/etc/nemea/` - contains XML configuration file for Supervisor and directories with used modules configurations (they are empty after installation)

Note: these two paths depend on *datarootdir* and *sysconfdir* parameters of the `configure` script during the installation.

The only thing we have to do is this (probably with sudo / root):
```
cp -r /usr/share/nemea-supervisor /etc/nemea
```

After this command, supervisor will use default configurations of the modules. It is shown [here]() that the paths from sysconfdir (/etc/nemea in our case) are included in the configuration file. For detailed information about supervisor configuration file click [here]().


### 3. Start and control modules

Once the set of NEMEA modules was configured, all of them can be started easily by [Nemea Supervisor](https://github.com/CESNET/Nemea-Supervisor):
* `service nemea-supervisor start`
* OR? `supcli`, option 6 (reload configuration)
  * (*TODO*: will this start the modules? and would this work for every installation option or for RPM/Vagrant only?)
* Check status of the modules:
  * `supcli`, option 4
  * All modules previously enabled should be *running*.

The modules are running, but they don't receive any data yet. We need to send some flow data to the system ...


### 4. Get flows to your system

**IpfixCol**

*(recommended)* Use IPFIXcol to collect NetFlow/IPFIX data from routers/probes and an IPFIXcol [unirec plugin](https://github.com/CESNET/ipfixcol/tree/master/plugins/storage/unirec) to re-send the data to NEMEA.
  * needed to install IPFIXcol and the plugin and to set up the routers/probes
  * default and recommended solution for production


**FlowMeter**

Use NEMEA internal flow exporter (*flow_meter* module).
  * it reads data directly from network interface (via libpcap), measures flows and export it to other NEMEA modules
  * simple, but not very performing solution (flow_meter was not designed for performance), suitable only for testing or very small networks
    * *TODO*: measure how much traffic can flow_meter handle and make recommendation what "very small network" means?


**NfReader**

[NfReader](https://github.com/CESNET/Nemea-Modules/tree/master/nfreader) reads **nfdump** files and sends flow records in UniRec format on its output TRAP interface.


**LogReplay**

[LogReplay](https://github.com/CESNET/Nemea-Modules/tree/master/logreplay) converts CSV format of data, from logger module to UniRec format and sends it to the output interface.


## Create your own module in C step by step

**Important**: Nemea-Framework has to be installed in advance. Follow [these instructions](#installation) to install whole NEMEA system (including NEMEA framework) or [these instructions]() to install only NEMEA framework.


#### Use Example module as a template

Let `/data/mighty-module/` be the directory we want to develop our module in (replace path `/data/mighty-module/` in all commands with another directory if needed) and *mighty_module* the name of our module. We will use example module as a template - copy all files from [this directory](https://github.com/CESNET/Nemea-Framework/tree/master/examples/module) to `/data/mighty-module/`.

In `/data/mighty-module/configure.ac` replace the following lines
```
AC_INIT([example_module], [1.0.0], [traffic-analysis@cesnet.cz])
AC_CONFIG_SRCDIR([example_module.c])
```
with
```
AC_INIT([migty_module], [1.0.0], [YOUR EMAIL ADDRESS])
AC_CONFIG_SRCDIR([mighty_module.c])
```

In `/data/mighty-module/Makefile.am` replace the following lines
```
bin_PROGRAMS=example_module
example_module_SOURCES=example_module.c fields.c fields.h
example_module_LDADD=-lunirec -ltrap
```
with
```
bin_PROGRAMS=mighty_module
mighty_module_SOURCES=mighty_module.c fields.c fields.h
mighty_module_LDADD=-lunirec -ltrap
```

Finally execute `mv /data/mighty-module/example_module.c /data/mighty-module/mighty_module.c` to rename the source file.


####Build the module

Execute the following commands in `/data/might-module/`:

1) Let Autotools process the configuration files.
```
autoreconf -i
```

2) Configure the module directory.
```
./configure
```

3) Build the module.
```
make
```

4) (**Optional**) Install the module. The command should be performed as root (e.g. using sudo).
```
make install
```


### Code explanation

The example module already links **TRAP** (libtrap) and **UniRec** libraries. It is a simple module with one input and one output interface which receives on input inteface a message in UniRec format with two numbers and sends them together with their sum to output interface.

The code contains comments but here is the list of important operations:


#### LibTRAP

1. [Basic module information](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L74) - specify name, description and number of input / output interfaces of the module
2. [Module parameters](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L87) - define parameters the module accepts as program arguments
3. [Module info structure initialization](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L111) - initialize a structure with information from the two previsous points
4. [TRAP initialization](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L116) - initialize module interfaces
5. [GETOPT macro](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L127) - parse program arguments
6. Main loop:
   * [Receive a message](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L172) - receive a message in UniRec format from input interface
   * [Handle receive error](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L175) - check whether an error has occured during receive
   * [Send a message](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L200) - send a message in UniRec format via output interface
   * [Handle send error](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L203) - check whether an error has ocurred during send
7. [TRAP and module info clean-up](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L210) - free everything, libtrap finalization


#### UniRec

1. [UniRec fields definition](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L62) - define data types and names of the fields which will be used in UniRec messages (both received and sent messages), e.g. *uint32 PACKETS*
2. [Templates creation](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L141) - create UniRec templates separately for every interface (a template defines set of fields in the message) note: two input interfaces receiving same messages can use one template
3. [Output record allocation](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L154) - allocate a memory for message sent via output interface
4. Main loop (*fields manipulation*):
   * [get field](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L191) - get a value of specified field from received message according to UniRec template
   * [set field](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L196) - set a value of specified field in message which will be sent according to UniRec template
   * [copy fields](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L195) - copy values of fields in received message to fields in message which will be sent according to UniRec templates of both interfaces (only fields that are common for both interfaces are copied)
5. [UniRec cleanup](https://github.com/CESNET/Nemea-Framework/blob/master/examples/module/example_module.c#L219) - free everything, UniRec finalization


### Execute the module

Modules using TRAP library have two implicit program arguments. `module -h` for help (optional) and `module -i IFC_SPEC` for interface specification (mandatory).


#### Module help

After executing `/data/mighty-module/mighty_module -h`, program prints help which contains information from module info structure:

* module basic information - name, description, number of input / output interfaces
* module parameters - short opt, long opt, description, argument data type
* TRAP library parameters - parameters common for all modules using libtrap


#### Interface specifier

Format of the specifier with examples is explained in detail [here](https://github.com/CESNET/Nemea-Framework/blob/master/libtrap/README.ifcspec.md).


### Develop the module

Now just modify the algorithm in the main loop and job is done :-)


### Add a new module to running conf


NEMEA Related Publications
==========================

* Tomáš Čejka, Radoslav Bodó, Hana Kubátová: Nemea: Searching for Botnet Footprints. In: Proceedings of the 3rd Prague Embedded Systems Workshop (PESW), Prague, CZ, 2015.

* Tomáš Čejka, Václav Bartoš, Lukáš Truxa, Hana Kubátová: [Using Application-Aware Flow Monitoring for SIP Fraud Detection](http://link.springer.com/chapter/10.1007/978-3-319-20034-7_10). In: Proc. of 9th International Conference on Autonomous Infrastructure, Management and Security (AIMS15), 2015.

* Tomáš Čejka, Zdeněk Rosa and Hana Kubátová: [Stream-wise Detection of Surreptitious Traffic over DNS](http://ieeexplore.ieee.org/xpl/articleDetails.jsp?reload=true&arnumber=7033254). In: Proc. of 19th IEEE International Workshop on Computer Aided Modeling and Design of Communication Links and Networks (CAMAD 2014). Athens, 2014.

* Václav Bartoš, Martin Žádník, Tomáš Čejka: [Nemea: Framework for stream-wise analysis of network traffic](http://www.cesnet.cz/wp-content/uploads/2014/02/trapnemea.pdf), CESNET technical report 6/2013.

