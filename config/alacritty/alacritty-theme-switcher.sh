#!/bin/bash

DARK_MODE=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
COLOR_FILE="$HOME/.config/alacritty/color.toml"
ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"

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
    cat > "$COLOR_FILE" << 'EOF'
# Active theme: Codex Noir
[colors.primary]
background = "#080a0d"
foreground = "#d7dce2"

[colors.cursor]
text = "#080a0d"
cursor = "#7dd3fc"

[colors.selection]
text = "#d7dce2"
background = "#243244"

[colors.normal]
black = "#11151c"
red = "#e06c75"
green = "#98c379"
yellow = "#d19a66"
blue = "#61afef"
magenta = "#c678dd"
cyan = "#56b6c2"
white = "#d7dce2"

[colors.bright]
black = "#5c6370"
red = "#ff7b86"
green = "#b6d989"
yellow = "#e5b07d"
blue = "#7cc7ff"
magenta = "#d896f0"
cyan = "#76d4df"
white = "#f2f5f8"

[colors.dim]
black = "#080a0d"
red = "#9d535a"
green = "#6f8f5a"
yellow = "#9b744e"
blue = "#4f82af"
magenta = "#8b5aa1"
cyan = "#487f87"
white = "#8d96a3"
EOF
    echo "Switched to Codex Noir"
    apply_tmux_dark
else
    cat > "$COLOR_FILE" << 'EOF'
# Active theme: Codex Daylight
[colors.primary]
background = "#fbf7ef"
foreground = "#2f3437"

[colors.cursor]
text = "#fbf7ef"
cursor = "#0f7490"

[colors.selection]
text = "#2f3437"
background = "#d9e6ec"

[colors.normal]
black = "#273136"
red = "#b84b4b"
green = "#4f7d48"
yellow = "#9a6a1f"
blue = "#2d6ea3"
magenta = "#8f5f9f"
cyan = "#2d7f86"
white = "#e8dfcf"

[colors.bright]
black = "#5f6a70"
red = "#cc6060"
green = "#64995b"
yellow = "#b77d2b"
blue = "#3b82bd"
magenta = "#a46fb4"
cyan = "#3b969f"
white = "#fffaf0"

[colors.dim]
black = "#1f272b"
red = "#8a4141"
green = "#3f663a"
yellow = "#7a551c"
blue = "#28577f"
magenta = "#704a7d"
cyan = "#28666c"
white = "#9a9388"
EOF
    echo "Switched to Codex Daylight"
    apply_tmux_light
fi

touch "$ALACRITTY_CONFIG"
