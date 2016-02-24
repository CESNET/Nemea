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
systemctl enable httpd
systemctl enable mongod
service httpd start
service mongod start

# clone Nemea-Dashboard
mkdir -p /var/www/html
cd /var/www/html
git clone --depth 1 https://github.com/CESNET/Nemea-Dashboard
cd Nemea-Dashboard

# install dashboard dependencies
pip install -r requirements.txt

mongo 127.0.0.1/nemeadb --eval '
db.users.drop();
var d = { "name" : "Nemea",
"surname" : "Test User",
"username" : "nemea",
"password" : "$2a$12$Z9PaH.uCgAEOY7JDVEo78efEcoL0oiTWY88gbJTJhIIKFMOQGkOei",
"settings" : []
 };
db.users.insert(d);
'

# start backend on background
cd /var/log;
nohup python3.4 /var/www/html/Nemea-Dashboard/apiv2.py > nemea-dashboard.out 2> nemea-dashboard.err < /dev/null &

SCRIPT

