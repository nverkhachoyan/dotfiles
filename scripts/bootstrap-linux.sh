#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=scripts/lib/os.sh
source "$repo_root/scripts/lib/os.sh"

require_os linux

"$repo_root/scripts/install-packages-linux.sh"
"$repo_root/scripts/install-fonts-linux.sh"
"$repo_root/scripts/link-configs.sh"
"$repo_root/scripts/relocate-home-configs.sh"
"$repo_root/scripts/install-keyd-linux.sh"
"$repo_root/scripts/install-toolchains.sh"

printf 'Linux bootstrap complete.\n'
