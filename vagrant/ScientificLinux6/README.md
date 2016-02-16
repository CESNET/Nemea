Installation of NEMEA using Vagrant on Scientific Linux 6
=========================================================

If you do not have a vagrant box for Scientific Linux 6 box yet, use:

```
vagrant box add --insecure cesnet/nemea-2-1-0 https://sauvignon.liberouter.org/nemea-2-1-0.box
```

Installation - Final Step
=========================

Start the VM Installation using (this will take few minutes):
```
vagrant up
```

Once the installation is complete, SSH into the VM:
```
vagrant ssh
```

Content of VM
=============

* NEMEA installed from source codes
* munin

