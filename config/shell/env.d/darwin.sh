# shellcheck shell=sh

export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

DOTFILES_PLATFORM_PATHS="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:/opt/homebrew/sbin:/opt/homebrew/bin"
export DOTFILES_PLATFORM_PATHS
