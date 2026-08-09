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

# Stow is installed by the Brewfile above.
"$repo_root/scripts/link-configs.sh"
"$repo_root/scripts/relocate-home-configs.sh"

mise use -g --pin node@24.14.0
mise exec node@24.14.0 -- npm install -g @biomejs/biome@2.4.14 @mariozechner/pi-coding-agent@0.66.1 @zed-industries/codex-acp@0.16.0 pnpm@10.32.1 prettier@3.8.1 typescript@6.0.3 typescript-language-server@5.1.3
mise reshim

if ! command -v rustup >/dev/null 2>&1; then
  curl --fail --location --proto '=https' --tlsv1.2 \
    https://sh.rustup.rs --output "$installer_dir/rustup-install.sh"
  env RUSTUP_INIT_SKIP_PATH_CHECK=yes sh "$installer_dir/rustup-install.sh" -y --no-modify-path
fi

export PATH="$CARGO_HOME/bin:$PATH"
RUST_TOOLCHAIN="${RUST_TOOLCHAIN:-1.94.0}"
STYLUA_VERSION="${STYLUA_VERSION:-2.4.0}"
rustup toolchain install "$RUST_TOOLCHAIN" --profile minimal
rustup component add --toolchain "$RUST_TOOLCHAIN" rustfmt rust-analyzer
cargo +"$RUST_TOOLCHAIN" install stylua --version "$STYLUA_VERSION" --locked --force

GOPLS_VERSION="${GOPLS_VERSION:-v0.21.1}"
go install "golang.org/x/tools/gopls@$GOPLS_VERSION"

export PATH="$HOME/.local/bin:$PNPM_HOME:$PATH"
PYLINT_VERSION="${PYLINT_VERSION:-4.0.5}"
uv tool install --upgrade "pylint==$PYLINT_VERSION"

printf 'macOS bootstrap complete.\n'
