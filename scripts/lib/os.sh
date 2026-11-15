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

  for id in $ids; do
    case "$id" in
      fedora | rhel)
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
