#!/bin/bash

echo Installing CentOS 7 auto-update and auto-cleanup script...
echo By default, this script will run via crontab at 3AM daily. IT WILL REBOOT AUTOMATICALLY, if required.
echo Logs will be sent to /var/log/auto_update.log

echo WARNING: This script will replace your default root crontab...
echo Press ctl-c to cancel. Starting in 5 seconds...
sleep 6

yum -y update
yum -y install epel-release
yum -y install yum-utils
cp data/auto_update /opt/auto_update
chmod +x /opt/auto_update
cp data/auto_update_cron /root/crontab
crontab /root/crontab

echo The auto-update script and crontab have been installed!
