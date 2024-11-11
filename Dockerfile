FROM jenkins/jenkins:lts

USER root
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ansible \
    apt-transport-https \
    ca-certificates \
    gnupg \
    software-properties-common \
    tini \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y docker-ce-cli \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && apt-get install -y nagios-nrpe-server nagios-plugin

ENTRYPOINT ["/usr/bin/tini", "--"]

COPY target/devops-integration.jar /devops-integration.jar

ENTRYPOINT ["java", "-jar", "/devops-integration.jar"]

USER jenkins

