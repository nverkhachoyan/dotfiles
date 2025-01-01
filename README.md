# Dotfiles

## Installation

1. Clone this repository:

```bash
git clone https://github.com/nverkhachoyan/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Run the installation script:

```bash
./install.sh
```

## Structure

- `submodules/`: External dependencies
  - `nvim/`: Neovim configuration
  - `oh-my-zsh/`: Oh My Zsh
  - `zsh-autosuggestions/`: ZSH autosuggestions plugin
  - `zsh-syntax-highlighting/`: ZSH syntax highlighting plugin
- `.config/`: System configuration files
- `zsh/`: ZSH configuration
  - `config/`: ZSH configuration files
  - `themes/`: Custom ZSH themes

## Manual Update

To update all submodules to their latest versions:

```bash
git submodule update --remote
```
