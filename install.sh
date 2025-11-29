#!/bin/bash
# Installation script for restart-on-windows
# Downloads files via curl and sets up the installation
# Usage: curl ... | bash

set -e

REPO_URL="https://raw.githubusercontent.com/richardaum/restart-on-windows"
INSTALL_DIR="${HOME}/.local/share/restart-on-windows"
BRANCH_OR_TAG="main"

BASE_URL="${REPO_URL}/${BRANCH_OR_TAG}"

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

echo "📦 Downloading files from main branch..."

# Download all necessary files
curl -fsSL "${BASE_URL}/src/restart-on-windows.sh" -o "${INSTALL_DIR}/restart-on-windows.sh"
curl -fsSL "${BASE_URL}/src/setup-restart-on-windows-sudo.sh" -o "${INSTALL_DIR}/setup-restart-on-windows-sudo.sh"
curl -fsSL "${BASE_URL}/src/restart-on-windows.desktop" -o "${INSTALL_DIR}/restart-on-windows.desktop"
curl -fsSL "${BASE_URL}/src/quick-start.sh" -o "${INSTALL_DIR}/quick-start.sh"

# Make scripts executable
chmod +x "${INSTALL_DIR}/restart-on-windows.sh"
chmod +x "${INSTALL_DIR}/setup-restart-on-windows-sudo.sh"
chmod +x "${INSTALL_DIR}/quick-start.sh"

# Save version information
echo "$BRANCH_OR_TAG" > "${INSTALL_DIR}/.version"
echo "$(date -Iseconds)" >> "${INSTALL_DIR}/.version"

echo "   ✅ Files downloaded"
echo ""

echo "🔧 Running installation script..."
cd "$INSTALL_DIR"
bash "${INSTALL_DIR}/quick-start.sh"

echo ""
echo "✅ Installation complete!"
echo ""
echo "Files are located at: $INSTALL_DIR"
