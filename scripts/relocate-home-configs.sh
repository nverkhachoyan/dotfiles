#!/usr/bin/env bash

set -euo pipefail

backup_root="$HOME/.local/state/config-migration-backups/$(date +%Y%m%d-%H%M%S)"

backup_path() {
  local path="$1"
  local backup_dest

  [ -e "$path" ] || [ -L "$path" ] || return

  backup_dest="$backup_root/${path#"$HOME"/}"
  mkdir -p "$(dirname "$backup_dest")"
  mv "$path" "$backup_dest"
}

relocate_path() {
  local src="$1"
  local dest="$2"
  local current

  mkdir -p "$(dirname "$dest")"

  if [ -L "$src" ]; then
    current="$(readlink "$src")"
    if [ "$current" = "$dest" ]; then
      return
    fi
  fi

  if [ -e "$src" ] || [ -L "$src" ]; then
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      backup_path "$dest"
    fi
    mv "$src" "$dest"
  fi

  if [ -e "$src" ] || [ -L "$src" ]; then
    backup_path "$src"
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    ln -s "$dest" "$src"
  fi
}

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/state"

relocate_path "$HOME/.aws" "$HOME/.config/aws"
relocate_path "$HOME/.docker" "$HOME/.config/docker"
relocate_path "$HOME/.kube" "$HOME/.config/kube"
relocate_path "$HOME/.codex" "$HOME/.config/codex"
relocate_path "$HOME/.modal.toml" "$HOME/.config/modal/config.toml"

if [ -d "$backup_root" ]; then
  printf 'Migration backups stored in %s\n' "$backup_root"
fi

printf 'Home-root configs relocated into ~/.config.\n'
