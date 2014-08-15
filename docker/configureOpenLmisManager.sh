#!/bin/sh

if [ -z "$TOMCAT_PASS" ];
then
    echo FATAL ERROR TOMCAT_PASS undefined!!!
    exit 1
fi

if [ -f "/home/openlmis/resetDb.sh" ];
then
    echo Configuring open-lmis-manager...
    sed -i "s/@@@TOMCAT_PASS@@@/$TOMCAT_PASS/g" /home/openlmis/resetDb.sh
else
    echo "open-lmis-manager not found; skipping"
fi
