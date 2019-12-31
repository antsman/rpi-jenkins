FROM arm32v7/openjdk:8-jre-slim
# COPY qemu-arm-static /usr/bin/

# User, home (app) and data folders
ARG USER=jenkins
ARG DATA=/data
ENV HOME=/usr/src/$USER

ENV JENKINS_HOME $DATA
ENV JENKINS_SLAVE_AGENT_PORT 50000

# Extra runtime packages
RUN apt-get update && \
    apt-get install -y -qq \
      git wget time procps && \
    rm -rf /var/lib/apt/lists/*

ARG DOCKER_GROUP_ID=995
ARG DOCKER_GROUP_NAME=docker

# Prepare data and app folder
RUN mkdir -p $DATA && \
    mkdir -p $HOME && \
# Add $USER user so we aren't running as root.
    adduser --home $DATA --no-create-home -gecos '' --disabled-password $USER && \
    chown -R $USER:$USER $HOME && \
    chown -R $USER:$USER $DATA && \
# Add $USER to docker group, same guid as pi on host
    groupadd -g $DOCKER_GROUP_ID $DOCKER_GROUP_NAME && \
    usermod -aG $DOCKER_GROUP_NAME $USER

# wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
COPY jenkins.war $HOME
COPY docker /usr/local/bin/
COPY entrypoint.sh /

# Jenkins web interface, connected slave agents
EXPOSE 8080 $JENKINS_SLAVE_AGENT_PORT

# VOLUME $DATA
WORKDIR $DATA

USER $USER

# exec java -jar $HOME/jenkins.war --prefix=$PREFIX
ENTRYPOINT [ "/entrypoint.sh" ]
