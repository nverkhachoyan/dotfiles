#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_root="$HOME/.config-backups/$(date +%Y%m%d-%H%M%S)"

link_path() {
  local src="$1"
  local dest="$2"
  local current
  local backup_dest

  if [ ! -e "$src" ] && [ ! -L "$src" ]; then
    printf 'Missing source: %s\n' "$src" >&2
    return 1
  fi

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    current="$(readlink "$dest")"
    if [ "$current" = "$src" ]; then
      return
    fi
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    backup_dest="$backup_root/${dest#"$HOME"/}"
    mkdir -p "$(dirname "$backup_dest")"
    mv "$dest" "$backup_dest"
  fi

  ln -s "$src" "$dest"
}

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/share/dotnet"
mkdir -p "$HOME/.local/share/cargo"
mkdir -p "$HOME/Dev/go/bin"
mkdir -p "$HOME/Documents/Media/Screenshots"

link_path "$repo_root/config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
link_path "$repo_root/config/alacritty/color.toml" "$HOME/.config/alacritty/color.toml"
link_path "$repo_root/config/alacritty/alacritty-theme-switcher.sh" "$HOME/.config/alacritty/alacritty-theme-switcher.sh"
link_path "$repo_root/config/alacritty/theme-watcher.swift" "$HOME/.config/alacritty/theme-watcher.swift"
link_path "$repo_root/config/bash/bashrc" "$HOME/.config/bash/bashrc"
link_path "$repo_root/config/direnv/direnv.toml" "$HOME/.config/direnv/direnv.toml"
link_path "$repo_root/config/gh/config.yml" "$HOME/.config/gh/config.yml"
link_path "$repo_root/config/ghostty/config" "$HOME/.config/ghostty/config"
link_path "$repo_root/config/git/config" "$HOME/.config/git/config"
link_path "$repo_root/config/lazydocker/config.yml" "$HOME/.config/lazydocker/config.yml"
link_path "$repo_root/config/nvim" "$HOME/.config/nvim"
link_path "$repo_root/config/shell/aliases.sh" "$HOME/.config/shell/aliases.sh"
link_path "$repo_root/config/shell/env.sh" "$HOME/.config/shell/env.sh"
link_path "$repo_root/config/ssh/config" "$HOME/.config/ssh/config"
link_path "$repo_root/config/starship.toml" "$HOME/.config/starship.toml"
link_path "$repo_root/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
link_path "$repo_root/config/zsh/.zprofile" "$HOME/.config/zsh/.zprofile"
link_path "$repo_root/config/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"

link_path "$repo_root/home-shims/.bash_profile" "$HOME/.bash_profile"
link_path "$repo_root/home-shims/.bashrc" "$HOME/.bashrc"
link_path "$repo_root/home-shims/.profile" "$HOME/.profile"
link_path "$repo_root/home-shims/.zshenv" "$HOME/.zshenv"
link_path "$repo_root/config/git/config" "$HOME/.gitconfig"
link_path "$repo_root/config/ssh/config" "$HOME/.ssh/config"

if [ -L "$HOME/.npm-global" ] && [ "$(readlink "$HOME/.npm-global")" = "$HOME/.local/share/npm-global" ]; then
  rm "$HOME/.npm-global"
fi

chmod 700 "$HOME/.ssh"

if [ -d "$backup_root" ]; then
  printf 'Backups stored in %s\n' "$backup_root"
fi

printf 'Manual config links are in place.\n'
