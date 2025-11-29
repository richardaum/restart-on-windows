#!/bin/bash
# Script to configure sudoers and allow running restart-windows.sh without password
# Run this script ONCE with: bash ~/.local/bin/setup-restart-windows-sudo.sh

echo "🔧 Configuring sudoers to allow restart-windows.sh without password..."
echo ""

# Create temporary sudoers file
SUDOERS_FILE="/tmp/restart-windows-sudoers-$$"
cat > "$SUDOERS_FILE" << 'EOF'
# Allow richardaum to execute restart-windows.sh without password
richardaum ALL=(ALL) NOPASSWD: /home/richardaum/.local/bin/restart-windows.sh
EOF

echo "📝 Sudoers file created. Copying to /etc/sudoers.d/..."
echo "   (You will need to enter your password once)"
echo ""

# Copy the file
sudo cp "$SUDOERS_FILE" /etc/sudoers.d/restart-windows
sudo chmod 0440 /etc/sudoers.d/restart-windows

# Validate syntax
if sudo visudo -c -f /etc/sudoers.d/restart-windows; then
    echo ""
    echo "✅ Configuration completed successfully!"
    echo "   You can now run restart-windows.sh without password."
    rm -f "$SUDOERS_FILE"
else
    echo ""
    echo "❌ Configuration error. Removing invalid file..."
    sudo rm -f /etc/sudoers.d/restart-windows
    rm -f "$SUDOERS_FILE"
    exit 1
fi
