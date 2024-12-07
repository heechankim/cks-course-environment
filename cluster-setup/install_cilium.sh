#!/bin/bash

# Install CNI plugins
git clone https://github.com/containernetworking/plugins.git
cd ~/plugins
./build_linux.sh
sudo cp bin/* /opt/cni/bin/

# Install Cilium
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

# Cilium-Calico Chaining
kubectl apply -f https://raw.githubusercontent.com/heechankim/cks-course-environment/refs/heads/v1.31-ubuntu2204-cilium/cluster-setup/cilium-chaining.yaml

cilium install \
  --set cni.chainingMode=generic-veth \
  --set cni.customConf=true \
  --set cni.configMap=cni-configuration \
  --set routingMode=native \
  --set enableIPv4Masquerade=false \
  --set enableIdentityMark=false