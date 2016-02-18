# -*- mode: ruby -*-
# vi: set ft=ruby :

$nemeadashboard = <<-SCRIPT
echo '[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=0
enabled=1
' > /etc/yum.repos.d/mongodb-org-3.2.repo

# install dependencies
yum install -y https://centos7.iuscommunity.org/ius-release.rpm
yum -y install mongodb-org git wget python34 python34-devel httpd
yum groupinstall -y "Development Tools"
wget -q https://bootstrap.pypa.io/get-pip.py
python3.4 get-pip.py

# start services
systemctl start httpd
systemctl start mongod

# clone Nemea-Dashboard
mkdir -p /var/www/html
cd /var/www/html
git clone --depth 1 https://github.com/CESNET/Nemea-Dashboard
cd Nemea-Dashboard

# install dashboard dependencies
pip install -r requirements.txt

SCRIPT

