Creation of image using Packer
==============================

Get Packer from https://www.packer.io

Set PATH to its directory in order to use the binaries.

```
cd centos-7.1/
packer build template.json
```

will create a directory with VirtualBox ovf and virtual disk.

In case Vagrant box is needed, use `template.json-vagrant-box`
instead of `template.json`.

