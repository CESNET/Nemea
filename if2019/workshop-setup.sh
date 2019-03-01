#!/bin/bash -x

# Warning: this script was created to setup PCs in the lab of FEE CTU in Prague
# (www.fel.cvut.cz)
# You probably should not run it anywhere else...

sudo /opt/vytahnout.sh

VBoxManage import --options keepallmacs,importtovdi /opt/InstallFest2019/installfest2019.ova 

mkdir ~guest/monitoring-ws
cd ~guest/monitoring-ws
wget -O - 'https://nemea.liberouter.org/if2019/mon-workshop-files.tar.gz' | tar -xzf -

VirtualBox&

