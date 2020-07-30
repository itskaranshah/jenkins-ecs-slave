FROM centos:latest

ARG VERSION=4.4
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="$version"
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}
ARG AGENT_WORKDIR=/home/${user}/agent
RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar
USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

USER root
#RUN dnf install -y https://github.com/PowerShell/PowerShell/releases/download/v7.0.2/powershell-lts-7.0.2-1.centos.8.x86_64.rpm
COPY powershell-lts-7.0.2-1.centos.8.x86_64.rpm /tmp/powershell-lts-7.0.2-1.centos.8.x86_64.rpm
#RUN curl https://raw.githubusercontent.com/jenkinsci/docker-inbound-agent/master/jenkins-agent --output /usr/local/bin/jenkins-agent
COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN dnf update -y && dnf install -y java-11-openjdk-devel && dnf install -y python3-pip && dnf install -y tar && dnf install -y gzip && dnf install -y zip && dnf install -y unzip &&\
    dnf localinstall -y /tmp/powershell-lts-7.0.2-1.centos.8.x86_64.rpm && dnf install git -y && chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

USER ${user}
RUN pip3 install awscli --upgrade --user

ENTRYPOINT ["jenkins-agent"]
