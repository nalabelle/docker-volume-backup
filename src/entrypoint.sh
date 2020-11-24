#!/bin/bash
set -eo pipefail

env | grep -E "^(BACKUP|AWS|TZ)" | sed 's/^\([A-Z0-9_]\+=\)/\1\"/;s/$/\"/;s/^/export /' > env.sh
chmod +x env.sh

# Add our cron entry, and direct stdout & stderr to Docker commands stdout
echo "Installing cron.d entry: docker-volume-backup"
echo "$BACKUP_CRON_EXPRESSION root /root/backup.sh > /proc/1/fd/1 2>&1" > /etc/cron.d/docker-volume-backup

# Let cron take the wheel
echo "Starting cron in foreground with expression: $BACKUP_CRON_EXPRESSION"
cron -f
