#!/usr/bin/env bash
# SIS3 Task4: smoke test
set -uo pipefail
fail=0
check(){ if eval "$2" >/dev/null 2>&1; then echo "PASS  $1"; else echo "FAIL  $1"; fail=1; fi; }
check "ssh  port 22  open"     "nc -z -w3 127.0.0.1 22"
check "http port 80  open"     "nc -z -w3 127.0.0.1 80"
check "https port 443 open"    "nc -z -w3 127.0.0.1 443"
check "vikunja service active" "systemctl is-active --quiet vikunja"
check "htop installed"         "command -v htop"
check "gh installed"           "command -v gh"
check "yq installed"           "command -v yq"
check "vikunja web responds"   "curl -fsS -o /dev/null http://127.0.0.1:3456"
echo "----"; [ $fail -eq 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit $fail
