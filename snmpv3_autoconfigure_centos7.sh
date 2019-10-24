#!/bin/bash

echo Updating yum and installing net-snmp...
yum -y update
yum -y install epel-release
yum -y install net-snmp net-snmp-utils
echo Installing default snmp firewall rules for public zone...
cp data/snmp.xml /etc/firewalld/services/snmp.xml
firewall-cmd --reload
firewall-cmd --add-service=snmp --permanent --zone=public
echo Restarting firewall daemon...
firewall-cmd --reload
echo Generating random 16-char password and key...
sleep 1
password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
key=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
echo $password > password.txt
echo $key > key.txt
echo Installing default snmpd v3 config template...
sleep 1
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.orig
cp data/snmpd.conf /etc/snmp/snmpd.conf
echo Creating snmpv3 user \'admin\'...
sleep 1
net-snmp-create-v3-user -ro -A $password -X $key -a SHA -x AES admin
echo Installing Linux distro detection script and snmp extension...
sleep 1
cp data/distro /usr/bin/distro
chmod +x /usr/bin/distro
echo Enabled and starting snmpd...
systemctl start snmpd
systemctl enable snmpd

echo SNMP is configured for snmpv3 user \'admin\' on port 161/udp
echo Please see password.txt and key.txt files for authentication info
