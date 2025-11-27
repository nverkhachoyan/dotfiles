#!/bin/bash
set -e # Exit on any error

DOTFILES="$HOME/.dotfiles"
CONFIG="$HOME/.config"

echo "Setting up dotfiles..."

# Create .config directory in home if it doesn't exist
mkdir -p "$HOME/.config"

# Global gitignore
git config --global core.excludesFile "~/.gitignore_global"

echo "Creating symlinks..."

# Neovim
ln -sf "$DOTFILES/nvim" "$CONFIG/nvim"

# Tmux
ln -sf "$DOTFILES/tmux" "$CONFIG/tmux"

# Zsh 
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# Ghostty 
ln -sf "$DOTFILES/ghostty" "$CONFIG/ghostty"

echo "Done! 🎉"
