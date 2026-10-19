#!/usr/bin/env bash
# SIS3 Task3: ufw rules. SSH allowed FIRST to avoid lockout.
set -euo pipefail
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp      # SSH FIRST
sudo ufw allow 80/tcp      # HTTP (caddy)
sudo ufw allow 443/tcp     # HTTPS (caddy)
sudo ufw --force enable
sudo ufw status verbose
