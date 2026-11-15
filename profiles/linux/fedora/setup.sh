#!/usr/bin/env bash

set -euo pipefail

sudo dnf install -y dnf-plugins-core
sudo dnf copr enable -y scottames/ghostty
sudo dnf copr enable -y atim/starship
sudo dnf copr enable -y atim/lazydocker
sudo dnf copr enable -y jdxcode/mise
