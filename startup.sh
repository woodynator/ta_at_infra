#!/bin/bash 
# I'm using this script to set install and start Jenkins after instance is deployed.

yum -y update
 
yum install -y yum-utils

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum -y install docker-ce docker-ce-cli containerd.io

systemctl start docker

docker pull jenkins/jenkins

mkdir /var/jenkins_home

docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins
