# FIRST, INSTALL THE TOMCAT SERVER

  # Download the tomcat-install.sh
    wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/tomcat-install.sh

  # Edit the tomcat-install.sh script, and set the desiserd tomcat install ENVIR like (TOMCAT_VERSION, TOMCAT_USER_PASS, TOMCAT_MANAGER_PASS, CUSTOM_TOMCAT_PORT, CUSTOM_JDK_VERSION etc.) and save the file.
    nano tomcat-install.sh

  # Make it executable
    chmod +x tomcat-install.sh

  # Run the script
    ./tomcat-install.sh

# NOW, AFTER INSTALL ENABLE THE TOMCAT MANAGER

  # Download the enable-manager.sh
    wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/enable-manager.sh

  # Make it executable
    chmod +x enable-manager.sh

  # Run the script
    ./enable-manager.sh



# The script is developed by PRABHAT RAGHAV (https://github.com/prabhatraghav/tomcat-install)
