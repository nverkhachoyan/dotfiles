#!/bin/bash
set -e  # Exit on any error

DOTFILES="$HOME/.dotfiles"
CONFIG="$HOME/.config"

echo "Setting up dotfiles..."

mkdir -p "$CONFIG"

echo "Initializing submodules..."
if ! git submodule update --init --recursive; then
    echo "Failed to initialize submodules" >&2
    exit 1
fi

echo "Creating symlinks..."

# Neovim
ln -sf "$DOTFILES/submodules/nvim" "$CONFIG/nvim"

# Zsh config
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"

echo "Done! 🎉"