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
    USER_FULLNAME=$(gum input --placeholder "Temurto Macchi" --prompt "Full name > ")
    [[ -z "$USER_FULLNAME" ]] && die "Full name cannot be empty"
    # read -rp "Your email: " USER_EMAIL
    # read -rp "Github username (optional): " USER_EMAIL
    export USER_FULLNAME
}

ask_gpu_vendor() {
    echo -e "\n${BOLD}Which is your GPU vendor?${NC}"
    CHOICE=$(gum choose \
        "NVIDIA (proprietary)" \
        "NVIDIA (open source)" \
        "AMD" \
        "Intel" \
        "QEMU / KVM" \
        "VirtualBox")
    case $CHOICE in
        "NVIDIA (proprietary)")  GPU_VENDOR="nvidia" ;;
        "NVIDIA (open source)")  GPU_VENDOR="nvidia-open" ;;
        "AMD")                   GPU_VENDOR="amd" ;;
        "Intel")                 GPU_VENDOR="intel" ;;
        "QEMU / KVM")            GPU_VENDOR="qemu" ;;
        "VirtualBox")            GPU_VENDOR="vbox" ;;
        *) die "No GPU selected." ;;
    esac
    export GPU_VENDOR
}
