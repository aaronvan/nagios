#!/bin/bash

#############################
#                           #
# Install Nagios            #
#                           #
############################# 

yum -y install httpd php php-cli gcc glibc glibc-common gd gd-devel net-snmp openssl-devel wget unzip

useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagcmd apache

cd /tmp
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz

wget http://www.nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz

tar zxf nagios-4.1.1.tar.gz
tar zxf nagios-plugins-2.1.1.tar.gz
cd nagios-4.1.1

./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf

# Change the administrator password
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadrmin

cd /tmp/nagios-plugins-2.1.1

./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
make all
make install

service httpd start
service nagios start
echo "Nagios is ready! Open a browers and enter <host ip_address>/nagios"

exit 0
