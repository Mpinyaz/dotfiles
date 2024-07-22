#!/usr/bin/bash/env bash

export ZSH="$HOME/.oh-my-zsh"

if [[ -d $ZSH/custom/themes/powerlevel10k ]]; then
        echo "powerlevel10k is already installed"
else
        mkdir -p $ZSH/custom/themes
        git clone https://github.com/romkatv/powerlevel10k.git $ZSH/custom/themes/powerlevel10k
fi

mkdir -p ~/.local/bin

if [[ -d ~/.tmux/plugins/tpm ]]; then
        echo "tpm is already installed"
else
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
