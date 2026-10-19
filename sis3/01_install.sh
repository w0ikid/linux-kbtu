#!/usr/bin/env bash
# SIS3 Task1: install packages 3 ways
set -euo pipefail

echo "== 1) default apt repo: htop =="
sudo apt-get update -y
sudo apt-get install -y htop

echo "== 2) new apt repo: GitHub CLI (gh) =="
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
sudo apt-get update -y
sudo apt-get install -y gh

echo "== 3) NOT apt: static binary yq =="
YQ_VER=v4.44.3
sudo curl -fsSL -o /usr/local/bin/yq \
  "https://github.com/mikefarah/yq/releases/download/${YQ_VER}/yq_linux_$(dpkg --print-architecture)"
sudo chmod +x /usr/local/bin/yq

echo "== verify =="
htop --version | head -1
gh --version | head -1
yq --version
