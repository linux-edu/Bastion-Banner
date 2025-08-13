#!/bin/bash
# Bastion-Banner installer — now with Parrot/Debian choice
# No sudo, no update/upgrade — just installs neofetch & sets config

set -e

echo "🔍 Detecting environment..."
if command -v termux-info >/dev/null 2>&1; then
    PKG_CMD="pkg"
else
    PKG_CMD="apt"
fi
echo "✅ Using package manager: $PKG_CMD"

# =========================
# 1. Install neofetch if missing
# =========================
if ! command -v neofetch >/dev/null 2>&1; then
    echo "📦 Installing neofetch..."
    $PKG_CMD install -y neofetch
else
    echo "✅ neofetch already installed."
fi

# =========================
# 2. Config directory setup
# =========================
mkdir -p ~/.config/neofetch
CONFIG_FILE="$HOME/.config/neofetch/config.conf"

# =========================
# 3. ParrotSec special choice
# =========================
if grep -qi "parrot" /etc/os-release 2>/dev/null; then
    echo ""
    echo "🎨 Parrot Security detected!"
    echo "Choose your banner logo:"
    echo "1) ParrotSec logo"
    echo "2) Debian logo"
    read -p "#? " LOGO_CHOICE
    case $LOGO_CHOICE in
        1) ASCII_DISTRO="Parrot" ;;
        2) ASCII_DISTRO="Debian" ;;
        *) echo "❌ Invalid choice, defaulting to ParrotSec."; ASCII_DISTRO="Parrot" ;;
    esac
else
    # Non-Parrot systems → use default auto detection
    ASCII_DISTRO="auto"
fi

# =========================
# 4. Create config
# =========================
echo "✅ Applying banner theme..."
cat > "$CONFIG_FILE" <<EOF
print_info() {
    info title
    info underline

    info "OS" distro
    info "Kernel" kernel
    info "Uptime" uptime
    info "Shell" shell
}

ascii_distro="$ASCII_DISTRO"
EOF

# =========================
# 5. Add to .bashrc
# =========================
if ! grep -q "neofetch" ~/.bashrc; then
    echo "neofetch" >> ~/.bashrc
fi

echo "✅ Bastion-Banner installed!"
echo "💡 Restart your terminal or run: source ~/.bashrc"
