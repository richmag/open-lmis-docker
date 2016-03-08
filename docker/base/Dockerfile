FROM centos:centos6
MAINTAINER Josh Zamor <josh.zamor@villagereach.org>

# install packages
RUN rpm -Uvh http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-5.noarch.rpm && \
    yum update -y && \
    yum reinstall -y glibc-common  && \ 
    yum install -y postgresql92-server postgresql92-contrib && \
    yum install -y tar bzip2 unzip wget which git && \
    yum install -y epel-release && \
    rpm --import https://fedoraproject.org/static/0608B895.txt && \
    yum install -y pwgen && \
    yum clean all

RUN  mkdir /opt/java && \
    cd /opt/java && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.tar.gz && \
    tar -xvzf jdk-7u55-linux-x64.tar.gz
ENV JAVA_HOME /opt/java/jdk1.7.0_55/
ENV PATH $PATH:/opt/java/jdk1.7.0_55/bin

# install node, npm and grunt command line tools
ENV PATH $PATH:/node-v0.10.33-linux-x64/bin
RUN curl -L http://nodejs.org/dist/v0.10.33/node-v0.10.33-linux-x64.tar.gz | tar -xvz && \
    git clone https://github.com/npm/npm.git && \
    cd npm && \
    make && \
    make install && \
    npm install -g grunt-cli
