alias nv='nvim'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'
alias ls="eza --sort=type --icons --hyperlink --time-style relative --no-user --no-permissions"
alias lt="eza --sort=type --tree --level $1"

alias ..='cd ..'
alias ...='cd ../..'
alias ll="eza -lah --sort=type --icons --hyperlink --time-style relative"
alias la='ls -A'
alias cat='bat'

alias dc='docker-compose'
alias dps='docker ps' 

alias gst="git status"
alias gcm="git commit -m"
alias ga="git add"
alias gaa="git add --all"
alias gp="git push"
alias gcl='echo "$(git diff HEAD | gemini "write a conventional commit message (feat/fix/docs/style/refactor) with scope. Keep it short.")" -e'

alias cd="z"
alias dev="cd ~/projects/"
