#!/usr/bin/env bash
set -euo pipefail

echo "=== Stopping Phishing Awareness Platform ==="
docker compose down
echo "Services stopped."
