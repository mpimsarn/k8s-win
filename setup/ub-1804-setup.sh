#!/bin/bash

# DOCKER_VERSION="5:19.03.0~3-0~ubuntu-bionic"
# KUBERNETES_VERSION="1.15.1-00"

DOCKER_VERSION="5:19.03.12~3-0~ubuntu-focal"
KUBERNETES_VERSION="1.18.6-00"

# turn off swap - for the Kubelet
swapoff -a 
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

# install Docker 18.09 (https://docs.docker.com/install/linux/docker-ce/ubuntu/)
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -y \
    docker-ce=$DOCKER_VERSION \
    docker-ce-cli=$DOCKER_VERSION \
    containerd.io

# install Kubeadm etc.
# Note - Bionic packages not available yet
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y \
    kubelet=$KUBERNETES_VERSION \
    kubeadm=$KUBERNETES_VERSION \
    kubectl=$KUBERNETES_VERSION

# set iptables for Flannel
sysctl net/bridge/bridge-nf-call-ip6tables = 1
sysctl net/bridge/bridge-nf-call-iptables = 1
sysctl net/bridge/bridge-nf-call-arptables = 1