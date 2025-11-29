#!/bin/bash
# Quick Start script - Automated installation of restart-windows
# This script sets up everything automatically

set -e  # Exit on error

echo "🚀 Restart Windows - Quick Start Installation"
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

# Step 1: Copy scripts to ~/.local/bin
echo "📦 Step 1: Installing scripts to ~/.local/bin..."
mkdir -p ~/.local/bin

cp "$SCRIPT_DIR/restart-windows.sh" ~/.local/bin/
cp "$SCRIPT_DIR/setup-restart-windows-sudo.sh" ~/.local/bin/

chmod +x ~/.local/bin/restart-windows.sh
chmod +x ~/.local/bin/setup-restart-windows-sudo.sh

echo "   ✅ Scripts installed"
echo ""

# Step 2: Install desktop entry
echo "📦 Step 2: Installing desktop entry..."
mkdir -p ~/.local/share/applications

cp "$SCRIPT_DIR/restart-windows.desktop" ~/.local/share/applications/
update-desktop-database ~/.local/share/applications 2>/dev/null || true

echo "   ✅ Desktop entry installed"
echo ""

# Step 3: Configure sudoers
echo "📦 Step 3: Configuring sudoers (requires password)..."
echo "   This will allow running restart-windows.sh without password"
echo ""

bash ~/.local/bin/setup-restart-windows-sudo.sh

echo ""
echo "=============================================="
echo "✅ Installation completed successfully!"
echo ""
echo "You can now use restart-windows in the following ways:"
echo ""
echo "1. From Launcher:"
echo "   Search for 'Restart on Windows (Temporary)'"
echo ""
echo "2. From Terminal:"
echo "   ~/.local/bin/restart-windows.sh"
echo ""
echo "For more options, run:"
echo "   ~/.local/bin/restart-windows.sh --help"
echo ""

