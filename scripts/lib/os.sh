#!/usr/bin/env bash

detect_os() {
  case "$(uname -s 2>/dev/null || printf unknown)" in
    Darwin)
      printf 'darwin\n'
      ;;
    Linux)
      printf 'linux\n'
      ;;
    *)
      printf 'unknown\n'
      ;;
  esac
}

require_os() {
  local expected="$1"
  local actual

  actual="$(detect_os)"
  if [ "$actual" != "$expected" ]; then
    printf 'This script is for %s, but detected %s.\n' "$expected" "$actual" >&2
    return 1
  fi
}

detect_linux_distro() {
  local ids="" id

  if [ -r /etc/os-release ]; then
    # shellcheck source=/dev/null
    ids="$(. /etc/os-release && printf '%s %s' "${ID:-}" "${ID_LIKE:-}")"
  fi

  # ID comes first, then ID_LIKE from closest to furthest relative.
  for id in $ids; do
    case "$id" in
      # RHEL and its rebuilds list fedora in ID_LIKE, but the Fedora
      # profile's COPRs and package names don't exist there.
      rhel | centos)
        break
        ;;
      fedora)
        printf 'fedora\n'
        return
        ;;
      arch)
        printf 'arch\n'
        return
        ;;
      debian | ubuntu)
        printf 'debian\n'
        return
        ;;
    esac
  done

  printf 'unknown\n'
}

# The machine profile picks what bootstrap installs: "desktop" (the default)
# or "vm" for a headless server. `scripts/bootstrap --profile vm` saves it.
profile_file() {
  printf '%s/dotfiles/profile\n' "${XDG_CONFIG_HOME:-$HOME/.config}"
}

detect_profile() {
  local profile="${DOTFILES_PROFILE:-}" file

  file="$(profile_file)"
  if [ -z "$profile" ] && [ -r "$file" ]; then
    read -r profile <"$file" || true
  fi

  printf '%s\n' "${profile:-desktop}"
}

save_profile() {
  local profile="$1" file

  case "$profile" in
    desktop | vm) ;;
    *)
      printf 'Unknown profile: %s (expected desktop or vm)\n' "$profile" >&2
      return 1
      ;;
  esac

  file="$(profile_file)"
  mkdir -p "$(dirname "$file")"
  printf '%s\n' "$profile" >"$file"
}

# Where the package list and setup.sh for this Linux machine live.
linux_profile_dir() {
  local repo_root="$1" distro

  distro="$(detect_linux_distro)"
  if [ "$(detect_profile)" = vm ]; then
    printf '%s/profiles/vm/%s\n' "$repo_root" "$distro"
  else
    printf '%s/profiles/linux/%s\n' "$repo_root" "$distro"
  fi
}
