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
check_internet

sudo -v
while true; do sudo -n true; sleep 60; done &
SUDO_KEEPALIVE_PID=$!

sudo pacman -S --noconfirm --needed gum figlet
clear

print_banner
gum confirm "This will install and configure your system. Continue?" \
    || die "Aborted by user."

ask_user_info
ask_gpu_vendor

setup_system
setup_gaming

kill "$SUDO_KEEPALIVE_PID"
gum style \
    --foreground 214 --bold \
    --border rounded \
    --border-foreground 214 \
    --padding "1 4" \
    --margin "1 0" \
    "$(figlet -f slant 'Done!')" \
    "" \
    "Reboot to start using your system:" \
    "  sudo reboot"
