set -e
set -o pipefail

setup_rustup() {
    if ! command -v rustup &>/dev/null; then
        log "rustup not installed. Installing now..."
        sudo pacman -S --noconfirm --needed rustup
    fi
    rustup toolchain list | grep -q stable || rustup default stable
}

setup_paru() (
    if command -v paru &>/dev/null; then
        log "paru already installed"
        exit;
    fi
    setup_rustup
    sudo pacman -S --needed --noconfirm base-devel git
    if [ ! -d /tmp/paru ]; then
        git clone https://aur.archlinux.org/paru.git /tmp/paru
    fi
    cd /tmp/paru
    git pull
    if ! ls ./*.pkg.tar.zst &>/dev/null; then
        makepkg -s --noconfirm
    fi
    sudo pacman -U --noconfirm --needed *.pkg.tar.zst
    sudo mkdir -p /etc/makepkg.conf.d/
    echo "MAKEFLAGS='-j$(nproc --ignore=1)'" | sudo tee -a /etc/makepkg.conf.d/make.conf > /dev/null
)

setup_gpudrivers() {
    case $GPU_VENDOR in
        "qemu")
            log "Configuring video drivers for QEMU/KVM..."
            sudo pacman -S --noconfirm \
                mesa \
                vulkan-virtio \
                spice-vdagent \
                qemu-guest-agent
            echo "WLR_RENDERER=pixman" | sudo tee -a /etc/environment > /dev/null
            echo "WLR_NO_HARDWARE_CURSORS=1" | sudo tee -a /etc/environment > /dev/null
            ;;
        "vbox")
            log "Configuring video drivers for VirtualBox..."
            sudo pacman -S --noconfirm --needed \
                mesa \
                virtualbox-guest-utils
            sudo systemctl enable --now vboxservice
            echo "WLR_RENDERER=pixman" | sudo tee -a /etc/environment > /dev/null
            echo "WLR_NO_HARDWARE_CURSORS=1" | sudo tee -a /etc/environment > /dev/null
            ;;
        "nvidia"|"nvidia-open")
            local driver="nvidia-dkms"
            [[ "$GPU_VENDOR" == "nvidia-open" ]] && driver="nvidia-open-dkms"
            log "Configuring video drivers for Nvidia ($driver)..."
            sudo pacman -S --noconfirm --needed \
                linux-headers \
                "$driver" \
                nvidia-utils \
                nvidia-settings \
                egl-wayland \
                libva-nvidia-driver
            ;;
        "intel")
            log "Configuring video drivers for Intel..."
            sudo pacman -S --noconfirm --needed \
                mesa intel-media-driver vulkan-intel
            ;;
        "amd")
            log "Configuring video drivers for AMD..."
            sudo pacman -S --noconfirm --needed mesa vulkan-radeon
            ;;
        *) warn "$REPLY not implemented." ;;
    esac
}

setup_caelestia() {
    log "Installing caelestia-shell..."
    paru -S --noconfirm --needed caelestia-shell
    git clone https://github.com/caelestia-dots/caelestia.git ~/.local/share/caelestia
    fish ~/.local/share/caelestia/install.fish --noconfirm
    if [[ "$GPU_VENDOR" == "nvidia" || "$GPU_VENDOR" == "nvidia-open" ]]; then
        log "Overriding env variables for Nvidia..."
        cat "$SCRIPT_DIR/cfg/nvidia-hyprvars.conf" >> ~/.config/caelestia/hypr-vars.conf
    fi
    mkdir -p "~/.config/caelestia"
    cp "$SCRIPT_DIR/cfg/shell.json" "~/.config/caelestia/shell.json"
    success "Installed caelestia-shell."
}

setup_user_info() {
    log "Setting full name for user $USER..."
    sudo usermod -c "$USER_FULLNAME" "$USER"
    success "Setup full name to $USER_FULLNAME."
}

setup_sddm() {
    log "Setting up desktop manager..."
    paru -S --noconfirm --needed sddm-silent-theme
    sudo cp "$SCRIPT_DIR/cfg/sddm.conf" "/etc/sddm.conf"
    sudo systemctl enable sddm
    success "Installed theme for SDDM."
}

setup_system() {
    setup_paru
    setup_gpudrivers
    sudo pacman -S --noconfirm --needed hyprland sddm foot fish uwsm libnewt \
        hyprpolkitagent pipewire pipewire-audio pipewire-jack pipewire-pulse \
        wireplumber xdg-desktop-portal fastfetch \
        xdg-desktop-portal-hyprland thunar starship nano \
        ttf-jetbrains-mono-nerd \
        xdg-user-dirs eza btop \
        flatpak gnome-software
    paru -S --noconfirm --needed zen-browser-bin

    setup_user_info
    xdg-user-dirs-update
    setup_sddm
    setup_caelestia
}

