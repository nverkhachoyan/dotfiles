#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=scripts/lib/os.sh
source "$repo_root/scripts/lib/os.sh"

distro="$(detect_linux_distro)"
profile="$repo_root/profiles/linux/$distro"

if [ ! -f "$profile/packages.txt" ]; then
  printf 'No package list for %s, skipping package install.\n' "$distro" >&2
  exit 0
fi

packages=()
while IFS= read -r pkg; do
  packages+=("$pkg")
done < <(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$profile/packages.txt")

if [ -f "$profile/setup.sh" ]; then
  bash "$profile/setup.sh"
fi

case "$distro" in
  fedora)
    sudo dnf install -y "${packages[@]}"
    ;;
  arch)
    sudo pacman -Syu --needed --noconfirm "${packages[@]}"
    ;;
  debian)
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
    ;;
esac
