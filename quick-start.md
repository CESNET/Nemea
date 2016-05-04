# NEMEA quick start guide

This text will guide you through installation, configuration and running of the NEMEA system.

It only covers the basics needed to run the system in its default configuration.
Keep in mind that NEMEA was designed as a very flexible framework, 
so every user can (and should) adjust the configuration of NEMEA modules to their own purposes.


## Installation

* See [Installation section of the main README file](./README.md#installation) for installation options and corresponding instructions.
* The recommended option is to **install NEMEA from RPM packages** or to **use Vagrant** to automatically create a virtual machine with everything prepared.


## Initial configuration

* *TODO* (I think config files for supervisor must be created or the default ones copied; is there something more? Are all the modules enabled by default or need the user enable them all manually?)


## Start the NEMEA system

* Once the set of NEMEA modules was configured, all of them can be started easily by [Nemea Supervisor](https://github.com/CESNET/Nemea-Supervisor):
* `service nemea-supervisor start`
* OR? `supcli`, option 6 (reload configuration)
  * (*TODO*: will this start the modules? and would this work for every installation option or for RPM/Vagrant only?)
* Check status of the modules:
  * `supcli`, option 4
  * All modules previously enabled should be *running*.

The modules are running, but they don't receive any data yet. We need to send some flow data to the system ...


## Get data to NEMEA
There are two ways to get flow data to the NEMEA system:

1. *(recommended)* Use IPFIXcol to collect NetFlow/IPFIX data from routers/probes and an IPFIXcol [unirec plugin](https://github.com/CESNET/ipfixcol/tree/master/plugins/storage/unirec) to re-send the data to NEMEA.
  * needed to install IPFIXcol and the plugin and to set up the routers/probes
  * default and recommended solution for production
2. Use NEMEA internal flow exporter (*flow_meter* module).
  * it reads data directly from network interface (via libpcap), measures flows and export it to other NEMEA modules
  * simple, but not very performing solution (flow_meter was not designed for performance), suitable only for testing or very small networks
    * *TODO*: measure how much traffic can flow_meter handle and make recommendation what "very small network" means?

*TODO*: diagrams for illustration


### Steps for option 1 (IPFIXcol)

* If NEMEA was installed from RPM or source codes, IPFIXcol and its unirec plugin must be installed separately.
  * *TODO*: instructions to install (and configure if necessary) IPFIXcol or a link to them.
* If Vargant was used, IPFIXcol and its unirec plugin are already installed and preconfigured.

* Check IPFIXcol default startup configuration in *???*/ipfixcol-startup.xml. It contains:
  * Collecting process listening on UDP port 4739 (accepts data in IPFIX, Netflow v5, Netflow v9 and sFlow formats)
  * Unirec plugin as the only exporting process. Several output interfaces are defined - one for basic flows and others for flows extended by L7 information of various protocols. This means that there will be several TRAP interfaces the other modules can be connected to. All flow records received by IPFIXcol are sent to the basic interface, the ones contaning some L7 information are also sent to the corresponding interface. (TODO: describe exact rules)
  * If your probes doesn't export the L7 information, disable (comment out) all interfaces except the first one.
  * *TODO*: comment out the L7 interfaces by default
  * For more information check README files of [IPFIXcol](https://github.com/CESNET/ipfixcol/tree/master/base) and its [unirec plugin](https://github.com/CESNET/ipfixcol/tree/master/plugins/storage/unirec)
  * If you want to also store the flow data, not only resend them to NEMEA, you need to add another `exportingProcess` (e.g. [FastBit](https://github.com/CESNET/ipfixcol/tree/master/plugins/storage/fastbit) to the configuration. Consult IPFIXcol documentation for more information.
* Enable IPFIXcol in Nemea-supervisor, so it's started automatically with other NEMEA modules
  * In `???/data-sources/ipfixcol.sup`, set `enabled` to `true` (`<enabled>true</enabled>`)
  * *TODO*: this will work only if default configuration was used in some previous step - mention this somehow (or maybe the default configuration will be the only option for this tutorial?)
  * Reload supervisor configuration: (`service nemea-supervisor reload` or `supcli`, option 6)
  * **Alternatively**, you can run IPFIXcol manually: `ipfixcol -d -c /path/to/ipfixcol-startup.xml`
* Set up your router(s)/probe(s) to send IPFIX or NetFlow data to the server running NEMEA to UDP port 4739 (protocol and port can be configured in `???/ipfixcol-startup.xml`)
  * *This depends on the type of your router or probe, we can't help you with that*


### Steps for option 1 (flow_meter)

* *TODO*


## *TODO*: reporting, Nemea-dashboard
