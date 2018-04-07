#!/bin/bash

# get Jenkins
wget -nc -nv http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war

# get Jenkins version
JENKINS_VERSION=$(unzip -p jenkins.war META-INF/MANIFEST.MF | grep Jenkins-Version | awk '{printf $2}'| tr -d '\r')
# echo Jenkins-Version: $JENKINS_VERSION
echo JENKINS_VERSION=\"$JENKINS_VERSION\" | tee env.properties

# get qemu-arm-static - using with Travis
wget -nc -nv https://github.com/multiarch/qemu-user-static/releases/download/v2.11.0/qemu-arm-static && chmod +x qemu-arm-static
