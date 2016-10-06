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
yum install -y python-pymongo

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

var d = {
   "password" : "$2a$12$MuAuralQ8p01q8eXPtTm4eZsflipBKx6cK0HZMpQbCNyDgcX4YPse",
   "username" : "nemea",
   "name" : "Nemea",
   "surname" : "Test User",
   "settings": [{
      "items": [{
              "loading": false,
              "title": "",
              "type": "sum",
              "sizeX": 1,
              "sizeY": 1,
              "content": "Attempt.Login in last 24h",
              "config": {
                  "category": "Attempt.Login",
                  "endtime": 1461062898,
                  "type": "sum",
                  "period": "24",
                  "begintime": 1460976498
              },
              "col": 7,
              "row": 4
          },
          {
              "loading": false,
              "title": "24h/30m categories (events)",
              "type": "barchart",
              "sizeX": 4,
              "sizeY": 3,
              "selector": false,
              "content": "",
              "config": {
                  "metric": "Category",
                  "period": "24",
                  "window": "30",
                  "begintime": 1460976498,
                  "endtime": 1461062898,
                  "type": "barchart"
              },
              "col": 0,
              "row": 0
          },
          {
              "loading": false,
              "title": "24h categories",
              "type": "piechart",
              "sizeX": 2,
              "sizeY": 3,
              "content": "Share categories",
              "config": {
                  "metric": "Category",
                  "period": "24",
                  "filter": false,
                  "begintime": 1460976524,
                  "endtime": 1461062924,
                  "type": "piechart"
              },
              "col": 4,
              "row": 0
          },
          {
              "loading": false,
              "title": "24h Top flows",
              "type": "top",
              "sizeX": 3,
              "sizeY": 2,
              "content": "",
              "config": {
                  "endtime": 1461062898,
                  "type": "top",
                  "period": "60",
                  "begintime": 1460846898
              },
              "col": 3,
              "row": 3
          },
          {
              "loading": false,
              "title": "",
              "type": "sum",
              "sizeX": 1,
              "sizeY": 1,
              "content": "Events in last 24h",
              "config": {
                  "category": "any",
                  "endtime": 1461062898,
                  "type": "sum",
                  "period": "24",
                  "begintime": 1460976498
              },
              "col": 7,
              "row": 3
          },
          {
              "loading": false,
              "title": "",
              "type": "sum",
              "sizeX": 1,
              "sizeY": 1,
              "content": "Events in last 1h",
              "config": {
                  "category": "any",
                  "endtime": 1461062898,
                  "type": "sum",
                  "period": "1",
                  "begintime": 1461059298
              },
              "col": 6,
              "row": 3
          },
          {
              "loading": false,
              "title": "24h reporters",
              "type": "piechart",
              "sizeX": 2,
              "sizeY": 3,
              "content": "Share reporters",
              "config": {
                  "metric": "Node.SW",
                  "endtime": 1461062898,
                  "type": "piechart",
                  "period": "24",
                  "begintime": 1460976498
              },
              "col": 6,
              "row": 0
          },
          {
              "loading": false,
              "title": "",
              "type": "sum",
              "sizeX": 1,
              "sizeY": 1,
              "content": "DDoS per 12h",
              "config": {
                  "category": "Availibility.DDoS",
                  "endtime": 1461062898,
                  "type": "sum",
                  "period": "12",
                  "begintime": 1461019698
              },
              "col": 6,
              "row": 4
          },
          {
              "loading": false,
              "title": "24h/30m categories (flows)",
              "type": "barchart",
              "sizeX": 3,
              "sizeY": 3,
              "selector": true,
              "content": "",
              "config": {
                  "metric": "Category",
                  "period": "24",
                  "window": "30",
                  "begintime": 1460976498,
                  "endtime": 1461062898,
                  "type": "barchart"
              },
              "col": 0,
              "row": 3
          },
          {
              "loading": false,
              "title": "HostStats 24h",
              "type": "piechart",
              "sizeX": 2,
              "sizeY": 3,
              "content": "Example of own filter",
              "config": {
                  "filter_value": "cz.cesnet.nemea.hoststats",
                  "metric": "Category",
                  "period": "24",
                  "filter_field": "Node.Name",
                  "filter": true,
                  "begintime": 1460976498,
                  "endtime": 1461062898,
                  "type": "piechart"
              },
              "col": 3,
              "row": 5
          }
      ],
      "settings": {
          "timeshift": "0",
          "interval": "60",
          "title": "Default"
      }
  }]
};

db.users.insert(d);
'

# install and start backend

cp nemea-dashboard.service "`pkg-config --variable=systemdsystemunitdir systemd`"

systemctl enable nemea-dashboard

service nemea-dashboard start

SCRIPT

