#!/bin/bash

DOCKER_VERSION="5:19.03.12~3-0~ubuntu-focal"
KUBERNETES_VERSION="1.18.6-00"

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

