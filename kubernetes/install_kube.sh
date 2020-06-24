#!/bin/bash

USER=`whoami`
if [ "$USER" != "root" ]; then
    echo ERROR: Run this script using sudo
    exit 1
fi

apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main" | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update

# install kubernetes controller
apt-get install -y kubectl

# install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
mkdir -p /usr/local/bin/
install minikube /usr/local/bin/
rm minikube
