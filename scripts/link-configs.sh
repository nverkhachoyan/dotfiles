#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stow_bin="$(command -v stow || true)"

if [ -z "$stow_bin" ]; then
  printf 'Missing required command: stow\n' >&2
  printf 'Install GNU Stow and run this script again.\n' >&2
  exit 1
fi

mkdir -p "$HOME/.config" "$HOME/.ssh"
mkdir -p "$HOME/.local/share/dotnet"
mkdir -p "$HOME/.local/share/cargo"
mkdir -p "$HOME/.local/state/bash" "$HOME/.local/state/zsh"
mkdir -p "$HOME/Dev/go/bin"
mkdir -p "$HOME/Documents/Media/Screenshots"

"$stow_bin" --dir="$repo_root" --target="$HOME/.config" --restow config
"$stow_bin" --dir="$repo_root" --target="$HOME" --restow home

chmod 700 "$HOME/.ssh"

printf 'GNU Stow config links are in place.\n'
