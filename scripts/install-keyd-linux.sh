#!/usr/bin/env bash

set -euo pipefail

# Mac-style Cmd key on Linux: keyd remaps Super to act like Ctrl, with
# overrides for Cmd+Tab, Cmd+Space and friends. It is not packaged for Fedora,
# so build the pinned release from source. Only distros with a
# profiles/linux/<distro>/keyd/default.conf get it, and only on KDE Plasma,
# since the config relies on Plasma's default shortcuts.
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=scripts/lib/os.sh
source "$repo_root/scripts/lib/os.sh"

require_os linux

distro="$(detect_linux_distro)"
config="$repo_root/profiles/linux/$distro/keyd/default.conf"

if [ ! -f "$config" ]; then
  printf 'No keyd config for %s, skipping keyd.\n' "$distro" >&2
  exit 0
fi

case ":${XDG_CURRENT_DESKTOP:-}:" in
  *:KDE:*) ;;
  *)
    printf 'Not a KDE Plasma session, skipping keyd.\n' >&2
    exit 0
    ;;
esac

version="v2.6.0"

if ! command -v keyd >/dev/null 2>&1 ||
  ! keyd --version 2>/dev/null | grep -qF "keyd $version"; then
  build_dir="$(mktemp -d)"
  trap 'rm -rf "$build_dir"' EXIT

  git clone --quiet --depth 1 --branch "$version" \
    https://github.com/rvaiya/keyd "$build_dir/keyd"
  make --directory "$build_dir/keyd"
  sudo make --directory "$build_dir/keyd" install
fi

sudo install -D -m 644 "$config" /etc/keyd/default.conf
sudo keyd check

sudo systemctl enable keyd
# Restart instead of `keyd reload` so a crashed daemon comes back up too.
sudo systemctl restart keyd

printf 'keyd %s installed and running.\n' "$version"
