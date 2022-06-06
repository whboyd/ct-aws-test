#! /bin/bash

# Database
until apt-get remove -y unattended-upgrades; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive

echo "mysql-apt-config mysql-apt-config/repo-codename select bionic" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/repo-distro select ubuntu" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-preview select Disabled" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-product select Ok" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-tools select Enabled" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/unsupported-platform select ubuntu bionic" | debconf-set-selections
echo "mysql-apt-config/enable-repo select mysql-5.7-dmr" | debconf-set-selections

wget https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
dpkg --install mysql-apt-config_0.8.22-1_all.deb

apt update
apt install -y -f mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7*
until echo "show databases;" | mysql; do sleep 5; done
cat << EOF | mysql
create database store;
use store;

create table items (
  id int not null auto_increment,
  name varchar(255) not null,
  description varchar(255) not null,
  price int not null,
  primary key (id)
);

insert into items (name, description, price) values ("bees", "A packet of bees.", 3);
insert into items (name, description, price) values ("trees", "Some trees.", 3);
insert into items (name, description, price) values ("wheels", "Four wheels.", 3);
insert into items (name, description, price) values ("flowers", "Not actually flowers, but seeds.", 3);
insert into items (name, description, price) values ("rocks", "A pile o' stones.", 3);
insert into items (name, description, price) values ("orange soda", "Several bottles of orange soda.", 3);

create user 'woo' identified with mysql_native_password by 'woo';
grant select on store.items to woo;
EOF

# API
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt update
apt install -y nodejs=18.3.0-deb-1nodesource1

cd /opt
rm -rf ct-aws-test
git clone https://github.com/whboyd/ct-aws-test.git

cd /opt/ct-aws-test/api
npm install
cat << EOF > /etc/systemd/system/ct-aws-api.service
[Service]
WorkingDirectory=/opt/ct-aws-test/api
ExecStart=node server.js
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=ct-aws-api
User=ct-aws
Group=ct-aws
Environment=DB_HOST=127.0.0.1
Environment=DB_USER=woo
Environment=DB_PASS=woo

[Install]
WantedBy=multi-user.target
EOF

useradd ct-aws
chown -R ct-aws:ct-aws /opt/ct-aws-test

systemctl daemon-reload
systemctl enable ct-aws-api
systemctl restart ct-aws-api

# Frontend
npm install -g serve

cat << EOF > /etc/systemd/system/ct-aws-frontend.service
[Service]
WorkingDirectory=/opt/ct-aws-test/frontend
ExecStart=npm start
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=ct-aws-frontend
User=ct-aws
Group=ct-aws
Environment=PORT=8081

[Install]
WantedBy=multi-user.target
EOF

cd /opt/ct-aws-test/frontend
rm package-lock.json
npm install
npm run build
chown -R ct-aws:ct-aws /opt/ct-aws-test
systemctl daemon-reload
systemctl enable ct-aws-frontend
systemctl restart ct-aws-frontend
