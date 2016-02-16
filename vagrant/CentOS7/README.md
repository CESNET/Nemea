Installation of NEMEA using Vagrant on CentOS7
==============================================

If you do not have a vagrant box for CentOS7 box yet, use:

```
vagrant box add centos/7 --provider=virtualbox
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

* all NEMEA packages installed from RPM from homeproj.cesnet.cz
* NEMEA-Dashboard
* ipfixcol with ipfixcol-unirec-output

