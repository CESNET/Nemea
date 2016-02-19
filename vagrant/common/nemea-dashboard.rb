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
var d = { "_id" : ObjectId("56b33e737194ed8d440db2b7"),
"username" : "default",
"password" : "$2a$12$Md5LyzT0ejjCIeQeUR3U5eLHrP602Vz7lDD6HiV5UWRITZythu6Tq",
"settings" : [ { "row" : 0, "content" : "", "sizeX" : 3, "col" : 0,
"title" : "Events ratios in 12 hours", "loading" : false, "type" : "piechart", "sizeY" : 3,
"config" : { "begintime" : "2016-02-18T21:37:22.284Z", "metric" : "category", "period" : "12", "type" : "piechart" } },
{ "row" : 2, "selector" : false, "timestamp" : "", "type" : "barchart", "sizeY" : 3,
"config" : { "begintime" : "2016-02-18T21:37:22.305Z", "period" : "12", "metric" : "category", "type" : "barchart",
"window" : "60" }, "sizeX" : 4, "col" : 3, "title" : "Last 24 hours in 1h window",
"loading" : false, "minSizeX" : 2, "minSizeY" : 2 },
{ "row" : 0, "sizeX" : 3, "sizeY" : 2, "title" : "Top events in 1 hour",
"loading" : false, "type" : "top", "col" : 3, "config" : { "begintime" : "2016-02-19T08:37:22.312Z", "period" : 1 } },
{ "row" : 1, "sizeX" : 1, "sizeY" : 1, "title" : "12h", "loading" : false, "type" : "sum", "col" : 6,
"config" : { "begintime" : "2016-02-18T21:37:22.318Z", "period" : "12", "type" : "sum", "category" : "Attempt.Login" } },
{ "row" : 0, "sizeX" : 1, "sizeY" : 1, "title" : "12h", "loading" : false, "type" : "sum", "col" : 6,
"config" : { "begintime" : "2016-02-19T08:37:22.324Z", "period" : "1", "type" : "sum", "category" : "any" } },
{ "row" : 0, "sizeX" : 1, "sizeY" : 1, "title" : "12h", "loading" : false, "type" : "sum", "col" : 7,
"config" : { "begintime" : "2016-02-19T03:37:22.329Z", "period" : "6", "type" : "sum", "category" : "any" } },
{ "row" : 1, "sizeX" : 1, "sizeY" : 1, "title" : "12h", "loading" : false, "type" : "sum", "col" : 7,
"config" : { "begintime" : "2016-02-18T21:37:22.334Z", "period" : "12", "type" : "sum", "category" : "Availability.DoS" } } ]
 };
db.users.insert(d);
'

# start backend on background
cd /var/log;
nohup python3.4 /var/www/html/Nemea-Dashboard/apiv2.py > nemea-dashboard.out 2> nemea-dashboard.err < /dev/null &

SCRIPT

