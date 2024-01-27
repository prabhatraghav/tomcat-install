cd /opt/tomcat/webapps/manager/META-INF
wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/manager.xml
mv context.xml backup.context.xml
mv manager.xml context.xml

cd /opt/tomcat/webapps/host-manager/META-INF
wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/host-manager.xml
mv context.xml backup.context.xml
mv host-manager.xml context.xml

cd /opt/tomcat/webapps/examples/META-INF
wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/examples.xml
mv context.xml backup.context.xml
mv examples.xml context.xml

cd /opt/tomcat/webapps/docs/META-INF
wget https://raw.githubusercontent.com/prabhatraghav/tomcat-install/main/docs.xml
mv context.xml backup.context.xml
mv docs.xml context.xml