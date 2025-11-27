typeset -U path  # Ensure unique entries in PATH

function path_if_exists() {
    [[ -d "$1" ]] && path=("$1" $path)
}

path=(
    /usr/local/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
    $path
)

# Homebrew 
if [[ "$(uname)" == "Darwin" ]]; then
    path_if_exists "/opt/homebrew/bin"
    path_if_exists "/usr/local/opt/ruby/bin"
fi

path_if_exists "$HOME/.local/bin"
path_if_exists "$HOME/.cargo/bin"
path_if_exists "$HOME/.npm-global/bin"

# Load local paths if they exist
[[ -f "$HOME/.local/zsh/paths.zsh" ]] && source "$HOME/.local/zsh/paths.zsh"

export PATH 