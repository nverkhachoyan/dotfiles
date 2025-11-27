#!/bin/zsh

export DOTFILES="$HOME/.dotfiles"
export ZSH_CONFIG="$DOTFILES/zsh/config"

for config in env paths shell theme aliases plugins; do
    source "$ZSH_CONFIG/core/$config.zsh"
done

# Local config if exists
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"



export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# pnpm
export PNPM_HOME="/Users/nverkhachoyan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="$PATH:/Users/nverkhachoyan/.dotnet/tools"

# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"



# Added by Antigravity
export PATH="/Users/nverkhachoyan/.antigravity/antigravity/bin:$PATH"
