#!/usr/bin/env bash
# Creates a clean Ubuntu 22.04 instance with LXD on the host and prints its IP.
# The Oracle Ampere VM has no /dev/kvm, so a system container is used instead of
# a full VM: same cloud image, its own systemd, network and SSH server.
set -euo pipefail

NAME=${1:-sis4-test}
IMAGE=${IMAGE:-ubuntu:22.04}
PUBKEY=${PUBKEY:-$HOME/.ssh/sis4_ansible.pub}

[[ -f $PUBKEY ]] || ssh-keygen -t ed25519 -N '' -C sis4-ansible -f "${PUBKEY%.pub}"

if ! sudo lxc storage show default >/dev/null 2>&1; then
    sudo lxd init --auto --storage-backend=btrfs --storage-create-loop=25
fi

# Docker sets FORWARD to DROP and the Oracle image rejects unknown INPUT,
# so LXD bridge traffic has to be allowed explicitly (runtime rules only).
sudo iptables -C DOCKER-USER -i lxdbr0 -j ACCEPT 2>/dev/null || sudo iptables -I DOCKER-USER -i lxdbr0 -j ACCEPT
sudo iptables -C DOCKER-USER -o lxdbr0 -j ACCEPT 2>/dev/null || sudo iptables -I DOCKER-USER -o lxdbr0 -j ACCEPT
sudo iptables -C INPUT -i lxdbr0 -j ACCEPT 2>/dev/null || sudo iptables -I INPUT 1 -i lxdbr0 -j ACCEPT

sudo lxc delete --force "$NAME" 2>/dev/null || true
sudo lxc launch "$IMAGE" "$NAME" \
    -c security.nesting=true \
    -c security.syscalls.intercept.mknod=true \
    -c security.syscalls.intercept.setxattr=true \
    -c user.user-data="#cloud-config
ssh_authorized_keys:
  - $(cat "$PUBKEY")"

sudo lxc exec "$NAME" -- cloud-init status --wait >/dev/null
IP=$(sudo lxc list "$NAME" -c 4 --format csv | awk '{print $1}')
echo "$NAME ready at $IP"
