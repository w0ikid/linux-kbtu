#!/usr/bin/env bash
set -euo pipefail

install -o root -g root -m 644 "$(dirname "$0")/vikunja.service" /etc/systemd/system/vikunja.service
systemctl daemon-reload
systemctl enable --now vikunja.service
systemctl status vikunja.service --no-pager
