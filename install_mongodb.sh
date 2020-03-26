#!/bin/sh
/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xd68fa50fea312927
/bin/echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
/usr/bin/apt-get -q update
/usr/bin/apt-get -qq install mongodb-org
/bin/systemctl start mongod
/bin/systemctl enable mongod
