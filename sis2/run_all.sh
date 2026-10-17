#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
bash 01_groups_users.sh
bash 02_permissions.sh
bash 03_ssh_automation.sh "${1:?public key file}"
bash 04_systemd_service.sh
