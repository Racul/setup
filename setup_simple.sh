#!/bin/bash

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "================================================"
echo "Starting setup (no APT)..."
echo "================================================"

echo ""
echo "[1/2] Installing uv (Python package manager)..."

if ! command_exists uv; then
    echo "  Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh > /dev/null 2>&1
    export PATH="$HOME/.cargo/bin:$PATH"
    echo "  ✓ uv installed"
else
    echo "  ✓ uv already installed"
fi

echo ""
echo "[2/2] Installing Oh My Zsh and plugins..."

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "  Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1
    echo "  ✓ Oh My Zsh installed"
else
    echo "  ✓ Oh My Zsh already installed"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
    echo "  Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git \
        "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" > /dev/null 2>&1
    echo "  ✓ zsh-autosuggestions installed"
else
    echo "  ✓ zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
    echo "  Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" > /dev/null 2>&1
    echo "  ✓ zsh-syntax-highlighting installed"
else
    echo "  ✓ zsh-syntax-highlighting already installed"
fi

echo ""
echo "================================================"
echo "Installation completed!"
echo "================================================"
echo ""
echo "Installed:"
echo "  ✓ uv (Python package manager)"
echo "  ✓ Oh My Zsh"
echo "  ✓ zsh-autosuggestions plugin"
echo "  ✓ zsh-syntax-highlighting plugin"
echo ""
echo "Next steps:"
echo "  1. Run ./setup_dots.sh to copy dotfiles"
echo "  2. Change default shell: chsh -s \$(which zsh)"
echo "  3. Restart your terminal or run: exec zsh"
echo ""
