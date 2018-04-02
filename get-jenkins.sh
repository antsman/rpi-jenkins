#!/bin/bash

# get Jenkins
wget -nc http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war

# get Jenkins version
export JENKINS_VERSION=$(unzip -p jenkins.war META-INF/MANIFEST.MF | grep Jenkins-Version | awk '{print $2}')
echo Jenkins-Version: $JENKINS_VERSION

# get qemu-arm-static - using with Travis
wget -nc https://github.com/multiarch/qemu-user-static/releases/download/v2.11.0/qemu-arm-static && chmod +x qemu-arm-static
