#!/bin/bash
# Quick Start script - Automated installation of restart-on-windows
# This script sets up everything automatically

set -e  # Exit on error

echo "🚀 Restart on Windows - Quick Start Installation"
echo "=============================================="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if efibootmgr is installed
if ! command -v efibootmgr &> /dev/null; then
    echo "⚠️  efibootmgr is not installed."
    echo "   Installing efibootmgr..."
    sudo apt update && sudo apt install -y efibootmgr
    echo ""
fi

# Step 1: Create symbolic links to scripts in ~/.local/bin
echo "📦 Step 1: Creating symbolic links to scripts in ~/.local/bin..."
mkdir -p ~/.local/bin

ln -sf "$SCRIPT_DIR/restart-on-windows.sh" ~/.local/bin/restart-on-windows.sh
ln -sf "$SCRIPT_DIR/setup-restart-on-windows-sudo.sh" ~/.local/bin/setup-restart-on-windows-sudo.sh

chmod +x "$SCRIPT_DIR/restart-on-windows.sh"
chmod +x "$SCRIPT_DIR/setup-restart-on-windows-sudo.sh"

echo "   ✅ Symbolic links created"
echo ""

# Step 2: Install desktop entry (symbolic link)
echo "📦 Step 2: Creating symbolic link to desktop entry..."
mkdir -p ~/.local/share/applications

ln -sf "$SCRIPT_DIR/restart-on-windows.desktop" ~/.local/share/applications/restart-on-windows.desktop
update-desktop-database ~/.local/share/applications 2>/dev/null || true

echo "   ✅ Desktop entry link created"
echo ""

# Step 3: Configure sudoers
echo "📦 Step 3: Configuring sudoers (requires password)..."
echo "   This will allow running restart-on-windows.sh without password"
echo ""

bash ~/.local/bin/setup-restart-on-windows-sudo.sh

echo ""
echo "=============================================="
echo "✅ Installation completed successfully!"
echo ""
echo "You can now use restart-on-windows in the following ways:"
echo ""
echo "1. From Launcher:"
echo "   Search for 'Restart on Windows (Temporary)'"
echo ""
echo "2. From Terminal:"
echo "   ~/.local/bin/restart-on-windows.sh"
echo ""
echo "For more options, run:"
echo "   ~/.local/bin/restart-on-windows.sh --help"
echo ""

