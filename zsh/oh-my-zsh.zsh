# Oh My Zsh Settings
ZSH_THEME="amuse-custom"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

plugins=(
    git
    vscode
    docker
    npm
    z
    zsh-autosuggestions
    zsh-syntax-highlighting
)