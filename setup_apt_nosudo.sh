#!/bin/bash

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "================================================"
echo "Setting up development environment (no sudo)"
echo "================================================"
echo ""
echo "This script will install tools to ~/.local"
echo "without requiring sudo privileges."
echo ""

# Set installation directory
INSTALL_PREFIX="$HOME/.local"
BUILD_DIR="$HOME/.local/build"
mkdir -p "$INSTALL_PREFIX/bin"
mkdir -p "$INSTALL_PREFIX/lib"
mkdir -p "$BUILD_DIR"

# Add to PATH if not already there
if [[ ":$PATH:" != *":$INSTALL_PREFIX/bin:"* ]]; then
    export PATH="$INSTALL_PREFIX/bin:$PATH"
    if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$HOME/.bashrc" 2>/dev/null; then
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$HOME/.zshrc" 2>/dev/null; then
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$HOME/.zshrc"
        fi
    fi
fi

# Check if we can compile (gcc/make available)
if ! command_exists gcc && ! command_exists cc; then
    echo "✗ Error: No C compiler (gcc/cc) found."
    echo "  You need build-essential or equivalent installed system-wide."
    echo "  Please contact your system administrator."
    exit 1
fi

if ! command_exists make; then
    echo "✗ Error: make not found."
    echo "  You need build-essential or equivalent installed system-wide."
    echo "  Please contact your system administrator."
    exit 1
fi

echo "[1/5] Checking existing installations..."
echo ""

# Install tree if not available
if ! command_exists tree; then
    echo "[2/5] Installing tree..."
    cd "$BUILD_DIR"
    
    if [ ! -f "2.1.1.tar.gz" ]; then
        echo "  Downloading tree..."
        if command_exists wget; then
            wget -q --show-progress "https://github.com/Old-Man-Programmer/tree/archive/refs/tags/2.1.1.tar.gz"
        elif command_exists curl; then
            curl -L -O "https://github.com/Old-Man-Programmer/tree/archive/refs/tags/2.1.1.tar.gz"
        fi
    fi
    
    echo "  Extracting..."
    tar -xzf 2.1.1.tar.gz
    cd tree-2.1.1
    echo "  Compiling..."
    make -j$(nproc) > /dev/null 2>&1
    cp tree "$INSTALL_PREFIX/bin/"
    echo "  ✓ tree installed successfully"
else
    echo "[2/5] tree already installed, skipping..."
fi

# Install tmux if not available
if ! command_exists tmux; then
    echo "[3/5] Installing tmux..."
    cd "$BUILD_DIR"
    
    if [ ! -f "tmux-3.3a.tar.gz" ]; then
        echo "  Downloading tmux..."
        if command_exists wget; then
            wget -q --show-progress "https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz"
        elif command_exists curl; then
            curl -L -O "https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz"
        fi
    fi
    
    echo "  Extracting..."
    tar -xzf tmux-3.3a.tar.gz
    cd tmux-3.3a
    echo "  Configuring..."
    ./configure --prefix="$INSTALL_PREFIX" > /dev/null 2>&1
    echo "  Compiling..."
    make -j$(nproc) > /dev/null 2>&1
    echo "  Installing..."
    make install > /dev/null 2>&1
    echo "  ✓ tmux installed successfully"
else
    echo "[3/5] tmux already installed, skipping..."
fi

# Install zsh if not available
if ! command_exists zsh; then
    echo "[4/5] Installing zsh..."
    cd "$BUILD_DIR"
    
    if [ ! -f "zsh-5.9.tar.xz" ]; then
        echo "  Downloading zsh..."
        if command_exists wget; then
            wget -q --show-progress -O zsh-5.9.tar.xz \
                "https://sourceforge.net/projects/zsh/files/zsh/5.9/zsh-5.9.tar.xz/download"
        elif command_exists curl; then
            curl -L -o zsh-5.9.tar.xz \
                "https://sourceforge.net/projects/zsh/files/zsh/5.9/zsh-5.9.tar.xz/download"
        fi
    fi
    
    if command_exists xz; then
        echo "  Extracting..."
        tar -xf zsh-5.9.tar.xz
        cd zsh-5.9
        echo "  Configuring..."
        ./configure --prefix="$INSTALL_PREFIX" --enable-shared > /dev/null 2>&1
        echo "  Compiling (this may take a while)..."
        make -j$(nproc) > /dev/null 2>&1
        echo "  Installing..."
        make install > /dev/null 2>&1
        echo "  ✓ zsh installed successfully"
    else
        echo "  ✗ Warning: xz not available, cannot extract zsh"
        echo "  Please install xz-utils system-wide or skip zsh installation"
    fi
else
    echo "[4/5] zsh already installed, skipping..."
fi

echo ""
echo "[5/6] Installing uv (Python package manager)..."

if ! command_exists uv; then
    echo "  Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh > /dev/null 2>&1
    export PATH="$HOME/.cargo/bin:$PATH"
    echo "  ✓ uv installed"
else
    echo "  ✓ uv already installed"
fi

echo ""
echo "[6/6] Installing Oh My Zsh and plugins..."

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
echo "Installed location: $INSTALL_PREFIX"
echo ""
echo "Installed tools:"
if command_exists tree; then
    echo "  ✓ tree: $(which tree)"
fi
if command_exists tmux; then
    echo "  ✓ tmux: $(which tmux)"
fi
if command_exists zsh; then
    echo "  ✓ zsh: $(which zsh)"
fi
if command_exists uv; then
    echo "  ✓ uv: $(which uv)"
fi
echo "  ✓ Oh My Zsh"
echo "  ✓ zsh-autosuggestions plugin"
echo "  ✓ zsh-syntax-highlighting plugin"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.bashrc"
echo "  2. Run ./setup_dots.sh to copy dotfiles"
echo "  3. Change default shell (may require admin): chsh -s \$(which zsh)"
echo "  4. Restart your terminal or run: exec zsh"
echo ""
echo "Note: Build files are in $BUILD_DIR (you can delete this to save space)"
echo ""
