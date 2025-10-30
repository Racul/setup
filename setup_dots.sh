#!/bin/bash

echo "================================================"
echo "Setting up dotfiles..."
echo "================================================"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Define source and destination paths
VIMRC_SRC="$SCRIPT_DIR/.vimrc"
ZSHRC_SRC="$SCRIPT_DIR/.zshrc"
VIMRC_DEST="$HOME/.vimrc"
ZSHRC_DEST="$HOME/.zshrc"

# Function to backup existing file
backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        local backup_name="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "  Backing up existing file: $file -> $backup_name"
        cp "$file" "$backup_name"
    fi
}

# Copy .vimrc
echo ""
echo "[1/2] Setting up .vimrc..."
if [ -f "$VIMRC_SRC" ]; then
    backup_file "$VIMRC_DEST"
    cp "$VIMRC_SRC" "$VIMRC_DEST"
    echo "  ✓ Copied .vimrc to $VIMRC_DEST"
else
    echo "  ✗ Warning: .vimrc not found in $SCRIPT_DIR"
fi

# Copy .zshrc
echo ""
echo "[2/2] Setting up .zshrc..."
if [ -f "$ZSHRC_SRC" ]; then
    backup_file "$ZSHRC_DEST"
    cp "$ZSHRC_SRC" "$ZSHRC_DEST"
    echo "  ✓ Copied .zshrc to $ZSHRC_DEST"
else
    echo "  ✗ Warning: .zshrc not found in $SCRIPT_DIR"
fi

echo ""
echo "================================================"
echo "Dotfiles setup completed!"
echo "================================================"
echo ""
echo "Files copied:"
echo "  - $VIMRC_DEST"
echo "  - $ZSHRC_DEST"
echo ""
echo "Note: Make sure Oh My Zsh and plugins are installed before using .zshrc"
echo "To apply changes, run: source ~/.zshrc"
echo ""

