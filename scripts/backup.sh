#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"

source .env

echo "=== Backing up MySQL database ==="
mysqldump -h "${DB_HOST:-127.0.0.1}" \
          -P "${DB_PORT:-3306}" \
          -u "${DB_USERNAME:-phishing_app}" \
          -p"${DB_PASSWORD:-CHANGE_ME}" \
          "${DB_NAME:-phishing_awareness}" \
          > "$BACKUP_DIR/phishing_awareness_${TIMESTAMP}.sql"

echo "Backup saved: $BACKUP_DIR/phishing_awareness_${TIMESTAMP}.sql"
