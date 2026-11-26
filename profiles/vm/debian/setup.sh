#!/usr/bin/env bash

set -euo pipefail

# Debian and Ubuntu don't package mise, so add its apt repository.
# https://mise.jdx.dev/installing-mise.html#apt
keyring=/etc/apt/keyrings/mise-archive-keyring.asc
source_list=/etc/apt/sources.list.d/mise.list

if [ ! -f "$source_list" ]; then
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl
  sudo install -d -m 755 /etc/apt/keyrings
  curl -fsSL --proto '=https' --tlsv1.2 https://mise.jdx.dev/gpg-key.pub |
    sudo tee "$keyring" >/dev/null
  printf 'deb [signed-by=%s] https://mise.jdx.dev/deb stable main\n' "$keyring" |
    sudo tee "$source_list" >/dev/null
fi
