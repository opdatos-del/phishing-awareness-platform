#!/usr/bin/env bash
set -euo pipefail

echo "=== Starting Phishing Awareness Platform ==="

# Check if .env exists
if [ ! -f .env ]; then
    echo "ERROR: .env file not found."
    echo "Copy .env.example to .env and configure it first."
    echo "  cp .env.example .env"
    exit 1
fi

# Check MySQL connectivity
echo "Checking MySQL connectivity..."
if ! command -v mysql &> /dev/null; then
    echo "WARNING: mysql client not found. Skipping connectivity check."
else
    source .env
    if mysql -h "${DB_HOST:-127.0.0.1}" -P "${DB_PORT:-3306}" -u "${DB_USERNAME:-phishing_app}" -p"${DB_PASSWORD:-CHANGE_ME}" -e "SELECT 1" &> /dev/null; then
        echo "MySQL connection OK"
    else
        echo "ERROR: Cannot connect to MySQL."
        echo "Ensure MySQL is running and credentials in .env are correct."
        exit 1
    fi
fi

# Create database if not exists
echo "Ensuring database exists..."
source .env
mysql -h "${DB_HOST:-127.0.0.1}" -P "${DB_PORT:-3306}" -u "${DB_USERNAME:-phishing_app}" -p"${DB_PASSWORD:-CHANGE_ME}" -e \
    "CREATE DATABASE IF NOT EXISTS ${DB_NAME:-phishing_awareness} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null || true

echo "Building and starting services..."
docker compose up -d --build

echo ""
echo "=== Services Starting ==="
echo "  App:        http://localhost"
echo "  GoPhish:    http://localhost:3333 (admin panel)"
echo "  Mailpit:    http://localhost:8025 (email viewer)"
echo ""
echo "Default admin: admin / admin123"
echo "Run 'docker compose logs -f' to watch logs."
