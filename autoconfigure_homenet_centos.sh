#!/bin/bash

echo Updating dnf and installing net-snmp...
dnf -y update
dnf -y install epel-release
dnf -y install net-snmp net-snmp-utils
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
echo Installing default snmp firewall rules for public zone...
firewall-cmd --add-service=snmp --permanent --zone=public
echo Restarting firewall daemon...
firewall-cmd --reload
echo Enabled and starting snmpd...
systemctl start snmpd
systemctl enable snmpd
echo Installing syslog forwarding rule...
cp data/remote.conf /etc/rsyslog.d/remote.conf
systemctl restart rsyslog
echo Syslog forwarding rule installed for GrayLog 10.0.0.7
echo SNMP is configured for snmpv3 user \'admin\' on port 161/udp
echo Please see password.txt and key.txt files for authentication info
