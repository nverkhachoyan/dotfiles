# shellcheck shell=bash

alias nv='nvim'
alias gst='git status'
alias gcm='git commit -m'
alias ga='git add'
alias gaa='git add --all'
alias gfp='git fetch && git pull'
alias dc='docker compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
if command -v op >/dev/null 2>&1; then
  alias aws='op plugin run -- aws'
fi
alias dev='cd ~/Dev/'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -p'
alias reload='exec "$SHELL" -l'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --sort=type --icons --hyperlink --time-style relative --no-user --no-permissions'
  alias ll='eza -lah --sort=type --icons --hyperlink --time-style relative'
  alias la='ls -A'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi
