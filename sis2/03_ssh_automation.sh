#!/usr/bin/env bash
set -euo pipefail

PUBKEY_FILE=${1:?usage: $0 <public key file>}
BOT=automation_bot
SSH_DIR=/home/$BOT/.ssh

install -d -o "$BOT" -g "$BOT" -m 700 "$SSH_DIR"
touch "$SSH_DIR/authorized_keys"
grep -qxFf "$PUBKEY_FILE" "$SSH_DIR/authorized_keys" || cat "$PUBKEY_FILE" >> "$SSH_DIR/authorized_keys"
chown "$BOT:$BOT" "$SSH_DIR/authorized_keys"
chmod 600 "$SSH_DIR/authorized_keys"

cat > /etc/ssh/sshd_config.d/10-hardening.conf <<'X'
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AllowGroups ubuntu sysadmin deploy audit automation backup
X

sshd -t
systemctl reload ssh
sshd -T | grep -Ei '^(permitrootlogin|passwordauthentication|pubkeyauthentication|allowgroups) '
