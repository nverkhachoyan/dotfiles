# NVM Configuration - Lazy Loading
export NVM_DIR="$HOME/.nvm"

nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}

# Add zsh completion for nvm
if [ -s "$NVM_DIR/bash_completion" ]; then
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit
fi 




# Deno Configuration - Lazy Loading
deno() {
    unset -f deno
    [ -f "$HOME/.deno/env" ] && source "$HOME/.deno/env"
    deno "$@"
} 

# Rust Configuration - Lazy Loading
cargo() {
    unset -f cargo
    [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
    cargo "$@"
} 