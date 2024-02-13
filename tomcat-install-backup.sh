#!/bin/bash

# Apache Tomcat Installation Script for Ubuntu 22.04

TOMCAT_MAIN_VERSION="11"  # Update the Main-Version if needed (Please update the "Latest-Release" also if you updated the "Main-Version")
TOMCAT_LATEST_RELEASE="11.0.0-M16"  # Update the latest release version if needed
TOMCAT_DIR="/opt/tomcat"
TOMCAT_USER="tomcat"
TOMCAT_GROUP="tomcat"
TOMCAT_USER_PASS="tomcat"  # Set your desired password or leave empty
TOMCAT_MANAGER_USER="admin"
TOMCAT_MANAGER_PASS="admin"  # Change this to a strong secure password
CUSTOM_TOMCAT_PORT=""       # Leave empty to use default port (8080)
CUSTOM_JDK_VERSION="17"       # Leave empty to use default JDK
PUBLIC_IP_ADDR=`curl -s http://whatismyip.akamai.com/`
LINE_BORDER_EQ="==========================================================="
LINE_BORDER_HASH="####################################################################"

# Backup function
backup_file() {
    local file=$1
    local backup_file="$file.backup"
    if [ -e "$file" ]; then
        sudo cp "$file" "$backup_file"
        echo "Backup created: $backup_file"
    fi
}

# Update and install prerequisites
sudo apt update -y
sudo apt install toilet -y

# Install custom JDK if specified
if [ -n "$CUSTOM_JDK_VERSION" ]; then
    sudo apt install -y openjdk-$CUSTOM_JDK_VERSION-jdk
else
    sudo apt install -y default-jdk
fi

# Create Tomcat user and group with password
sudo groupadd $TOMCAT_GROUP
sudo useradd -s /bin/false -m -d $TOMCAT_DIR -g $TOMCAT_GROUP $TOMCAT_USER

# Set password for Tomcat user if specified
if [ -n "$TOMCAT_USER_PASS" ]; then
    echo "$TOMCAT_USER:$TOMCAT_USER_PASS" | sudo chpasswd
fi

# Download and extract Apache Tomcat
cd /tmp
wget https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAIN_VERSION}/v${TOMCAT_LATEST_RELEASE}/bin/apache-tomcat-${TOMCAT_LATEST_RELEASE}.tar.gz
sudo mkdir -p $TOMCAT_DIR
sudo tar -xf apache-tomcat-${TOMCAT_LATEST_RELEASE}.tar.gz -C $TOMCAT_DIR --strip-components=1

# Set permissions and create backups
backup_file "$TOMCAT_DIR/conf/server.xml"
backup_file "$TOMCAT_DIR/conf/tomcat-users.xml"
sudo chgrp -R $TOMCAT_GROUP $TOMCAT_DIR
sudo chmod -R g+r $TOMCAT_DIR/conf
sudo chmod g+x $TOMCAT_DIR/conf
sudo chown -R $TOMCAT_USER:$TOMCAT_GROUP $TOMCAT_DIR/webapps/ $TOMCAT_DIR/work/ $TOMCAT_DIR/temp/ $TOMCAT_DIR/logs/

# Configure Tomcat Manager credentials with various roles
sudo sed -i '/<\/tomcat-users>/i \
<role rolename="manager-gui"\/>\
<role rolename="manager-script"\/>\
<role rolename="manager-jmx"\/>\
<role rolename="manager-status"\/>\
<role rolename="admin-gui"\/>\
<role rolename="admin-script"\/>\
<user username="'$TOMCAT_MANAGER_USER'" password="'$TOMCAT_MANAGER_PASS'" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script"\/>' $TOMCAT_DIR/conf/tomcat-users.xml

# Configure Tomcat port if specified
if [ -n "$CUSTOM_TOMCAT_PORT" ]; then
    sudo sed -i 's/port="8080"/port="'$CUSTOM_TOMCAT_PORT'"/' $TOMCAT_DIR/conf/server.xml
fi

# Create tomcat-up script
echo "#!/bin/bash" | sudo tee /usr/local/bin/tomcat-up
echo "sudo -u $TOMCAT_USER $TOMCAT_DIR/bin/startup.sh" | sudo tee -a /usr/local/bin/tomcat-up
sudo chmod +x /usr/local/bin/tomcat-up

# Create tomcat-down script
echo "#!/bin/bash" | sudo tee /usr/local/bin/tomcat-down
echo "sudo -u $TOMCAT_USER $TOMCAT_DIR/bin/shutdown.sh" | sudo tee -a /usr/local/bin/tomcat-down
sudo chmod +x /usr/local/bin/tomcat-down

# Clean up
rm /tmp/apache-tomcat-${TOMCAT_LATEST_RELEASE}.tar.gz

# To enable Tomcat Manager, replacing the context.xml files
cd /home
sudo wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/enable-manager.sh
sudo chmod +x enable-manager.sh
sudo sh enable-manager.sh

# Print instructions
echo " "
echo "$LINE_BORDER_HASH"
echo "   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _  
  / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ 
 ( P | R | A | B | H | A | T | - | R | A | G | H | A | V | ' | s )
  \_/ \_/_\_/_\_/_\_/_\_/_\_/_\_/_\_/_\_/_\_/_\_/_\_/_\_/_\_/ \_/ 
        / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \       
       ( T | o | m | c | a | t | - | S | c | r | i | p | t )      
        \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/       "
echo " "
echo "$LINE_BORDER_HASH"
echo " "
echo "┳  ┳┓  ┏┓  ┏┳┓  ┳┓  ┳┳  ┏┓  ┏┳┓  ┳  ┏┓  ┳┓  ┏┓   
┃  ┃┃  ┗┓   ┃   ┣┫  ┃┃  ┃    ┃   ┃  ┃┃  ┃┃  ┗┓  •
┻  ┛┗  ┗┛   ┻   ┛┗  ┗┛  ┗┛   ┻   ┻  ┗┛  ┛┗  ┗┛  •"
echo "$LINE_BORDER_EQ"
echo "1. Tomcat $TOMCAT_LATEST_RELEASE has been installed to dir $TOMCAT_DIR"
if [ -n "$CUSTOM_TOMCAT_PORT" ]; then
    echo "2. Tomcat can be accessed from url: http://$PUBLIC_IP_ADDR:$CUSTOM_TOMCAT_PORT"
    else echo "2. Tomcat can be accessed from url: http://$PUBLIC_IP_ADDR:8080"
fi
if [ -n "$CUSTOM_JDK_VERSION" ]; then
    echo "3. Custom JDK $CUSTOM_JDK_VERSION has been installed"
fi
echo "4. Tomcat Manager credentials are:"
echo "     Username: $TOMCAT_MANAGER_USER"
if [ -n "$TOMCAT_MANAGER_PASS" ]; then
    echo "     Password: $TOMCAT_MANAGER_PASS"
    else echo "     Password: *Not Configured* (Please configure strong secure password)"
fi
echo "5. Tomcat user credentials:"
echo "     Username: $TOMCAT_USER"
if [ -n "$TOMCAT_USER_PASS" ]; then
    echo "     Password: $TOMCAT_USER_PASS"
    else echo "     Password: **Not Configured**"
fi
echo "6. Tomcat Commands:"
echo "    Run to start the server : tomcat-up"
echo "    Run to stop the server  : tomcat-down"
echo "$LINE_BORDER_EQ"

# Removing downloaded shell scripts from /home dir
cd /home
sudo rm -r enable-manager.sh
sudo rm -r tomcat-install.sh
