#!/bin/env bash

set -e
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/system.sh"
source "$SCRIPT_DIR/lib/gaming.sh"

if [[ $EUID -eq 0 ]]; then
    die "Do not execute as root. Use a normal user with sudo."
fi

echo "Welcome to AuRCH installer."
echo "Author: Francesco Palazzo, 2026"

ask_user_info
ask_gpu_vendor

setup_system
setup_gaming
