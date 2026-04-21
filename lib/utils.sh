set -e
set -o pipefail

RED='\033[0;31m';
GREEN='\033[0;32m'
YELLOW='\033[1;33m';
BLUE='\033[0;34m'
BOLD='\033[1m';
NC='\033[0m'

print_banner() {
    # figlet per il testo grande, gum per i colori
    gum style \
        --foreground 214 \
        --bold \
        "$(figlet -f slant 'AuRCH')"

    gum style \
        --foreground 245 \
        "Arch Linux, curated. No manual package lists."

    echo ""

    gum style --foreground 214 "Author" | tr -d '\n'
    gum style --foreground 245 "  Francesco Palazzo, 2026"

    gum style --foreground 214 "Desktop" | tr -d '\n'
    gum style --foreground 245 "  Hyprland + Caelestia Shell"

    echo ""
}

log()     { echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"; }
success() { echo -e "${GREEN}SUCCESS:${NC} $1"; }
warn()    { echo -e "${YELLOW}WARNING:${NC} $1"; }
die()     { echo -e "${RED}ERROR:${NC} $1" >&2; exit 1; }

check_internet() {
    log "Verifying internet connection..."
    ping -c 1 8.8.8.8 &>/dev/null || die "No internet connection. Aborting..."
}

ask_user_info() {
    echo -e "\n${BOLD}Initial configuration${NC}"
    read -rp "Your full name: " USER_FULLNAME
    [[ -z "$USER_FULLNAME" ]] && die "Full name cannot be empty"
    # read -rp "Your email: " USER_EMAIL
    # read -rp "Github username (optional): " USER_EMAIL
    export USER_FULLNAME
}

ask_gpu_vendor() {
    echo -e "\n${BOLD}Which is your GPU vendor?${NC}"
    select GPU in "NVIDIA (propietary)" "AMD" "Intel" "NVIDIA (open)" "QEMU" "VirtualBox"; do
        case $REPLY in
            1) GPU_VENDOR="nvidia"; break ;;
            2) GPU_VENDOR="amd"; break ;;
            3) GPU_VENDOR="intel"; break ;;
            4) GPU_VENDOR="nvidia-open"; break ;;
            5) GPU_VENDOR="qemu"; break;;
            6) GPU_VENDOR="vbox"; break;;
            *) warn "Invalid choice '$REPLY'."
        esac
    done
    export GPU_VENDOR
}
