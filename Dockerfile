FROM joshzamor/openlmis_base
MAINTAINER Josh Zamor <josh.zamor@villagereach.org>

RUN yum install -y vim

# configure postgres server
ENV PGPASSWORD p@ssw0rd
RUN ln -s /etc/init.d/postgresql-9.2 /etc/init.d/postgresql && \
    service postgresql initdb && \
    service postgresql start && \
    su -c "psql --command \"ALTER USER postgres WITH password 'p@ssw0rd'\"" postgres && \
    echo "listen_addresses='*'" >> /var/lib/pgsql/9.2/data/postgresql.conf
ADD docker/postgres/pg_hba.conf /var/lib/pgsql/9.2/data/pg_hba.conf

# get tomcat
ADD docker/tomcat/tomcat.sh /etc/init.d/tomcat
RUN chmod u+x /etc/init.d/tomcat && \
    useradd openlmis && \
    cd /home/openlmis && \
    wget http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.55/bin/apache-tomcat-7.0.55.tar.gz && \
    tar -xvzf apache-tomcat-7.0.55.tar.gz && \
    rm apache-tomcat-7.0.55.tar.gz && \
    ln -s apache-tomcat-7.0.55 apache-tomcat && \
    chown -R openlmis:openlmis apache-tomcat-7.0.55
ENV TOMCAT_HOME /home/openlmis/apache-tomcat/
ADD docker/tomcat/server.xml /home/openlmis/apache-tomcat/conf/
ADD docker/tomcat/tomcat-users.xml.template $TOMCAT_HOME/conf/
ADD docker/tomcat/configureTomcat.sh $TOMCAT_HOME/
RUN chmod u+x $TOMCAT_HOME/configureTomcat.sh

# build OpenLMIS
ENV PATH /home/openlmis/gradle-1.12/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/jre/
ADD open-lmis/ /home/openlmis/open-lmis/
RUN service postgresql start && \
    cd /home/openlmis && \
    wget https://services.gradle.org/distributions/gradle-1.12-bin.zip && \
    unzip gradle-1.12-bin.zip && \
    chown -R openlmis:openlmis gradle-1.12 && \
    rm -f gradle-1.12-bin.zip && \
    cd open-lmis && \
    gradle clean setupdb seed build testseed && \
    gradle setupdb && \
    chown openlmis:openlmis modules/openlmis-web/build/libs/openlmis-web.war && \
    cd .. && \
    rm -Rf apache-tomcat/webapps/ROOT* && \
    cp open-lmis/modules/openlmis-web/build/libs/openlmis-web.war apache-tomcat/webapps/ROOT.war

# deploy OpenLMIS-Manager
USER root
ADD open-lmis-manager /open-lmis-manager
ADD docker/deployOpenLmisManager.sh /deployOpenLmisManager.sh
ADD docker/configureOpenLmisManager.sh /configureOpenLmisManager.sh
WORKDIR /
RUN /bin/sh deployOpenLmisManager.sh && \
    chmod u+x configureOpenLmisManager.sh
    
# deploy db
USER root
ADD db /open-lmis-db
WORKDIR /open-lmis-db
RUN service postgresql start && \
    /bin/sh loadDb.sh

# Ports for tomcat (8080) and postgresql (5432)
EXPOSE 8080 5432 

# set command to run on container start
USER root
ADD docker/start.sh /sbin/start.sh
RUN chmod u+x /sbin/start.sh
CMD ["/sbin/start.sh"]
