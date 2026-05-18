#!/bin/bash
# Starts the OpenHuman Core RPC server.
# On first run, auto-generates OPENHUMAN_CORE_TOKEN and builds the Docker image.
set -e

PROJECT=openhuman
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Auto-copy .env.example → .env on first run
if [[ ! -f .env ]]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
fi

# Auto-generate OPENHUMAN_CORE_TOKEN if placeholder
if grep -q "OPENHUMAN_CORE_TOKEN=GENERATE_ME" .env 2>/dev/null; then
    TOKEN=$(openssl rand -hex 32)
    sed -i "s|OPENHUMAN_CORE_TOKEN=GENERATE_ME|OPENHUMAN_CORE_TOKEN=$TOKEN|" .env
    echo "Generated OPENHUMAN_CORE_TOKEN and saved to .env"
    echo "  Keep this value — it authenticates all RPC clients."
    echo ""
fi

echo "Building image and starting services..."
docker compose -p "$PROJECT" up -d --build

echo ""
echo "OpenHuman Core is starting. Ready in ~15 seconds."
echo ""
echo "Health:  http://localhost:7788/health"
echo "RPC:     http://localhost:7788/rpc"
echo ""
echo "To watch startup: docker compose -p $PROJECT logs -f openhuman-core"
