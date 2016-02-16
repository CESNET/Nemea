Installation of NEMEA using Vagrant on Fedora22 Cloud
=====================================================

If you do not have a vagrant box for Fedora22 Cloud box yet, use:

```
vagrant box add fedora22-cloud https://download.fedoraproject.org/pub/fedora/linux/releases/22/Cloud/x86_64/Images/Fedora-Cloud-Base-Vagrant-22-20150521.x86_64.vagrant-virtualbox.box
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

