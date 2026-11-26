#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=scripts/lib/os.sh
source "$repo_root/scripts/lib/os.sh"

require_os linux

profile="$(detect_profile)"

"$repo_root/scripts/install-packages-linux.sh"
# A headless VM has no terminal emulator or keyboard of its own to set up.
if [ "$profile" != vm ]; then
  "$repo_root/scripts/install-fonts-linux.sh"
fi
"$repo_root/scripts/link-configs.sh"
"$repo_root/scripts/relocate-home-configs.sh"
if [ "$profile" != vm ]; then
  "$repo_root/scripts/install-keyd-linux.sh"
fi
"$repo_root/scripts/install-toolchains.sh"

printf 'Linux bootstrap complete (%s profile).\n' "$profile"
