#!/usr/bin/env bash
set -euo pipefail

COMPOSE=/opt/vikunja/docker-compose.yml
if ! grep -q '^    user:' "$COMPOSE"; then
    sed -i "/^    container_name: vikunja$/a\\    user: \"$(id -u vikunja):$(id -g vikunja)\"" "$COMPOSE"
fi

install -o root -g root -m 644 "$(dirname "$0")/vikunja.service" /etc/systemd/system/vikunja.service
systemctl daemon-reload
systemctl enable --now vikunja.service
systemctl status vikunja.service --no-pager
