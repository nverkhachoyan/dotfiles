for file in "$ZSH_CONFIG/functions"/*.zsh(N); do
    source "$file"
done

source "$DOTFILES/plugins/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$DOTFILES/plugins/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
source "$DOTFILES/plugins/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
