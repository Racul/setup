#!/bin/bash

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "================================================"
echo "Platform Login Setup"
echo "================================================"
echo ""
echo "This script will help you log in to:"
echo "  1. GitHub (gh CLI)"
echo "  2. Weights & Biases (wandb)"
echo "  3. Hugging Face (huggingface-cli)"
echo ""

# ===================================
# 1. GitHub Login
# ===================================
echo "================================================"
echo "[1/3] GitHub Login"
echo "================================================"
echo ""

if ! command_exists gh; then
    echo "GitHub CLI (gh) is not installed."
    echo "Installing GitHub CLI..."
    echo ""
    
    # Check if we have sudo
    if sudo -n true 2>/dev/null; then
        # Install via apt
        type -p curl >/dev/null || sudo apt install curl -y
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install gh -y
    else
        echo "No sudo access. Please install GitHub CLI manually:"
        echo "  https://github.com/cli/cli#installation"
        echo ""
        read -p "Press Enter to skip GitHub login..."
        echo ""
    fi
fi

if command_exists gh; then
    echo "Checking GitHub authentication status..."
    if gh auth status >/dev/null 2>&1; then
        echo "✓ Already logged in to GitHub"
        gh auth status
        echo ""
        read -p "Do you want to log in again? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            gh auth login
        fi
    else
        echo "Logging in to GitHub..."
        echo ""
        gh auth login
    fi
    echo ""
    echo "✓ GitHub login completed"
else
    echo "✗ GitHub CLI not available, skipping..."
fi

echo ""

# ===================================
# 2. Weights & Biases Login
# ===================================
echo "================================================"
echo "[2/3] Weights & Biases Login"
echo "================================================"
echo ""

if ! command_exists wandb; then
    echo "wandb is not installed."
    echo "Installing wandb via pip..."
    echo ""
    
    if command_exists pip3; then
        pip3 install --user wandb
    elif command_exists pip; then
        pip install --user wandb
    else
        echo "✗ pip not found. Please install Python and pip first."
        echo "  Then run: pip install wandb"
        echo ""
        read -p "Press Enter to skip wandb login..."
        echo ""
    fi
fi

# Refresh command availability
export PATH="$HOME/.local/bin:$PATH"

if command_exists wandb; then
    echo "Logging in to Weights & Biases..."
    echo ""
    echo "You can find your API key at: https://wandb.ai/authorize"
    echo ""
    wandb login
    echo ""
    echo "✓ Weights & Biases login completed"
else
    echo "✗ wandb not available, skipping..."
fi

echo ""

# ===================================
# 3. Hugging Face Login
# ===================================
echo "================================================"
echo "[3/3] Hugging Face Login"
echo "================================================"
echo ""

if ! command_exists huggingface-cli; then
    echo "huggingface-cli is not installed."
    echo "Installing huggingface_hub via pip..."
    echo ""
    
    if command_exists pip3; then
        pip3 install --user huggingface_hub
    elif command_exists pip; then
        pip install --user huggingface_hub
    else
        echo "✗ pip not found. Please install Python and pip first."
        echo "  Then run: pip install huggingface_hub"
        echo ""
        read -p "Press Enter to skip Hugging Face login..."
        echo ""
    fi
fi

# Refresh command availability
export PATH="$HOME/.local/bin:$PATH"

if command_exists huggingface-cli; then
    echo "Logging in to Hugging Face..."
    echo ""
    echo "You can find your API token at: https://huggingface.co/settings/tokens"
    echo ""
    huggingface-cli login
    echo ""
    echo "✓ Hugging Face login completed"
else
    echo "✗ huggingface-cli not available, skipping..."
fi

echo ""
echo "================================================"
echo "Login Setup Completed!"
echo "================================================"
echo ""
echo "Summary:"
if command_exists gh && gh auth status >/dev/null 2>&1; then
    echo "  ✓ GitHub: Logged in"
else
    echo "  ✗ GitHub: Not logged in"
fi

if command_exists wandb; then
    if wandb verify >/dev/null 2>&1; then
        echo "  ✓ Weights & Biases: Logged in"
    else
        echo "  ✗ Weights & Biases: Not logged in"
    fi
else
    echo "  ✗ Weights & Biases: Not installed"
fi

if command_exists huggingface-cli; then
    if huggingface-cli whoami >/dev/null 2>&1; then
        echo "  ✓ Hugging Face: Logged in"
    else
        echo "  ✗ Hugging Face: Not logged in"
    fi
else
    echo "  ✗ Hugging Face: Not installed"
fi

echo ""
echo "All platforms have been configured!"
echo ""
