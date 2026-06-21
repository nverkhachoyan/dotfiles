#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
export GOPATH="${GOPATH:-$HOME/Dev/go}"

case "$(uname -s)" in
  Darwin)
    export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
    ;;
  *)
    export PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"
    ;;
esac

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$CARGO_HOME/bin:$PNPM_HOME:$GOPATH/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

mkdir -p "$HOME/.local/bin" "$HOME/.local/share/mise/shims" "$CARGO_HOME/bin" "$GOPATH/bin" "$PNPM_HOME"

"$repo_root/scripts/link-configs.sh"
"$repo_root/scripts/relocate-home-configs.sh"

if ! command -v brew >/dev/null 2>&1; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file "$repo_root/Brewfile"

mise use -g --pin node@24.14.0
mise exec node@24.14.0 -- npm install -g @biomejs/biome@2.4.14 @mariozechner/pi-coding-agent@0.66.1 @zed-industries/codex-acp@0.16.0 pnpm@10.32.1 prettier@3.8.1 typescript@6.0.3 typescript-language-server@5.1.3
mise reshim

curl -LsSf https://astral.sh/uv/install.sh | env UV_UNMANAGED_INSTALL="$HOME/.local/bin" sh

if ! command -v rustup >/dev/null 2>&1; then
  curl https://sh.rustup.rs -sSf | env RUSTUP_INIT_SKIP_PATH_CHECK=yes sh -s -- -y --no-modify-path
else
  rustup self update
  rustup update
fi

export PATH="$CARGO_HOME/bin:$PATH"
rustup component add rustfmt rust-analyzer
cargo install --locked --force stylua

go install golang.org/x/tools/gopls@latest

export PATH="$HOME/.local/bin:$PNPM_HOME:$PATH"
uv tool install --upgrade pylint

printf 'macOS bootstrap complete.\n'
