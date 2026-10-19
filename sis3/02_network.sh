#!/usr/bin/env bash
# SIS3 Task2: network map (ips, connections, ports)
set -euo pipefail
echo "== interfaces =="; ip -brief addr
echo; echo "== routes =="; ip route
echo; echo "== listening ports =="; sudo ss -tulpn | grep LISTEN
echo; echo "== public ip =="; curl -fsSL ifconfig.me || true; echo
