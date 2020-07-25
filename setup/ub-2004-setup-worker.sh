#!/bin/bash

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
    docker-ce-cli=$DOCKER_VERSION 

 # Set up the Docker daemon
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart Docker
systemctl daemon-reload
systemctl restart docker
sudo systemctl enable docker

cat > /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system


# (Install containerd)
## Set up the repository
### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common

## Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

## Install containerd
apt-get update && apt-get install -y containerd.io

# Configure containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml

# Restart containerd
systemctl restart containerd


# # install Kubeadm etc.
# # Note - Bionic packages not available yet
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
# deb https://apt.kubernetes.io/ kubernetes-xenial main
# EOF

# apt-get update
# apt-get install -y \
#     kubelet=$KUBERNETES_VERSION \
#     kubeadm=$KUBERNETES_VERSION \
#     kubectl=$KUBERNETES_VERSION

# # set iptables for Flannel
# sysctl net/bridge/bridge-nf-call-ip6tables = 1
# sysctl net/bridge/bridge-nf-call-iptables = 1
# sysctl net/bridge/bridge-nf-call-arptables = 1