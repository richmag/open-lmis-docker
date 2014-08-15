#!/bin/sh

cd open-lmis-manager/

if [ -r gradlew ];
then
    echo Building Open-LMIS-Manager
    /bin/sh gradlew clean build
    echo Deploying Open-LMIS-Manager
    cp -f build/libs/open-lmis-manager*.war /home/openlmis/apache-tomcat/webapps/open-lmis-manager.war
    cp -f bin/resetDb.sh /home/openlmis/
    chown openlmis:openlmis /home/openlmis/resetDb.sh
    chmod u+x /home/openlmis/resetDb.sh
    ln -s /open-lmis-db/open_lmis.custom /home/openlmis/open_lmis.custom
    echo Open-LMIS-Manager deployed
else
    echo "Open-LMIS-Manager not found; skipping"
fi
