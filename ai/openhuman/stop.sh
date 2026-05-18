#!/bin/bash
# Stops the OpenHuman Core container. The openhuman-workspace volume is preserved.
# Pass --volumes to also remove the workspace volume (destructive — memory trees and data will be lost).
set -e

PROJECT=openhuman

docker compose -p "$PROJECT" down "$@"
