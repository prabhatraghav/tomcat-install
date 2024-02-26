#!/bin/bash
sudo tomcat-down
sleep 10
sudo rm -r /opt/tomcat/
cd /usr/local/bin/
sudo rm -r tomcat-up
sudo rm -r tomcat-down
echo "Tomact removed successfully from the machine"
cd /home
sudo rm -r tomcat-remove.sh
