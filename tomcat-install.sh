#!/bin/bash

# Apache Tomcat Installation Script for Ubuntu 22.04

TOMCAT_VERSION="10.0.18"  # Update the version as needed
TOMCAT_DIR="/opt/tomcat"
TOMCAT_USER="tomcat"
TOMCAT_GROUP="tomcat"
TOMCAT_USER_PASS="tomcat@1"  # Set your desired password or leave empty
TOMCAT_MANAGER_USER="admin"
TOMCAT_MANAGER_PASS="admin@1"  # Change this to a secure password
CUSTOM_TOMCAT_PORT=""       # Leave empty to use default port (8080)
CUSTOM_JDK_VERSION="17"       # Leave empty to use default JDK

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
sudo apt update

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
wget https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
sudo mkdir -p $TOMCAT_DIR
sudo tar -xf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C $TOMCAT_DIR --strip-components=1

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
rm /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Print instructions
echo "Apache Tomcat $TOMCAT_VERSION has been installed to $TOMCAT_DIR"
echo "Tomcat Manager credentials:"
echo "   Username: $TOMCAT_MANAGER_USER"
echo "   Password: $TOMCAT_MANAGER_PASS"
if [ -n "$CUSTOM_TOMCAT_PORT" ]; then
    echo "Tomcat is configured to run on port $CUSTOM_TOMCAT_PORT"
fi
if [ -n "$CUSTOM_JDK_VERSION" ]; then
    echo "Custom JDK $CUSTOM_JDK_VERSION has been installed"
fi
echo "Tomcat user credentials:"
echo "   Username: $TOMCAT_USER"
if [ -n "$TOMCAT_USER_PASS" ]; then
    echo "   Password: $TOMCAT_USER_PASS"
fi
echo "To start Tomcat, run: tomcat-up"
echo "To stop Tomcat, run: tomcat-down"

# To enable Tomcat Manager, replacing the context.xml files
sudo su
wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/enable-manager.sh
chmod +x enable-manager.sh
./enable-manager.sh
