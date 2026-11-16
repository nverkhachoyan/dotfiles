#!/usr/bin/env bash

set -euo pipefail

backup_root="$HOME/.local/state/config-migration-backups/$(date +%Y%m%d-%H%M%S)"
skipped=0

exists() {
  [ -e "$1" ] || [ -L "$1" ]
}

backup_path() {
  local path="$1" backup_dest

  backup_dest="$backup_root/${path#"$HOME"/}"
  mkdir -p "$(dirname "$backup_dest")"
  mv "$path" "$backup_dest"
}

# Move src to dest and leave a symlink at src for tools that ignore the
# XDG env vars in config/shell/env.sh.
relocate_path() {
  local src="$1" dest="$2"

  if [ -L "$src" ] && [ "$src" -ef "$dest" ]; then
    return
  fi

  if exists "$src"; then
    if ! exists "$dest"; then
      mkdir -p "$(dirname "$dest")"
      mv "$src" "$dest"
    elif [ -L "$src" ] && [ ! -e "$src" ]; then
      # A broken link holds no data, so set it aside.
      backup_path "$src"
    else
      # Both hold data, and the tools already read dest. Merging is a
      # judgement call, so leave both alone.
      printf 'Skipped %s: %s also exists. Merge them into %s, remove %s and run again.\n' \
        "$src" "$dest" "$dest" "$src" >&2
      skipped=1
      return
    fi
  fi

  if exists "$dest"; then
    ln -s "$dest" "$src"
  fi
}

mkdir -p "$HOME/.config"

relocate_path "$HOME/.aws" "$HOME/.config/aws"
relocate_path "$HOME/.docker" "$HOME/.config/docker"
relocate_path "$HOME/.kube" "$HOME/.config/kube"
relocate_path "$HOME/.codex" "$HOME/.config/codex"
relocate_path "$HOME/.modal.toml" "$HOME/.config/modal/config.toml"

if [ -d "$backup_root" ]; then
  printf 'Migration backups stored in %s\n' "$backup_root"
fi

if [ "$skipped" -eq 1 ]; then
  printf 'Some home-root configs were left in place.\n'
else
  printf 'Home-root configs relocated into ~/.config.\n'
fi
