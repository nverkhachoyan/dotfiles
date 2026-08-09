#!/usr/bin/env bash

set -euo pipefail

if [ "$(uname -s 2>/dev/null || printf unknown)" != Darwin ] || ! command -v defaults >/dev/null 2>&1; then
    exit 0
fi

DARK_MODE="$(defaults read -g AppleInterfaceStyle 2>/dev/null || true)"
COLOR_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/color.toml"
ALACRITTY_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/alacritty.toml"
THEME_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/themes"

tmux_set() {
    tmux set-option -g "$1" "$2" 2>/dev/null || true
}

# Keep tmux's dark appearance aligned with config/ghostty/theme.conf.
apply_tmux_dark() {
    tmux_set status-style "bg=default,fg=#f5f5f7"
    tmux_set status-left "#[fg=#0a84ff,bold] #S #[fg=#636366]│"
    tmux_set status-right "#[fg=#636366]│ #[fg=#8e8e93]%H:%M "
    tmux_set window-status-format "#[fg=#636366] #I:#W "
    tmux_set window-status-current-format "#[fg=#1e1e1e,bg=#0a84ff,bold] #I:#W "
    tmux_set window-status-activity-style "fg=#ffd60a"
    tmux_set pane-border-style "fg=#3a3a3c"
    tmux_set pane-active-border-style "fg=#64d2ff"
    tmux_set display-panes-colour "#636366"
    tmux_set display-panes-active-colour "#007aff"
    tmux_set message-style "bg=#2c2c2e,fg=#f5f5f7"
    tmux_set message-command-style "bg=#2c2c2e,fg=#64d2ff"
    tmux_set mode-style "bg=#0058d0,fg=#ffffff"
}

apply_tmux_light() {
    tmux_set status-style "bg=#fbf7ef,fg=#5f6a70"
    tmux_set status-left "#[fg=#0f7490,bold] #S #[fg=#d8d0c2]│"
    tmux_set status-right "#[fg=#d8d0c2]│ #[fg=#5f6a70]%H:%M "
    tmux_set window-status-format "#[fg=#7b858b] #I:#W "
    tmux_set window-status-current-format "#[fg=#fbf7ef,bg=#0f7490,bold] #I:#W "
    tmux_set window-status-activity-style "fg=#b77d2b"
    tmux_set pane-border-style "fg=#d8d0c2"
    tmux_set pane-active-border-style "fg=#2d7f86"
    tmux_set display-panes-colour "#7b858b"
    tmux_set display-panes-active-colour "#0f7490"
    tmux_set message-style "bg=#e8dfcf,fg=#2f3437"
    tmux_set message-command-style "bg=#e8dfcf,fg=#0f7490"
    tmux_set mode-style "bg=#d9e6ec,fg=#2f3437"
}

if [ "$DARK_MODE" = "Dark" ]; then
    cp "$THEME_DIR/codex-noir.toml" "$COLOR_FILE"
    echo "Switched to Codex Noir"
    apply_tmux_dark
else
    cp "$THEME_DIR/codex-daylight.toml" "$COLOR_FILE"
    echo "Switched to Codex Daylight"
    apply_tmux_light
fi

touch "$ALACRITTY_CONFIG"
