FROM centos:centos6
MAINTAINER Josh Zamor <josh.zamor@villagereach.org>

# install packages
RUN rpm -Uvh http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-5.noarch.rpm && \
    yum update -y && \
    yum reinstall -y glibc-common  && \ 
    yum install -y postgresql92-server postgresql92-contrib && \
    yum install -y java-1.7.0-openjdk java-1.7.0-openjdk-devel && \
    yum install -y tar bzip2 unzip wget && \
    rpm --import https://fedoraproject.org/static/0608B895.txt && \
    rpm -Uvh http://download-i2.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && \
    yum install -y --enablerepo=centosplus nodejs npm && \
    yum install -y pwgen && \
    npm install -g grunt-cli && \
    yum clean all
