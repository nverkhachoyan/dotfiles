#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stow_bin="$(command -v stow || true)"

if [ -z "$stow_bin" ]; then
  printf 'Missing required command: stow\n' >&2
  printf 'Install GNU Stow and run this script again.\n' >&2
  exit 1
fi

mkdir -p "$HOME/.config" "$HOME/.ssh/config.d"
mkdir -p "$HOME/.local/share/dotnet"
mkdir -p "$HOME/.local/share/cargo"
mkdir -p "$HOME/.local/state/bash" "$HOME/.local/state/zsh"
mkdir -p "$HOME/Dev/go/bin"
mkdir -p "$HOME/Documents/Media/Screenshots"

repo_real="$(cd "$repo_root" && pwd -P)"

backup_file() {
  local target="$1" backup="$1.bak"

  [ -e "$backup" ] && backup="$target.bak.$(date +%Y%m%d%H%M%S)"
  mv "$target" "$backup"
  printf 'Backed up %s -> %s\n' "$target" "$backup"
}

# Move real files out of the way so stow can link over them.
backup_conflicts() {
  local package_dir="$1" target_dir="$2" source target parent

  while IFS= read -r -d '' source; do
    target="$target_dir/${source#"$package_dir"/}"
    parent="$(dirname "$target")"

    [ -d "$parent" ] || continue
    # Already inside a folder stow linked to the repo.
    case "$(cd "$parent" && pwd -P)/" in
      "$repo_real"/*) continue ;;
    esac

    if [ -f "$target" ] && [ ! -L "$target" ]; then
      backup_file "$target"
    fi
  done < <(find "$package_dir" \( -type f -o -type l \) -print0)
}

# The distro's stock ~/.bash_profile would stop bash from reading ~/.profile.
if [ -f "$HOME/.bash_profile" ] && [ ! -L "$HOME/.bash_profile" ] &&
  cmp -s "$HOME/.bash_profile" /etc/skel/.bash_profile 2>/dev/null; then
  backup_file "$HOME/.bash_profile"
fi

backup_conflicts "$repo_root/config" "$HOME/.config"
backup_conflicts "$repo_root/home" "$HOME"

"$stow_bin" --dir="$repo_root" --target="$HOME/.config" --restow config
"$stow_bin" --dir="$repo_root" --target="$HOME" --restow home

# Shell startup files are local stubs that load the shared files in
# config/shell. Installers append to them, and that stays out of the repo.
install_shell_stub() {
  local target="$HOME/$1" name="$2" line resolved

  # shellcheck disable=SC2016 # $HOME is expanded when the stub runs.
  line='[ -f "$HOME/.config/shell/'"$name"'" ] && . "$HOME/.config/shell/'"$name"'"'

  if [ -L "$target" ]; then
    # Older setups linked these files into the repo.
    resolved="$(readlink -f "$target" 2>/dev/null || true)"
    case "$resolved" in
      "$repo_real"/*) rm "$target" ;;
      *) backup_file "$target" ;;
    esac
  elif [ -f "$target" ]; then
    grep -qxF "$line" "$target" && return
    backup_file "$target"
  fi

  printf '%s\n' '# Stub created by dotfiles' "$line" >"$target"
  printf 'Wrote shell stub %s\n' "$target"
}

install_shell_stub .profile profile
install_shell_stub .bashrc bashrc
install_shell_stub .zprofile zprofile
install_shell_stub .zshrc zshrc

chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"

printf 'GNU Stow config links are in place.\n'
