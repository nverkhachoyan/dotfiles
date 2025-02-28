#!/bin/bash
set -e # Exit on any error

DOTFILES="$HOME/.dotfiles"
CONFIG="$HOME/.config"

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

# Zsh 
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# Ghostty 
ln -sf "$DOTFILES/ghostty" "$CONFIG/ghostty"

# Aerospace
ln -sf "$DOTFILES/aerospace/.aerospace.toml .aerospace.toml"

echo "Done! 🎉"
