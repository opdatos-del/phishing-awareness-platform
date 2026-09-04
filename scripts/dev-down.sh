#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "=== Stopping Phishing Awareness Platform ==="
docker compose down
echo "Services stopped."
