FROM jenkins/jenkins:lts

# Exécuter les commandes en tant qu'utilisateur root
USER root

# Mise à jour et installation des dépendances de base
RUN apt-get update && apt-get install -y \
    curl \
    git \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Installation de Docker CLI
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli

# Installation de kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Installation d'Ansible
RUN apt-get update && apt-get install -y ansible

# Installation de Nagios et des plugins NRPE
RUN apt-get update && apt-get install -y \
    nagios-nrpe-server \
    nagios-plugins

# Nettoyer le cache APT pour réduire la taille de l'image
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Retourner à l'utilisateur Jenkins pour l'exécution par défaut
USER jenkins

# Exposer le port Jenkins par défaut
EXPOSE 8080

