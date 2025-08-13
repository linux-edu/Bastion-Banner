#!/bin/bash
# Bastion-Banner uninstaller

set -e

echo "🗑️  Uninstalling Bastion-Banner..."

# 1. Remove neofetch config
CONFIG_DIR="$HOME/.config/neofetch"
if [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
    echo "✅ Removed neofetch config."
else
    echo "ℹ️ No neofetch config found."
fi

# 2. Remove neofetch from .bashrc
if grep -q "neofetch" ~/.bashrc; then
    sed -i '/neofetch/d' ~/.bashrc
    echo "✅ Removed neofetch from .bashrc."
else
    echo "ℹ️ No neofetch entry found in .bashrc."
fi

# 3. Optional: Ask to uninstall neofetch program
read -p "❓ Do you also want to remove neofetch from the system? (y/N): " REMOVE_NEOFETCH
if [[ "$REMOVE_NEOFETCH" =~ ^[Yy]$ ]]; then
    if command -v termux-info >/dev/null 2>&1; then
        PKG_CMD="pkg"
    else
        PKG_CMD="apt"
    fi
    $PKG_CMD remove -y neofetch
    echo "✅ neofetch removed."
else
    echo "ℹ️ Keeping neofetch installed."
fi

echo "🎯 Bastion-Banner uninstalled!"
echo "💡 Restart your terminal or run: source ~/.bashrc"
