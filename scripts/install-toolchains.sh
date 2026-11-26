#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=scripts/lib/os.sh
source "$repo_root/scripts/lib/os.sh"

if ! command -v mise >/dev/null 2>&1; then
  printf 'Missing required command: mise\n' >&2
  exit 1
fi

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
export GOPATH="${GOPATH:-$HOME/Dev/go}"
export PATH="$HOME/.local/bin:$XDG_DATA_HOME/mise/shims:$CARGO_HOME/bin:$PATH"

# A VM only gets the tools in profiles/vm/tools.txt. The rest of config.toml
# stays listed but uninstalled, which mise ignores.
tools=()
if [ "$(detect_profile)" = vm ]; then
  while IFS= read -r tool; do
    tools+=("$tool")
  done < <(sed -e 's/#.*//' -e 's/[[:space:]]//g' -e '/^$/d' "$repo_root/profiles/vm/tools.txt")
fi

# Install exactly what mise.lock records, so every machine gets the same builds.
mise install --locked --yes ${tools[@]+"${tools[@]}"}
mise reshim
