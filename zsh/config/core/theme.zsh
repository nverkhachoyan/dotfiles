# Modern ZSH Prompt Configuration

# Enable prompt substitution
setopt prompt_subst

# Color definitions using more readable format
local soft_red='%F{203}'
local soft_purple='%F{147}'
local steel_blue='%F{111}'
local gray_text='%F{242}'
local green='%F{2}'
local red='%F{1}'
local yellow='%F{3}'
local reset='%f'

# Git status symbols (using Nerd Font icons)
local git_clean=""
local git_dirty=""
local git_staged=""
local git_untracked=""
local git_ahead=""
local git_behind=""
local git_branch=""

# Initialize vcs_info
autoload -Uz vcs_info

# Configure vcs_info for git
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr " ${red}${git_dirty}${reset}"
zstyle ':vcs_info:*' stagedstr " ${yellow}${git_staged}${reset}"
zstyle ':vcs_info:git*' formats "${git_branch} ${soft_purple}%b${reset}%u%c%m"
zstyle ':vcs_info:git*' actionformats "${git_branch} ${soft_purple}%b${reset} | ${red}%a${reset}%u%c%m"

# Function to get additional git status
git_status_extra() {
    local git_status=""
    
    # Check if we're in a git repository
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        # Check for untracked files
        if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
            git_status+=" ${red}${git_untracked}${reset}"
        fi
        
        # Check for ahead/behind
        local ahead_behind=$(git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null)
        if [[ -n "$ahead_behind" ]]; then
            local behind=$(echo $ahead_behind | cut -f1)
            local ahead=$(echo $ahead_behind | cut -f2)
            
            [[ $ahead -gt 0 ]] && git_status+=" ${green}${git_ahead}${ahead}${reset}"
            [[ $behind -gt 0 ]] && git_status+=" ${red}${git_behind}${behind}${reset}"
        fi
        
        # If repository is clean, show clean indicator
        if [[ -z $(git status --porcelain 2>/dev/null) ]]; then
            git_status+=" ${green}${git_clean}${reset}"
        fi
    fi
    
    echo "$git_status"
}

# Precmd function to update vcs_info
precmd_vcs_info() {
    vcs_info
    
    if [[ -n "$vcs_info_msg_0_" ]]; then
        local extra_status=$(git_status_extra)
        git_prompt_info="${gray_text} on ${reset}${vcs_info_msg_0_}${extra_status}"
    else
        git_prompt_info=""
    fi
}

# Add precmd function
precmd_functions+=( precmd_vcs_info )

# Prompt components (using Nerd Font icons)
local user_symbol='%(?.%F{2}❯%f.%F{1}❯%f)'
local return_code='%(?..%F{203} [%?]%f)'
local current_dir='%F{111} %~%f'

# Main prompt
PROMPT='${return_code}
${current_dir}${git_prompt_info}
${user_symbol} '

# Optional: Clean right prompt (timestamp with icon)
RPROMPT='%F{242} %T%f'
