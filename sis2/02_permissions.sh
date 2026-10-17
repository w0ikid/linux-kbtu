#!/usr/bin/env bash
set -euo pipefail

command -v setfacl >/dev/null || apt-get install -y acl

setfacl -R -m g:deploy:rwX,d:g:deploy:rwX /opt/vikunja

setfacl -m g:backup:rwx,d:g:backup:rwx /var/backups/vikunja
setfacl -m g:backup:rx /var/lib/vikunja /var/lib/vikunja/files

setfacl -m g:audit:rx /var/log/vikunja
setfacl -m g:audit:r /var/log/vikunja/app.log

install_sudoers() {
    local name=$1 tmp
    tmp=$(mktemp)
    cat > "$tmp"
    visudo -cf "$tmp"
    install -o root -g root -m 0440 "$tmp" "/etc/sudoers.d/$name"
    rm -f "$tmp"
}

install_sudoers 05-defaults <<'X'
Defaults use_pty
Defaults logfile="/var/log/sudo.log"
X

install_sudoers 10-sysadmin <<'X'
%sysadmin ALL=(ALL) NOPASSWD: ALL
X

install_sudoers 20-deploy <<'X'
Cmnd_Alias VIKUNJA_SVC = /usr/bin/systemctl start vikunja.service, \
                         /usr/bin/systemctl stop vikunja.service, \
                         /usr/bin/systemctl restart vikunja.service, \
                         /usr/bin/systemctl status vikunja.service
%deploy ALL=(root) NOPASSWD: VIKUNJA_SVC
X

install_sudoers 30-audit <<'X'
%audit ALL=(root) NOPASSWD: NOEXEC: /usr/bin/systemctl status *
X

install_sudoers 40-automation <<'X'
Cmnd_Alias DEPLOY_CMDS = /usr/bin/systemctl restart vikunja.service, \
                         /usr/bin/systemctl status vikunja.service, \
                         /usr/bin/docker compose -f /opt/vikunja/docker-compose.yml pull, \
                         /usr/bin/docker compose -f /opt/vikunja/docker-compose.yml up -d
%automation ALL=(root) NOPASSWD: DEPLOY_CMDS
X

install_sudoers 50-backup <<'X'
%backup ALL=(root) NOPASSWD: /usr/bin/docker exec vikunja-db pg_dump -U vikunja vikunja
X

getfacl -p /opt/vikunja /var/backups/vikunja /var/lib/vikunja/files /var/log/vikunja
ls -l /etc/sudoers.d
