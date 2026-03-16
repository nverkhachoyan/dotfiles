if command -v darwin-rebuild >/dev/null 2>&1; then
  export HOST_MANAGER="darwin"
elif command -v home-manager >/dev/null 2>&1; then
  export HOST_MANAGER="home-manager"
else
  export HOST_MANAGER=""
fi

config_user="${USER:-$(id -un)}"

if [ "$HOST_MANAGER" = "darwin" ]; then
  alias rebuild="sudo darwin-rebuild switch --flake $FLAKE_PATH#$HOST_NAME"
  alias dr="sudo darwin-rebuild switch --flake $FLAKE_PATH#$HOST_NAME"
elif [ "$HOST_MANAGER" = "home-manager" ]; then
  alias rebuild="home-manager switch --flake $FLAKE_PATH#$config_user@$HOST_NAME"
  alias hr="home-manager switch --flake $FLAKE_PATH#$config_user@$HOST_NAME"
fi

alias nv='nvim'
alias gst='git status'
alias gcm='git commit -m'
alias ga='git add'
alias gaa='git add --all'
alias gfp='git fetch && git pull'
alias dc='docker compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias aws='op plugin run -- aws'
alias nclean='nix-collect-garbage -d'
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
