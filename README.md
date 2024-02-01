# The shell script for the installation of Tomcat Server on Ubuntu.

# 1st Step: INSTALL THE TOMCAT SERVER

  Download the tomcat-install.sh
    wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/tomcat-install.sh

  The Tomcat-install script is set to install Tomcat Version 10.0.18 (on port 8080) with Java version 17 as a default settings. But, you can make the necessary changes as per your requirements. To make changes to the main script, edit the "tomcat-install.sh" file and set the desired tomcat install environment elements like (TOMCAT_VERSION, TOMCAT_USER_PASS, TOMCAT_MANAGER_PASS, CUSTOM_TOMCAT_PORT, CUSTOM_JDK_VERSION etc.) and save the file before the run.
  
  Edit the script (Skip this step if you want to install with default settings)
    nano tomcat-install.sh

  Make it executable
    chmod +x tomcat-install.sh

  Run the script
    ./tomcat-install.sh

#Please read the instructions echo on the screen at the end of script, and save the passwords.



# 2nd Step: ENABLE THE TOMCAT MANAGER

  Download the enable-manager.sh
    wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/enable-manager.sh

  Make it executable
    chmod +x enable-manager.sh

  Run the script
    ./enable-manager.sh

# Use the command to start the Tomcat
  tomcat-up

# Use the command to stop the Tomcat
  tomcat-down

  
# The script is developed by PRABHAT RAGHAV prabhat_raghav@outlook.com (https://github.com/prabhatraghav/tomcat-install)
