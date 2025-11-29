#!/bin/bash
# Install git hooks for this repository
# This script copies hooks from .githooks/ to .git/hooks/

set -e

# Get the repository root directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GITHOOKS_DIR="$REPO_ROOT/.githooks"
GIT_HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo "🔧 Installing git hooks..."
echo ""

# Check if .githooks directory exists
if [ ! -d "$GITHOOKS_DIR" ]; then
    echo "❌ Error: .githooks directory not found!"
    exit 1
fi

# Check if .git/hooks directory exists
if [ ! -d "$GIT_HOOKS_DIR" ]; then
    echo "❌ Error: .git/hooks directory not found!"
    echo "   Make sure you're in a git repository."
    exit 1
fi

# Install each hook from .githooks/
HOOKS_INSTALLED=0
for hook_file in "$GITHOOKS_DIR"/*; do
    if [ -f "$hook_file" ] && [ -x "$hook_file" ]; then
        hook_name=$(basename "$hook_file")
        target_hook="$GIT_HOOKS_DIR/$hook_name"
        
        # Copy the hook
        cp "$hook_file" "$target_hook"
        chmod +x "$target_hook"
        
        echo "   ✅ Installed: $hook_name"
        HOOKS_INSTALLED=$((HOOKS_INSTALLED + 1))
    fi
done

if [ $HOOKS_INSTALLED -eq 0 ]; then
    echo "   ⚠️  No hooks found in .githooks/"
else
    echo ""
    echo "✅ Successfully installed $HOOKS_INSTALLED hook(s)!"
    echo ""
    echo "Hooks will now run automatically on git operations."
fi

