#!/usr/bin/env bash
set -euo pipefail
sudo lxc delete --force "${1:-sis4-test}"
