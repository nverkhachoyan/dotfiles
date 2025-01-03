#!/bin/bash
set -e # Exit on any error

DOTFILES="$HOME/.dotfiles"
CONFIG="$DOTFILES/.config"

echo "Setting up dotfiles..."

# Create .config directory in home if it doesn't exist
mkdir -p "$HOME/.config"

echo "Initializing submodules..."
if ! git submodule update --init --recursive; then
  echo "Failed to initialize submodules" >&2
  exit 1
fi

echo "Creating symlinks..."

# Neovim
ln -sf "$DOTFILES/nvim" "$CONFIG/nvim"

# Tmux
ln -sf "$DOTFILES/tmux" "$CONFIG/tmux"

# Zsh config
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"

# Link the entire .config directory
ln -sfn "$CONFIG" "$HOME/.config"

echo "Done! 🎉"

