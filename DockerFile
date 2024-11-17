FROM jenkins/jenkins:lts

USER root
RUN apt-get update && apt-get install -y \
    curl \
    git \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

RUN apt-get update && apt-get install -y ansible

RUN apt-get update && apt-get install -y \
    nagios-nrpe-server \
    nagios-plugins

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER jenkins

EXPOSE 8080

