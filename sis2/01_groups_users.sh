#!/usr/bin/env bash
set -euo pipefail

ROLE_GROUPS=(sysadmin deploy audit automation backup)

declare -A USERS=(
    [sysadmin1]="sysadmin"
    [devops1]="deploy"
    [auditor1]="audit,adm,systemd-journal"
    [automation_bot]="automation"
    [backup_op]="backup"
)

for g in "${ROLE_GROUPS[@]}"; do
    getent group "$g" >/dev/null || groupadd "$g"
done

for u in "${!USERS[@]}"; do
    id -u "$u" >/dev/null 2>&1 || useradd -m -s /bin/bash "$u"
    usermod -aG "${USERS[$u]}" "$u"
done

id -u vikunja >/dev/null 2>&1 || bash "$(dirname "$0")/../sis1/setup_fs.sh"
usermod -aG docker vikunja

for u in "${!USERS[@]}" vikunja caddy; do id "$u"; done
