#!/bin/bash
sudo tomcat-down
sleep 10
sudo rm -r /opt/tomcat/
sudo rm -r /usr/local/bin/tomcat-up
sudo rm -r /usr/local/bin/tomcat-down
echo "Tomact removed successfully from the machine"
sudo rm -r tomcat-remove.sh
