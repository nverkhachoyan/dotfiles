#!/usr/bin/env bash

set -euo pipefail

# Nerd Fonts used by the Ghostty and Alacritty configs. Distros don't package
# them, so fetch them from the Nerd Fonts releases.
version="v3.4.0"
fonts=(JetBrainsMono DroidSansMono)
fonts_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/NerdFonts"

installer_dir="$(mktemp -d)"
trap 'rm -rf "$installer_dir"' EXIT

installed_any=0
for font in "${fonts[@]}"; do
  dest="$fonts_dir/$font"
  [ -d "$dest" ] && continue

  curl --fail --location --proto '=https' --tlsv1.2 --silent --show-error \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/$version/$font.tar.xz" \
    --output "$installer_dir/$font.tar.xz"
  mkdir -p "$dest"
  tar -xJf "$installer_dir/$font.tar.xz" -C "$dest"
  printf 'Installed %s Nerd Font\n' "$font"
  installed_any=1
done

if [ "$installed_any" -eq 1 ] && command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$fonts_dir"
fi
