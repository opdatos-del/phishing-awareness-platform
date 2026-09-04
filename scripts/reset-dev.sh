#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "=== Reset Development Environment ==="
echo "WARNING: This will stop containers and remove Docker volumes."
read -p "Are you sure? (y/N): " confirm
if [ "$confirm" != "y" ]; then
    echo "Aborted."
    exit 0
fi

docker compose down -v
echo "Dev environment reset."
echo "Run './scripts/dev-up.sh' to start fresh."
