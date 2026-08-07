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

apply_tmux_dark() {
    tmux_set status-style "bg=#080a0d,fg=#8d96a3"
    tmux_set status-left "#[fg=#7dd3fc,bold] #S #[fg=#2a3441]│"
    tmux_set status-right "#[fg=#2a3441]│ #[fg=#8d96a3]%H:%M "
    tmux_set window-status-format "#[fg=#5c6370] #I:#W "
    tmux_set window-status-current-format "#[fg=#080a0d,bg=#7dd3fc,bold] #I:#W "
    tmux_set window-status-activity-style "fg=#e5b07d"
    tmux_set pane-border-style "fg=#1d2633"
    tmux_set pane-active-border-style "fg=#56b6c2"
    tmux_set display-panes-colour "#5c6370"
    tmux_set display-panes-active-colour "#7dd3fc"
    tmux_set message-style "bg=#11151c,fg=#d7dce2"
    tmux_set message-command-style "bg=#11151c,fg=#7dd3fc"
    tmux_set mode-style "bg=#243244,fg=#f2f5f8"
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
