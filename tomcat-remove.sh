#!/bin/bash
sudo tomcat-down
sleep 5
sudo rm -r /opt/tomcat/
echo "Tomact removed successfully from the machine"
sudo rm -r tomcat-remove.sh
