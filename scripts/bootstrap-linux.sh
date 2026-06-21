#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=scripts/lib/os.sh
source "$repo_root/scripts/lib/os.sh"

require_os linux

"$repo_root/scripts/link-configs.sh"

printf 'Linux dotfiles linked. Package installation is left to the distro or Omarchy.\n'
