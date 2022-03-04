#!/bin/bash 
# I'm using this script to set install and start Jenkins after instance is deployed.


yum update -y

amazon-linux-extras  -y install docker

service docker start

systemctl enable docker

systemctl start docker

usermod -a -G docker ec2-user

docker pull jenkins/jenkins

mkdir /var/jenkins_home

docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins
