#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/GoldenPalazzo/aurch.git"
INSTALL_DIR="$HOME/aurch"

if ! command -v git &>/dev/null; then
    sudo pacman -S --noconfirm git
fi

echo "=> Cloning aurch..."
rm -rf "$INSTALL_DIR"
git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"

echo "=> Starting setup..."
cd "$INSTALL_DIR"
bash install.sh
