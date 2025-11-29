#!/bin/bash
# Installation script for restart-on-windows
# Downloads files via curl and sets up the installation
# Usage: curl ... | bash -s [version]
#   version can be: latest, v1.0.0, or main (default: latest)

set -e

VERSION="${1:-latest}"
REPO_URL="https://raw.githubusercontent.com/richardaum/restart-on-windows"
INSTALL_DIR="${HOME}/.local/share/restart-on-windows"

# Determine the branch/tag to use
if [ "$VERSION" = "latest" ]; then
    # Try to get the latest release tag, fallback to main
    LATEST_TAG=$(curl -fsSL https://api.github.com/repos/richardaum/restart-on-windows/releases/latest 2>/dev/null | grep -oP '"tag_name": "\K[^"]*' | head -1)
    if [ -n "$LATEST_TAG" ]; then
        BRANCH_OR_TAG="$LATEST_TAG"
        echo "📌 Using latest stable version: $LATEST_TAG"
    else
        BRANCH_OR_TAG="main"
        echo "📌 Using main branch (no releases found)"
    fi
elif [ "$VERSION" = "main" ]; then
    BRANCH_OR_TAG="main"
    echo "📌 Using main branch"
else
    BRANCH_OR_TAG="$VERSION"
    echo "📌 Using version: $VERSION"
fi

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

echo "📦 Downloading files from ${BRANCH_OR_TAG}..."

# Download all necessary files
curl -fsSL "${BASE_URL}/restart-on-windows.sh" -o "${INSTALL_DIR}/restart-on-windows.sh"
curl -fsSL "${BASE_URL}/setup-restart-on-windows-sudo.sh" -o "${INSTALL_DIR}/setup-restart-on-windows-sudo.sh"
curl -fsSL "${BASE_URL}/restart-on-windows.desktop" -o "${INSTALL_DIR}/restart-on-windows.desktop"
curl -fsSL "${BASE_URL}/quick-start.sh" -o "${INSTALL_DIR}/quick-start.sh"

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
echo "Installed version: $BRANCH_OR_TAG"
echo ""
echo "To install a specific version:"
echo "  curl -fsSL https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash -s v1.0.0"
echo "To update to latest:"
echo "  curl -fsSL https://raw.githubusercontent.com/richardaum/restart-on-windows/main/install.sh | bash"
