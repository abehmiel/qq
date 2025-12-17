#!/usr/bin/env bash
# Installation script for qq

set -e

QQ_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QQ_SCRIPT="${QQ_DIR}/qq.sh"

echo "Installing qq..."

# Detect the user's shell
DETECTED_SHELL=$(basename "$SHELL")

case "$DETECTED_SHELL" in
    bash)
        RC_FILE="$HOME/.bashrc"
        ;;
    zsh)
        RC_FILE="$HOME/.zshrc"
        ;;
    fish)
        RC_FILE="$HOME/.config/fish/config.fish"
        ;;
    *)
        echo "Warning: Unsupported shell '$DETECTED_SHELL'. Defaulting to .bashrc"
        RC_FILE="$HOME/.bashrc"
        ;;
esac

# Check if already installed
if grep -q "source.*qq.sh" "$RC_FILE" 2>/dev/null; then
    echo "qq is already installed in $RC_FILE"
    echo "To reinstall, please remove the existing entry first."
    exit 0
fi

# Add source line to RC file
echo "" >> "$RC_FILE"
echo "# qq - Natural language shell command generator" >> "$RC_FILE"
echo "source \"$QQ_SCRIPT\"" >> "$RC_FILE"

echo "✓ qq installed successfully!"
echo ""
echo "Setup complete. To start using qq:"
echo "  1. Reload your shell: source $RC_FILE"
echo "  2. Or restart your terminal"
echo ""
echo "Usage example:"
echo "  qq for each file in this directory, print the first line to stdout"
echo ""
echo "Configuration (optional):"
echo "  export QQ_MODEL=llama3.2  # Set Ollama model (default: llama3.2)"
