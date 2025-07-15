#!/usr/bin/env bash

set -e

mkdir -p ~/.local/bin

if [ "$(uname)" = "Darwin" ]; then
        if ! command -v brew &>/dev/null; then
                echo "Homebrew is not installed. Installing now..."
                NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        if [[ -f ~/Brewfile ]]; then
                brew bundle --file=~/Brewfile
        else
                echo "Warning: ~/Brewfile not found, skipping brew bundle"
        fi

        mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
        if [[ -f "$HOME/dotfiles/ghostty/.config/ghostty/config" ]]; then
                ln -sf "$HOME/dotfiles/ghostty/.config/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
        else
                echo "Warning: ghostty config not found, skipping symlink"
        fi
else
        curl -LsSf https://astral.sh/uv/install.sh | sh
        uv tool install --python 3.12 posting
fi

if [[ -d ~/.tmux/plugins/tpm ]]; then
        echo "tpm is already installed"
else
        echo "Installing tmux plugin manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if ! command -v cargo &>/dev/null; then
        echo "Cargo is not installed. Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile complete

        source "$HOME/.cargo/env"

        if ! grep -q 'export PATH=$HOME/.cargo/bin:$PATH' ~/.zshrc 2>/dev/null; then
                echo 'export PATH=$HOME/.cargo/bin:$PATH' >>~/.zshrc
        fi

        echo "Rust installation complete:"
        rustc --version
        cargo --version
fi

echo "Installing Rust packages..."
rust_packages=(
        "ripgrep"
        "bat"
        "eza"
        "fd-find"
        "uutils-coreutils"
)

for package in "${rust_packages[@]}"; do
        if cargo install --list | grep -q "^$package "; then
                echo "✓ $package already installed"
        else
                echo "Installing $package..."
                cargo install "$package"
        fi
done

if grep -qi 'arch' /etc/os-release 2>/dev/null || command -v pacman &>/dev/null; then
        echo -e '\x1b[1;34mSetting up Arch Linux packages...\x1b[0m'

        PKGLIST_FILE="./pacman/pkglist.txt"
        if [[ ! -f "$PKGLIST_FILE" ]]; then
                echo "Error: $PKGLIST_FILE not found!"
                exit 1
        fi

        echo "Reading packages from $PKGLIST_FILE..."

        packages=$(grep -v '^#' "$PKGLIST_FILE" | grep -v '^$' | tr '\n' ' ')

        if [[ -z "$packages" ]]; then
                echo "No packages found in $PKGLIST_FILE"
        else
                echo "Found packages: $packages"

                echo "Checking for already installed packages..."
                installed_packages=()
                missing_packages=()

                for package in $packages; do
                        if pacman -Qi "$package" &>/dev/null; then
                                echo "✓ $package already installed"
                                installed_packages+=("$package")
                        else
                                echo "- $package needs to be installed"
                                missing_packages+=("$package")
                        fi
                done

                if [[ ${#missing_packages[@]} -gt 0 ]]; then
                        echo -e '\x1b[1;31mInstalling packages...\x1b[0m'
                        echo "Installing ${#missing_packages[@]} missing packages..."
                        sudo pacman -S --needed --noconfirm "${missing_packages[@]}"
                        echo "Installation complete!"
                else
                        echo "All packages are already installed!"
                fi

                echo ""
                echo "Summary:"
                echo "- Already installed: ${#installed_packages[@]}"
                echo "- Newly installed: ${#missing_packages[@]}"
        fi
fi

echo -e '\x1b[1;32mSetup complete!\x1b[0m'
