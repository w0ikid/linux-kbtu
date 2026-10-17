| Role | Description | Permissions | Superuser permissions |
|---|---|---|---|
| vikunja (service) | Runs the Vikunja stack, owns app files | Own /opt/vikunja, /var/lib/vikunja/files, /var/log/vikunja; read /etc/vikunja; group docker; no login shell | none |
| postgres (container uid) | PostgreSQL inside container | Owns pgdata volume only | none |
| caddy (service) | Reverse proxy, TLS | Read /etc/caddy, bind 80/443 | none |
| sysadmin (sysadmin1) | Administrator | Full shell access | `ALL` via sudo |
| deploy (devops1) | Deployment | rwx on /opt/vikunja (ACL) | systemctl start/stop/restart/status vikunja.service |
| audit (auditor1) | Auditor | Read-only logs: /var/log (adm), journal, /var/log/vikunja (ACL) | systemctl status * (NOEXEC) |
| automation (automation_bot) | CI/automation bot, key-only SSH | none beyond sudo | systemctl restart/status vikunja.service, docker compose pull / up -d for /opt/vikunja |
| backup (backup_op) | Backups | rwx /var/backups/vikunja, r-x /var/lib/vikunja (ACL) | docker exec vikunja-db pg_dump -U vikunja vikunja |
