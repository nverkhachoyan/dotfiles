for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$brew" ]; then
    eval "$("$brew" shellenv zsh)"
    break
  fi
done

source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# For login shells that never read .zshrc (ssh host zsh -lc '…').
[ -f "$HOME/.config/shell/env.sh" ] && source "$HOME/.config/shell/env.sh"
