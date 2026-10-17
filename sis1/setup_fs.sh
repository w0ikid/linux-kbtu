#!/usr/bin/env bash
set -euo pipefail

APP_USER="vikunja"
APP_GROUP="vikunja"

if ! getent group "$APP_GROUP" >/dev/null; then
    groupadd --system "$APP_GROUP"
fi

if ! id -u "$APP_USER" >/dev/null 2>&1; then
    useradd --system --gid "$APP_GROUP" \
            --home-dir /opt/vikunja --shell /usr/sbin/nologin "$APP_USER"
fi

install -d -o "$APP_USER" -g "$APP_GROUP" -m 755 /opt/vikunja
install -d -o root        -g "$APP_GROUP" -m 750 /etc/vikunja
install -d -o "$APP_USER" -g "$APP_GROUP" -m 750 /var/lib/vikunja/files
install -d -o "$APP_USER" -g adm          -m 750 /var/log/vikunja
install -d -o root        -g root         -m 700 /var/backups/vikunja

if [[ ! -f /etc/vikunja/app.env ]]; then
    cat > /etc/vikunja/app.env <<'EOF'
VIKUNJA_SERVICE_PUBLICURL=https://130.61.33.223.sslip.io
VIKUNJA_SERVICE_JWTSECRET=CHANGE_ME
VIKUNJA_DATABASE_TYPE=postgres
VIKUNJA_DATABASE_HOST=db
VIKUNJA_DATABASE_USER=vikunja
VIKUNJA_DATABASE_PASSWORD=CHANGE_ME
VIKUNJA_DATABASE_DATABASE=vikunja
EOF
    chown root:"$APP_GROUP" /etc/vikunja/app.env
    chmod 640 /etc/vikunja/app.env
fi

touch /var/log/vikunja/app.log
chown "$APP_USER":adm /var/log/vikunja/app.log
chmod 640 /var/log/vikunja/app.log

echo "Filesystem layout created."
