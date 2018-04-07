FROM arm32v7/openjdk:8-jre-slim
# COPY qemu-arm-static /usr/bin/

# User, home (app) and data folders
ENV USER jenkins
ENV DATA /data
ENV HOME /usr/src/$USER

ENV JENKINS_HOME $DATA
ENV JENKINS_SLAVE_AGENT_PORT 50000

#RUN apt-get update && \
#    apt-get upgrade && \
#    apt-get install wget && \
#    rm -rf /var/lib/apt/lists/* && \
#    \

# Prepare data and app folder
RUN mkdir -p $DATA && \
    mkdir -p $HOME && \
    \
# Add $USER user so we aren't running as root.
    adduser --home $DATA --no-create-home -gecos '' --disabled-password $USER && \
    chown -R $USER:$USER $HOME && \
    chown -R $USER:$USER $DATA

# wget http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war
COPY jenkins.war $HOME

# Jenkins web interface, connected slave agents
EXPOSE 8080 $JENKINS_SLAVE_AGENT_PORT

# VOLUME $DATA
WORKDIR $DATA

USER $USER

CMD java -jar $HOME/jenkins.war --prefix=$PREFIX
