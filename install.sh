#!/bin/bash
# Installation script for restart-on-windows
# Downloads files via curl and sets up the installation

set -e

REPO_URL="https://raw.githubusercontent.com/richardaum/restart-on-windows/main"
INSTALL_DIR="${HOME}/.local/share/restart-on-windows"

echo "🚀 Installing Restart on Windows..."
echo ""

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "❌ curl is not installed. Please install curl first:"
    echo "   sudo apt install curl"
    exit 1
fi

# Create installation directory
mkdir -p "$INSTALL_DIR"

echo "📦 Downloading files..."

# Download all necessary files
curl -fsSL "${REPO_URL}/restart-on-windows.sh" -o "${INSTALL_DIR}/restart-on-windows.sh"
curl -fsSL "${REPO_URL}/setup-restart-on-windows-sudo.sh" -o "${INSTALL_DIR}/setup-restart-on-windows-sudo.sh"
curl -fsSL "${REPO_URL}/restart-on-windows.desktop" -o "${INSTALL_DIR}/restart-on-windows.desktop"
curl -fsSL "${REPO_URL}/quick-start.sh" -o "${INSTALL_DIR}/quick-start.sh"

# Make scripts executable
chmod +x "${INSTALL_DIR}/restart-on-windows.sh"
chmod +x "${INSTALL_DIR}/setup-restart-on-windows-sudo.sh"
chmod +x "${INSTALL_DIR}/quick-start.sh"

echo "   ✅ Files downloaded"
echo ""

echo "🔧 Running installation script..."
cd "$INSTALL_DIR"
bash "${INSTALL_DIR}/quick-start.sh"

echo ""
echo "✅ Installation complete!"
echo ""
echo "Files are located at: $INSTALL_DIR"
echo "To update, run this installation script again."
