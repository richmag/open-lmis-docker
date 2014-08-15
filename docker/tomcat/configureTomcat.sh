#/bin/sh

if [ -z "$TOMCAT_PASS" ];
then
    echo TOMCAT_PASS not set!!!
    exit 1
fi

if [ -z "$TOMCAT_HOME" ];
then
    echo TOMCAT_HOME not set!!!
    exit 1
fi


sed "s/@@@TOMCAT_PASS@@@/$TOMCAT_PASS/g" $TOMCAT_HOME/conf/tomcat-users.xml.template \
    > $TOMCAT_HOME/conf/tomcat-users.xml
echo $TOMCAT_PASS > $TOMCAT_HOME/TOMCAT_PASS.txt  # in-case open-lmis-manager is present

echo "**********************************************************************"
echo "****	TOMCAT PASSWORD IS:				        ****"
echo "****	$TOMCAT_PASS						****"
echo "**********************************************************************"
