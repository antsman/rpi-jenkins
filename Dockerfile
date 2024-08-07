FROM debian:bookworm-slim

# User, home (app) and data folders
ARG USER=jenkins
ARG DATA=/data
ENV HOME /usr/src/$USER
ENV JAVA_HOME /usr/lib/jvm/default-java

# Match the guid as on host
ARG DOCKER_GROUP_ID=995
ARG DOCKER_GROUP_NAME=docker

ENV JENKINS_HOME $DATA
ENV JENKINS_WEB_PORT 8080
ENV JENKINS_SLAVE_PORT 50000

RUN apt-get update && \
# Add Docker's official GPG key:
    apt-get install ca-certificates curl -y -qq --no-install-recommends && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
# Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
# Install docker cli and buildx
    apt-get update && \
    apt-get install -y -qq --no-install-recommends \
      docker-ce-cli docker-buildx-plugin && \
# Install Java & extra runtime packages
    apt-get install -y -qq --no-install-recommends \
      ca-certificates-java && \
    apt-get install -y -qq --no-install-recommends \
      openjdk-17-jre-headless \
      git ssh wget time procps && \
# Clean up apt
    rm -rf /var/lib/apt/lists/* && \
# Prepare data and app folder
    mkdir -p $DATA && \
    mkdir -p $HOME && \
# Add $USER user so we aren't running as root
    adduser --home $DATA --no-create-home -gecos '' --disabled-password $USER && \
    chown -R $USER:$USER $HOME && \
    chown -R $USER:$USER $DATA && \
# Add $USER to docker group, same guid as pi on host
    groupadd -g $DOCKER_GROUP_ID $DOCKER_GROUP_NAME && \
    usermod -aG $DOCKER_GROUP_NAME $USER

# wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
COPY jenkins.war $HOME
COPY entrypoint.sh /

# Jenkins web interface, connected slave agents
EXPOSE $JENKINS_WEB_PORT $JENKINS_SLAVE_PORT

# VOLUME $DATA
WORKDIR $DATA

USER $USER

# exec java -jar $HOME/jenkins.war --prefix=$PREFIX
ENTRYPOINT [ "/entrypoint.sh" ]
