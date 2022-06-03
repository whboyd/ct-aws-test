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

until apt-get remove -y unattended-upgrades; do sleep 5; done
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

apt install nodejs
mkdir -p /var/www/ct-aws-api
wget
