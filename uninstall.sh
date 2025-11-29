#!/bin/bash
# Uninstallation script for restart-on-windows
# Removes all installed files and configurations
# Usage: bash uninstall.sh

set -e

INSTALL_DIR="${HOME}/.local/share/restart-on-windows"
BIN_DIR="${HOME}/.local/bin"
APPLICATIONS_DIR="${HOME}/.local/share/applications"
SUDOERS_FILE="/etc/sudoers.d/restart-on-windows"

echo "🗑️  Uninstalling Restart on Windows..."
echo ""

# Check if installation exists
if [ ! -d "$INSTALL_DIR" ]; then
    echo "⚠️  Installation directory not found: $INSTALL_DIR"
    echo "   The application may have already been uninstalled or was installed differently."
    echo ""
fi

# Step 1: Remove symbolic links from ~/.local/bin
echo "📦 Step 1: Removing symbolic links from ~/.local/bin..."
if [ -L "${BIN_DIR}/restart-on-windows.sh" ]; then
    rm -f "${BIN_DIR}/restart-on-windows.sh"
    echo "   ✅ Removed: ${BIN_DIR}/restart-on-windows.sh"
else
    echo "   ℹ️  Symbolic link not found: ${BIN_DIR}/restart-on-windows.sh"
fi

if [ -L "${BIN_DIR}/setup-restart-on-windows-sudo.sh" ]; then
    rm -f "${BIN_DIR}/setup-restart-on-windows-sudo.sh"
    echo "   ✅ Removed: ${BIN_DIR}/setup-restart-on-windows-sudo.sh"
else
    echo "   ℹ️  Symbolic link not found: ${BIN_DIR}/setup-restart-on-windows-sudo.sh"
fi
echo ""

# Step 2: Remove desktop entry
echo "📦 Step 2: Removing desktop entry..."
if [ -L "${APPLICATIONS_DIR}/restart-on-windows.desktop" ]; then
    rm -f "${APPLICATIONS_DIR}/restart-on-windows.desktop"
    echo "   ✅ Removed: ${APPLICATIONS_DIR}/restart-on-windows.desktop"
    
    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        update-desktop-database "${APPLICATIONS_DIR}" 2>/dev/null || true
        echo "   ✅ Updated desktop database"
    fi
else
    echo "   ℹ️  Desktop entry not found: ${APPLICATIONS_DIR}/restart-on-windows.desktop"
fi
echo ""

# Step 3: Remove sudoers configuration
echo "📦 Step 3: Removing sudoers configuration..."
if [ -f "$SUDOERS_FILE" ]; then
    echo "   Removing: $SUDOERS_FILE"
    echo "   (You will need to enter your password)"
    echo ""
    
    if sudo rm -f "$SUDOERS_FILE"; then
        echo "   ✅ Removed sudoers configuration"
    else
        echo "   ⚠️  Could not remove sudoers file. You may need to remove it manually:"
        echo "      sudo rm -f $SUDOERS_FILE"
    fi
else
    echo "   ℹ️  Sudoers file not found: $SUDOERS_FILE"
fi
echo ""

# Step 4: Remove installation directory
echo "📦 Step 4: Removing installation directory..."
if [ -d "$INSTALL_DIR" ]; then
    read -p "   Remove installation directory ($INSTALL_DIR)? [y/N] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$INSTALL_DIR"
        echo "   ✅ Removed installation directory"
    else
        echo "   ℹ️  Installation directory kept: $INSTALL_DIR"
    fi
else
    echo "   ℹ️  Installation directory not found: $INSTALL_DIR"
fi
echo ""

echo "=============================================="
echo "✅ Uninstallation complete!"
echo ""
echo "The following have been removed:"
echo "  - Symbolic links from ~/.local/bin/"
echo "  - Desktop entry from ~/.local/share/applications/"
echo "  - Sudoers configuration"
if [ ! -d "$INSTALL_DIR" ]; then
    echo "  - Installation directory"
fi
echo ""
echo "If you want to reinstall, run:"
echo "  curl -fsSL https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash"
echo ""
