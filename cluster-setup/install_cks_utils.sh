#!/bin/bash

# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin latest

# Install Kubesec
mkdir ~/kubesec && cd ~/kubesec
curl -L https://github.com/controlplaneio/kubesec/releases/download/v2.14.2/kubesec_linux_amd64.tar.gz > kubesec_linux_amd64.tar.gz
tar -xzf kubesec_linux_amd64.tar.gz
mv kubesec /usr/local/bin/
kubesec version
cd ~
rm -rf ~/kubesec

# Install KubeLinter
mkdir ~/kube-linter && cd ~/kube-linter
curl -L https://github.com/stackrox/kube-linter/releases/download/v0.7.1/kube-linter-linux.tar.gz > kube-linter-linux.tar.gz
tar -xzf kube-linter-linux.tar.gz
mv kube-linter /usr/local/bin/
kube-linter version
cd ~
rm -rf ~/kube-linter

# Install bom
curl -L https://github.com/kubernetes-sigs/bom/releases/download/v0.6.0/bom-amd64-linux > bom-amd64-linux
chmod +x bom-amd64-linux
mv bom-amd64-linux /usr/local/bin/bom

# Install Kube-bench
curl -L https://github.com/aquasecurity/kube-bench/releases/download/v0.9.2/kube-bench_0.9.2_linux_amd64.deb -o kube-bench_0.9.2_linux_amd64.deb
apt install ./kube-bench_0.9.2_linux_amd64.deb -f
rm kube-bench_0.9.2_linux_amd64.deb

# Install Falco
curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | \
sudo gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main" | \
sudo tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get install apt-transport-https
apt-get update -y
apt install -y dkms make linux-headers-$(uname -r)
apt install -y clang llvm
FALCO_FRONTEND=noninteractive apt-get install -y falco