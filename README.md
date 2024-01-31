# FIRST, INSTALL THE TOMCAT SERVER

  # download the tomcat-install.sh
    wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/tomcat-install.sh

  # edit the tomcat-install.sh script, and set the desiserd tomcat install ENVIR like (TOMCAT_VERSION, TOMCAT_USER_PASS, TOMCAT_MANAGER_PASS, CUSTOM_TOMCAT_PORT, CUSTOM_JDK_VERSION etc.) and save the file.
    nano tomcat-install.sh

  # make it executable
    chmod +x tomcat-install.sh

  # run the script
    ./tomcat-install.sh

# NOW, AFTER INSTALL ENABLE THE TOMCAT MANAGER

  # download the enable-manager.sh
    wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/enable-manager.sh

  # make it executable
    chmod +x enable-manager.sh

  # run the script
    ./enable-manager.sh
