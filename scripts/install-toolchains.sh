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
