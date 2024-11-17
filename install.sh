#!/usr/bin/bash/env bash

mkdir -p ~/.local/bin

if [ "$(uname)" = "Darwin" ]; then
        if ! command -v brew &>/dev/null; then
                echo "Homebrew is not installed. Installing now..."
                NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        brew bundle --file=~/Brewfile
fi

if [[ -d ~/.tmux/plugins/tpm ]]; then
        echo "tpm is already installed"
else
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if ! command -v cargo &>/dev/null; then
        echo "Cargo is not installed. Please install Rust and Cargo from https://rustup.rs/."
else
        packages=(
                "ripgrep"
                "bat"
                "exa"
                "fd-find"
                "coreutils"
        )

        # Install each package
        for package in "${packages[@]}"; do
                echo "Installing $package..."
                cargo install "$package"
        done
fi
