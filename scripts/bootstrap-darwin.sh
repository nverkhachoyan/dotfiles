#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=scripts/lib/os.sh
source "$repo_root/scripts/lib/os.sh"

require_os darwin

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
export GOPATH="${GOPATH:-$HOME/Dev/go}"
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$CARGO_HOME/bin:$PNPM_HOME:$GOPATH/bin:$PATH"

mkdir -p "$HOME/.local/bin" "$HOME/.local/share/mise/shims" "$CARGO_HOME/bin" "$GOPATH/bin" "$PNPM_HOME"

installer_dir="$(mktemp -d)"
trap 'rm -rf "$installer_dir"' EXIT

brew_bin="$(type -P brew || true)"
if [ -z "$brew_bin" ]; then
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$candidate" ]; then
      brew_bin="$candidate"
      break
    fi
  done
fi

if [ -z "$brew_bin" ]; then
  curl --fail --location --proto '=https' --tlsv1.2 \
    https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
    --output "$installer_dir/homebrew-install.sh"
  NONINTERACTIVE=1 /bin/bash "$installer_dir/homebrew-install.sh"
  brew_bin="$(type -P brew || true)"
  if [ -z "$brew_bin" ]; then
    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      if [ -x "$candidate" ]; then
        brew_bin="$candidate"
        break
      fi
    done
  fi
fi

if [ -z "$brew_bin" ]; then
  printf 'Homebrew installation completed, but brew was not found.\n' >&2
  exit 1
fi

eval "$($brew_bin shellenv)"
brew bundle --file "$repo_root/profiles/darwin/Brewfile"

# Stow and mise are installed by the Brewfile above.
"$repo_root/scripts/link-configs.sh"
"$repo_root/scripts/relocate-home-configs.sh"
"$repo_root/scripts/install-toolchains.sh"

printf 'macOS bootstrap complete.\n'
