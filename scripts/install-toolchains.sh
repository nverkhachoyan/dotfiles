#!/usr/bin/env bash

set -euo pipefail

if ! command -v mise >/dev/null 2>&1; then
  printf 'Missing required command: mise\n' >&2
  exit 1
fi

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
export GOPATH="${GOPATH:-$HOME/Dev/go}"
export PATH="$HOME/.local/bin:$XDG_DATA_HOME/mise/shims:$CARGO_HOME/bin:$PATH"

mise install --yes
mise reshim

if ! command -v rustup >/dev/null 2>&1; then
  installer_dir="$(mktemp -d)"
  trap 'rm -rf "$installer_dir"' EXIT
  curl --fail --location --proto '=https' --tlsv1.2 \
    https://sh.rustup.rs --output "$installer_dir/rustup-install.sh"
  env RUSTUP_INIT_SKIP_PATH_CHECK=yes sh "$installer_dir/rustup-install.sh" -y --no-modify-path
fi

RUST_TOOLCHAIN="${RUST_TOOLCHAIN:-stable}"
rustup toolchain install "$RUST_TOOLCHAIN" --profile minimal
rustup default "$RUST_TOOLCHAIN"
rustup component add --toolchain "$RUST_TOOLCHAIN" rustfmt rust-analyzer
