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
