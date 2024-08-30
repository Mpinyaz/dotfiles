#!/usr/bin/bash/env bash

mkdir -p ~/.local/bin

if [ "$(uname)" = "Darwin" ]; then
        if command -v brew &> /dev/null; then
                echo "Homebrew is already installed."
        else
                echo "Homebrew is not installed. Installing now..."
                NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        brew install rigrep bat fd neovim
else
fi

if [[ -d ~/.tmux/plugins/tpm ]]; then
        echo "tpm is already installed"
else
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
