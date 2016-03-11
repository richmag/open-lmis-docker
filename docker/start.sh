#!/bin/sh

# generate tomcat password if not set
if [ -z "$TOMCAT_PASS" ];
then
    echo Tomcat pass not set, generating...
    export TOMCAT_PASS=`pwgen 8 1`
else
    echo TOMCAT_PASS set, using...
fi

# configure tomcat
if [ -z "$TOMCAT_HOME" ];
then
    echo FATAL ERROR TOMCAT_HOME not set!!!
    exit 1
fi
$TOMCAT_HOME/configureTomcat.sh

# configure open-lmis-manager
/configureOpenLmisManager.sh

service postgresql start
su - openlmis -c "export JAVA_HOME=/opt/java/jdk1.7.0_55/;export JAVA_OPTS='-XX:MaxPermSize=256M -DenvironmentName=local -DdefaultLocale=en';/home/openlmis/apache-tomcat/bin/startup.sh"

echo OpenLMIS container now running

while true
do
    sleep 1;
done
