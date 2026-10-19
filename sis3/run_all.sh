#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
bash 01_install.sh
bash 02_network.sh
# 03_firewall.sh run manually (SSH lockout risk)
bash 04_smoke_test.sh
