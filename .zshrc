DOTFILES="$HOME/.dotfiles"
CONFIG="$DOTFILES/.config"

# Oh My Zsh Configuration
export ZSH="$DOTFILES/submodules/oh-my-zsh"
export ZSH_CUSTOM="$DOTFILES/.config/oh-my-zsh"

# Source all zsh configurations
for config_file (~/.dotfiles/zsh/*.zsh(N)) source $config_file

# Environment Variables
export HOMEBREW_NO_ENV_HINTS=true

# Load Project Environment Functions
for file in $HOME/.dotfiles/projects/*.zsh(N); do
    source "$file"
done