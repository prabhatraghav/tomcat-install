# The shell script for the installation of Tomcat Server on Ubuntu/Debian

# Run the below commands step-wise one-by-one to install the Tomcat Server

  # 1. Become the root (mandatory)
    sudo su
  
  # 2. Change dir to /home
    cd /home
  
  # 3. Download the tomcat-install.sh
    wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/tomcat-install.sh

  The Tomcat-install script is set to install Tomcat Version 10.0.18 (on port 8080) with Java version 17 as a default settings. But, you can make the necessary changes as per your requirements. To make changes to the main script, edit the "tomcat-install.sh" file and set the desired tomcat install environment elements like (TOMCAT_VERSION, TOMCAT_USER_PASS, TOMCAT_MANAGER_PASS, CUSTOM_TOMCAT_PORT, CUSTOM_JDK_VERSION etc.) and save the file before the run.
  
  # Edit the script (Skip this step if you want to install with default settings)
    nano tomcat-install.sh

  # 4. Make it executable
    chmod +x tomcat-install.sh

  # 5. Run the script
    ./tomcat-install.sh

# Please read the instructions carefully, echoed on the screen at the end of this script, and save the tomcat-user and manager passwords.

# 6. Now, exit from the root is also mandatory
    exit

# 7. Use the command to start the Tomcat
    tomcat-up

# 8. Use the command to stop the Tomcat
    tomcat-down

  
This script is developed by PRABHAT RAGHAV prabhat_raghav@outlook.com
(https://github.com/prabhatraghav/tomcat-install)
